# Compartir archivos entre  dos containers en un Pod 
En este laboratorio se comunicaran dos `containers` que viven en un mismo `pod` usando `volumenes`.

![diagrama arquitectura](../img/k8s-multicontainer-pod-diagram.jpg)

1. Crear el el `pod` con un `volumen` , y dos `containers`
```yaml
# save as ./two-containers-and-volume.yaml
apiVersion: v1
kind: Pod
metadata:
  name: two-containers
spec:

  restartPolicy: Never

  volumes:
  - name: shared-data
    emptyDir: {}

  containers:

  - name: nginx-container
    image: nginx
    volumeMounts:
    - name: shared-data
      mountPath: /usr/share/nginx/html

  - name: debian-container
    image: debian
    volumeMounts:
    - name: shared-data
      mountPath: /pod-data
    command: ["/bin/sh"]
    args: ["-c", "echo Hello from the debian container > /pod-data/index.html"]

```
Como se puede ver se crea un `Pod` llamado `two-containers` y dentro de la especificacion se crea un `volumen` llamado `shared-data` , luego se crea un `container` llamado `nginx-container` montando el volumen en  `/usr/share/nginx/html`, y por ultimo se crea el `container` llamado `debian-container`, montando el volumen en  `/pod-data`. El segundo container ejecutara el siguiente comando y  terminara su ejecucion.
```bash
$ echo Hello from the debian container > /pod-data/index.html
```
El segundo container modificara el archivo `index.html` de la carpeta principal del servidor `nginx` del segundo container, ya que este esta en el volumen compartido.

2. Crear el `pod` usando `kubectl`
```bash
$ kubectl apply -f ./two-containers-and-volume.yaml 
  # pod/two-containers created
```

3. Para ver la informacion detallada del `pod`

```sh
$ kubectl get pod two-containers --output=yaml
```
```yaml linenums="1" title="output kubectl get pod two-containers"
apiVersion: v1
kind: Pod
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"name":"two-containers","namespace":"default"},"spec":{"containers":[{"image":"nginx","name":"nginx-container","volumeMounts":[{"mountPath":"/usr/share/nginx/html","name":"shared-data"}]},{"args":["-c","echo Hello from the debian container \u003e /pod-data/index.html"],"command":["/bin/sh"],"image":"debian","name":"debian-container","volumeMounts":[{"mountPath":"/pod-data","name":"shared-data"}]}],"restartPolicy":"Never","volumes":[{"emptyDir":{},"name":"shared-data"}]}}
  creationTimestamp: "2022-06-16T14:26:55Z"
  name: two-containers
  namespace: default
  resourceVersion: "35653"
  uid: a2f25f74-e860-465d-b0e9-1fbdfa9d8a1a
spec:
  containers:
  - image: nginx
    imagePullPolicy: Always
    name: nginx-container
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /usr/share/nginx/html
      name: shared-data
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-mvrgj
      readOnly: true
  - args:
    - -c
    - echo Hello from the debian container > /pod-data/index.html
    command:
    - /bin/sh
    image: debian
    imagePullPolicy: Always
    name: debian-container
    resources: {}
    terminationMessagePath: /dev/termination-log
    terminationMessagePolicy: File
    volumeMounts:
    - mountPath: /pod-data
      name: shared-data
    - mountPath: /var/run/secrets/kubernetes.io/serviceaccount
      name: kube-api-access-mvrgj
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
  - emptyDir: {}
    name: shared-data
  - name: kube-api-access-mvrgj
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
    lastTransitionTime: "2022-06-16T14:26:55Z"
    status: "True"
    type: Initialized
  - lastProbeTime: null
    lastTransitionTime: "2022-06-16T14:26:55Z"
    message: 'containers with unready status: [debian-container]'
    reason: ContainersNotReady
    status: "False"
    type: Ready
  - lastProbeTime: null
    lastTransitionTime: "2022-06-16T14:26:55Z"
    message: 'containers with unready status: [debian-container]'
    reason: ContainersNotReady
    status: "False"
    type: ContainersReady
  - lastProbeTime: null
    lastTransitionTime: "2022-06-16T14:26:55Z"
    status: "True"
    type: PodScheduled
  containerStatuses:
  - containerID: docker://fc3b98f854b9bb2a26c6abbe9879bffa4ae93ee16907aa725a99a5f90699a3c5
    image: debian:latest
    imageID: docker-pullable://debian@sha256:3f1d6c17773a45c97bd8f158d665c9709d7b29ed7917ac934086ad96f92e4510
    lastState: {}
    name: debian-container
    ready: false # (1)
    restartCount: 0
    started: false
    state:
      terminated:
        containerID: docker://fc3b98f854b9bb2a26c6abbe9879bffa4ae93ee16907aa725a99a5f90699a3c5
        exitCode: 0
        finishedAt: "2022-06-16T14:27:00Z"
        reason: Completed # (2)
        startedAt: "2022-06-16T14:27:00Z"
  - containerID: docker://00c92009ff5b762f5a26552f1515addbe118403ab4efbb1e2d1244c698f0ccb2
    image: nginx:latest
    imageID: docker-pullable://nginx@sha256:2bcabc23b45489fb0885d69a06ba1d648aeda973fae7bb981bafbb884165e514
    lastState: {}
    name: nginx-container
    ready: true
    restartCount: 0
    started: true
    state:
      running:
        startedAt: "2022-06-16T14:26:57Z"
  hostIP: 192.168.39.232
  phase: Running # (3)
  podIP: 172.17.0.16
  podIPs:
  - ip: 172.17.0.16
  qosClass: BestEffort
  startTime: "2022-06-16T14:26:55Z"

```

1. Es `false`  debido a que el contenedor solo ejecuta un `echo` y termina su ejecucion.

2. El `container` termino su ejecucion con `exito`.
3. El `container` nginx esta corriendo porque es un `servidor`.

Se puede ver que container `debian-container` termino su ejecucion y `nginx-container` sigue corriendo.



4. Entrar al contenedor `nginx-container`
```sh
$ kubectl exec -it two-containers -c nginx-container -- /bin/bash
```
5. Revisar el archivo `index.html` de la carpeta compartida
```sh
root@two-containers:/# cat /usr/share/nginx/html/index.html 
  # Hello from the debian container
```

6. Revisar la respuesta del servidor de `nginx`
```bash
root@two-containers:/# curl localhost
  # Hello from the debian container
```


```json

{"data":{"attributes":{"resource_names_by_hash":{"7d74f4592a9fd6ff":"POST businessloki.loki.svc.cluster.local:3100/loki/api/v1/push","5fc09ce97131f406":"POST dc.services.visualstudio.com/v2/track","424ed4ae196ebbaf":"POST rt.services.visualstudio.com/QuickPulseService.svc/ping"}},"type":"resource_names_by_hash"}}
```