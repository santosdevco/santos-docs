# 5. Comunicacion de dos PODS con un service NodePort
En este laboratorio se creara un servicio NodePort para que un pod pueda alcanzar a otro usando  un `SVCHOST`.
![diagrama arquitectura](../img/lab4-kub.png)

1. Para este laboratorio se creo una apliacion en flask que se conecta a una base de datos mongo, esta app tiene dos rutas, enviar mensaje, leer mensajes, los mensajes se guardan en la base de datos.
```py
#save as app.py 
from flask import Flask
from flask import jsonify
from pymongo import MongoClient
app = Flask(__name__) 
# se usa el host del Servicio NodePort
client = MongoClient("mongo.default.svc.cluster.local",27017)
db = client.test_db
@app.route("/")
def hello():
    return "works"

@app.route("/send_message/<sender>/<to>/<message>")
def send_message(sender,to,message):
    return str(db.messages.insert_one({'to':to,'message':message,'from':sender}).inserted_id)
@app.route("/get_messages/<to>")
def get_messages(to):
    messages =  list(db.messages.find({"to":to},{"_id":0}))

    if messages:
        db.messages.delete_many({"to":to})   
    print(messages)
    return jsonify(messages     )

```

2. Escribir el `Dockerfile`
```Dockerfile
FROM python:3.7
RUN mkdir /app
WORKDIR /app/
RUN pip install flask==2.0.0 pymongo

ADD . /app/

ENV FLASK_APP=app.py

ENTRYPOINT [ "flask"]
CMD [ "run", "--host", "0.0.0.0","-p", "5000" ]
```

3. Crear la imagen `santos/flask-messages-app-with-mongo` a partir del `Dockerfile`, apuntar al registry de `minikube`.

```bash
$ eval $(minikube -p minikube docker-env)
```
```bash
$ docker build . -t santos/flask-messages-app-with-mongo
```

4. Yaml de creacion de los dos `pods` usando `Deployments`
```yaml
# save as ./deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flask-messages
  namespace: default
spec:
  selector:
    matchLabels:
      app: flask-messages
  replicas: 1  # 
  template:
    metadata:
      labels:
        app: flask-messages
    spec:
      containers:
      - name: flask-messages
        image:  santos/flask-messages-app-with-mongo
        imagePullPolicy: Never
        ports:
        - containerPort: 5000

---
# Deploy de la db
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongo
  namespace: default
spec:
  selector:
    matchLabels:
      app: mongo
  replicas: 1  # 
  template:
    metadata:
      labels:
        app: mongo
    spec:
      containers:
      - name: mongo
        image:  mongo
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 27017
```


4. Ejecutar el `deploment.yaml`
```bash
$ kubectl apply -f ./deployment.yaml 
# deployment.apps/flask-messages created
# deployment.apps/mongo created

```

5. Revisar el estado del cluster
```sh
$ kubectl get pods

  # flask-messages-b54fdfbb-2kkrl   1/1     Running   0          40m
  # mongo-7f4df74f64-mdkgm          1/1     Running   0          40m

$ kubectl get deployments
NAME             READY   UP-TO-DATE   AVAILABLE   AGE
flask-messages   1/1     1            1           41m
mongo            1/1     1            1           41m

```

6. Yaml de creacion de servicios, uno para que la aplicacion pueda acceder a la db con un `hostname` y otra para poder acceder a la aplicacion desde la maquina local.

```yaml
#save as ./services.yaml


apiVersion: v1
kind: Service
metadata:
  
  name: mongo
  namespace: default
spec:
  ports:
  - port: 27017
    protocol: TCP
    targetPort: 27017
  selector:
    app: mongo
  type: NodePort

---
apiVersion: v1
kind: Service
metadata:
  name: flask-messages
  namespace: default
spec:
  ports:
  - port: 5000
    protocol: TCP
    targetPort: 5000
  selector:
    app: flask-messages
  type: NodePort

```


4. Crear los servicios `services.yaml`
```bash
$ kubectl apply -f ./services.yaml 
  # service/mongo created
  # service/flask-messages created


```

5. Revisar el estado del cluster

```bash
$ kubectl get services
  # NAME             TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)           AGE
  # flask-messages   NodePort    10.109.12.181   <none>        5000:31377/TCP    46m
  # kubernetes       ClusterIP   10.96.0.1       <none>        443/TCP           96m
  # mongo            NodePort    10.97.20.81     <none>        27017:31644/TCP   46m
```
7. Recordar  que kubernetes esta corriendo en una maquina virtual, por ende para poder acceder al servicio  `flask-messages` se debe obtener la url de acceso usando minikube
```sh
$ minikube service flask-messages  --url 
  #  http://192.168.39.95:31377
```

8. Usar la aplicacion 

```sh
# Enviar mensajes
curl http://192.168.39.95:31377/new_message/santos/juan/holajuan
# 62ae84f9ab010d71976d6c2a
curl http://192.168.39.95:31377/new_message/santos/juan/estoyenviandounmensajedesdekubernetes
# 62ae8531ab010d71976d6c2b


```
Leer mensajes
```sh
$ curl http://192.168.39.95:31377/get_messages/juan
```
```json
[
    {
        "from": "santos",
        "message": "holajuan",
        "to": "juan"
    },
    {
        "from": "santos",
        "message": "estoyenviandounmensajedesdekubernetes",
        "to": "juan"
    }
]
```

