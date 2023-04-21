# Ping desde entre dos containers de un mismo POD
En este laboratorio se mostrara que se pueden alcanzar containers en un mismo pod. En este laboratorio se usara la imagen `santos/flask-hello-world` de laboratorios atras, y tambien usara una configuracion sencilla nginx.

1. Crear el archivo de configuracion de nginx `nginx-vol/default.conf` el el directorio que vamos a enlazar con un volumen al container.
```conf
server {
    listen       80;
    listen  [::]:80;
    server_name  localhost;

    location /flask_app {
        proxy_pass http://127.0.0.1:5000/;   
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
Esta pequena configuracion sencilla de `ngnx` crea un `proxy_pass` de `localhost/flask_app` a `localhost:5000`, este es el puerto de escucha de la aplicacion de `flask` que se usara en este laboratorio.

2. Recordar que kubernetes no tiene comunicacion directa con nuestra maquina, tiene comunicacion directa con la maquina virtual que monta minikube, como se quiere montar un directorio de nuestra maquina como un volumen, primero se debe montar en la maquina virtual de minikube.
```sh
minikube mount nginx-vol/:/mynginx/
# 📁  Mounting host path myvol/ into VM as /mynginx/ ...
#     ▪ Mount type:   
#     ▪ User ID:      docker
#     ▪ Group ID:     docker
#     ▪ Version:      9p2000.L
#     ▪ Message Size: 262144
#     ▪ Options:      map[]
#     ▪ Bind Address: 192.168.39.1:40637
# 🚀  Userspace file server: ufs starting
# ✅  Successfully mounted myvol/ to /mynginx/

# 📌  NOTE: This process must stay alive for the mount to be accessible ...

```
El volumen estara montado mientras no terminemos este proceso. Ahora existe una carpeta llamada `/mynginx` en la `VM`.

3. Yaml de creacion del `Pod`
```yaml
# save as ./spec.yaml
apiVersion: v1
kind: Pod
metadata:
  name: two-containers-ping
spec:

  restartPolicy: Never
  volumes:
  - name: shared-data
    hostPath:
      path: /mynginx/
      type: Directory
  
  containers:

  - name: nginx-container
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /etc/nginx/conf.d
  - name: flask-test-app
    image: santos/flask-hello-world
    imagePullPolicy: Never
    # ports:
    # - containerPort: 5000

```


4. Crear el `pod` usando `kubectl`
```bash
$ kubectl apply -f ./spec.yaml 
  # pod/two-containers-ping created
```

5. Revisar el estado del nuevo `pod`
```sh
kubectl get pod two-containers-ping --output=yaml
```

```yaml linenums="1" title="output kubectl get pod" 
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"two-containers-ping","namespace":"default"},"spec":{"containers":[{"image":"nginx","name":"nginx-container","volumeMounts":[{"mountPath":"/etc/nginx/conf.d","name":"shared-data"}]},{"image":"santos/flask-hello-world","imagePullPolicy":"Never","name":"flask-test-app"}],"restartPolicy":"Never","volumes":[{"hostPath":{"path":"/mynginx/","type":"Directory"},"name":"shared-data"}]}}
  creationTimestamp: "2022-06-17T14:38:29Z"
  name: two-containers-ping
  namespace: default
  resourceVersion: "52327"
  uid: 6dbb4caa-87b3-498a-8c4a-a7aeb76842af
spec:
  containers:
  - image: nginx
    imagePullPolicy: Always
    name: nginx-container
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /etc/nginx/conf.d
      name: shared-data
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-8vpjq
      readOnly: true
  - image: santos/flask-hello-world
    imagePullPolicy: Never
    name: flask-test-app
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-8vpjq
      readOnly: true
  dnsPolicy: ClusterFirst
  enableServiceLinks: true
  nodeName: minikube
  preemptionPolicy: PreemptLowerPriority
  priority: 0
  restartPolicy: Never
  schedulerName: default-scheduler
  securityContext: {}
  serviceAccount: default
  serviceAccountName: default
  terminationGracePeriodSeconds: 30
  tolerations:
  - effect: NoExecute
    key: node.kubernetes.io/not-ready
    operator: Exists
    tolerationSeconds: 300
  - effect: NoExecute
    key: node.kubernetes.io/unreachable
    operator: Exists
    tolerationSeconds: 300
  volumes:
  - hostPath:
      path: /mynginx/
      type: Directory
    name: shared-data
  - name: kube-api-access-8vpjq
    projected:
      defaultMode: 420
      sources:
      - serviceAccountToken:
          expirationSeconds: 3607
          path: token
      - configMap:
          items:
          - key: ca.crt
            path: ca.crt
          name: kube-root-ca.crt
      - downwardAPI:
          items:
          - fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
            path: namespace
status:
  conditions:
  - lastProbeTime: null
    lastTransitionTime: "2022-06-17T14:38:29Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2022-06-17T14:38:31Z"
    status: "True"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2022-06-17T14:38:31Z"
    status: "True"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2022-06-17T14:38:29Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: docker://0b53b339b7c06b7475739cbde17795ce24f71bc8d7d2e41da07d220162b6475d
    image: santos/flask-hello-world:latest
    imageID: docker://sha256:105bc09b0a7e87f7344040742f1fa011e00e7a36bac1f1cabc8a5303ceb1db30
    lastState: {}
    name: flask-test-app
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2022-06-17T14:38:31Z"
  - containerID: docker://8175ac7cd60060159888a723b7a36a93486a38e9b6cd4379d7e86fbb4647375d
    image: nginx:latest
    imageID: docker-pullable://nginx@sha256:2bcabc23b45489fb0885d69a06ba1d648aeda973fae7bb981bafbb884165e514
    lastState: {}
    name: nginx-container
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2022-06-17T14:38:31Z"
  hostIP: 192.168.39.232
  phase: Running
  podIP: 172.17.0.16
  podIPs:
  - ip: 172.17.0.16
  qosClass: BestEffort
  startTime: "2022-06-17T14:38:29Z"

```
Como se puede ver los dos containers estan `Ready`

6. Entrar al container   `nginx-container`
```sh
$ kubectl exec -it two-containers-ping -c nginx-container -- /bin/bash
  # root@two-containers-ping:/
```

7. Hacer un get a `http://localhost/flask_app/`
```sh
$root@two-containers-ping:  curl http://localhost/flask_app
  # hello word from flask!
```
### Conclusion
Containers within a pod share an IP address and port space, and can find each other via localhost s