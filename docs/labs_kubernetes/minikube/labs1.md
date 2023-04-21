# 2. Load Balancer y una API Flask 

En este laboratorio se desplegara una aplicacion dockerizada hecha en `python` en `kubernetes`, agregando un `LoadBalancer`.

1. Crear el app de python
```py
#save as app.py 
from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "hello word from flask!"

if __name__ == "__main__":
    app.run(host='0.0.0.0', debug=True)
```

2. Crear el `Dockerfile`
```docker
FROM python:3.7
RUN mkdir /app
WORKDIR /app/
ADD . /app/
RUN pip install flask
CMD ["python", "/app/app.py"]
```

3. Construir la imagen, pero antes apuntar al registry de `minukube`.

```sh
$ eval $(minikube -p minikube docker-env)
```

```sh
$ docker build . -t santos/flask-hello-world
```

4. Crear archivo de configuracion `deployment.yml`

```yaml

apiVersion: v1
kind: Service
metadata:
  name: flask-test-service
spec:
  selector:
    app: flask-test-app # en nombre de la aplicacion que va a gestionar
  ports:
  - protocol: "TCP"
    port: 6000
    targetPort: 5000 # El puerto donde se expone  la aplicacion Flask
  type: LoadBalancer

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-test-app
spec:
  selector:
    matchLabels:
      app: flask-test-app
  replicas: 5  # 
  template:
    metadata:
      labels:
        app: flask-test-app
    spec:
      containers:
      - name: flask-test-app
        image: santos/flask-hello-world
        imagePullPolicy: Never
        ports:
        - containerPort: 5000

```


5. Aplicar el archivo de configuracion con `kubectl`.
```sh
$ kubectl create -f deployment.yml
    # service/flask-test-service created
    # deployment.apps/flask-test-app created
```

6. Revisar si se ejecuto correctamente.
```sh
$ kubectl get pods
  # NAME              READY STATUS            RESTARTS AGE
  # flask-test-app-c6b649857-2tgs5     1/1     Running            0                14s
  # flask-test-app-c6b649857-g7f28     1/1     Running            0                14s
  # flask-test-app-c6b649857-lh4nb     1/1     Running            0                14s
  # flask-test-app-c6b649857-rsdjr     1/1     Running            0                14s
  # flask-test-app-c6b649857-vmsj5     1/1     Running            0                14s

$ kubectl get services
  # NAME                  TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
  # flask-test-service    LoadBalancer   10.102.69.135    <pending>     6000:31902/TCP   81s

```

7. Obtener la url de acceso al LoadBalancer. Como se esta usando `minkube` se utiliza el siguiente comando.

```sh
$ minikube service example-service --url
  # http://192.168.39.232:31902
```
Si no se esta usando minikube se utiliza `kubectl describe`

```sh
$ kubectl describe services flask-test-service
  # Name:                     flask-test-service
  # Namespace:                default
  # Labels:                   <none>
  # Annotations:              <none>
  # Selector:                 app=flask-test-app
  # Type:                     LoadBalancer
  # IP Family Policy:         SingleStack
  # IP Families:              IPv4
  # IP:                       10.102.69.135
  # IPs:                      10.102.69.135
  # LoadBalancer Ingress:     192.168.39.232
  # Port:                     <unset>  6000/TCP
  # TargetPort:               5000/TCP
  # NodePort:                 <unset>  31902/TCP
  # Endpoints:                172.17.0.12:5000,172.17.0.3:5000,172.17.0.6:5000 + 2 more...
  # Session Affinity:         None
  # External Traffic Policy:  Cluster
  # Events:                   <none>

```

En la salida del comando se puede ver informacion del `LoadBalancer`, el primero que necesitamos es `LoadBalancer Ingress`.

8. Hacer un get al API:
```sh
$ curl  http://192.168.39.232:31902
  # hello word from flask!  
```