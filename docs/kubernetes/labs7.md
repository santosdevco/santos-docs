# Deploy Cronjob to fetch siigo costs
En este lab se mostrara como desplegar `Siigo Costs` en minikube y configurar dos `cronjobs` para generar los costos de infraestructura mensualmente.
<!-- ![diagrama arquitectura](../img/docker-coins.png) -->

## Dockerizar la aplicacion

Siigo costs es una aplicacion creada en Python, no usa frameworks por ende la imagen de Docker es sencilla

```Dockerfile 
FROM python:slim-buster

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

WORKDIR /src

COPY requirements.txt /src/requirements.txt

RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r /src/requirements.txt
COPY . /src/


```
Agregar assets al archivo dockerignore para que no se  agregue la carpeta al contexto del build

```bash
$ echo 'assets/ >> .dockerignore'
```

Crear la imagen
*Nota:* Recureda primero apuntar al registry de Minukube

```bash
eval $(minikube -p minikube docker-env)
```

Ahora si ...

```bash
$ docker build . -t  santos/siigo-costs
```

## Crear el Cronjob
Se creara directamente un cronjob que baje la imagen creada, y se ejecute el primero de cada mes.
El script que ejecuta el cron es determinar el mes y el anio, y lanzar la app siigo costs.

```yaml

apiVersion: batch/v1
kind: CronJob
metadata:
  name: FerchTempCosts
spec:
  schedule: "*12 11 1 * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: siigo-costs-cron
            image: santos/siigo-costs
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - month=$(date +'%m');year=$(date +'%Y'); python manage.py fetch_costs $month $year $month $year 1 0;
            # - python manage.py fetch_costs $month $year $month $year 1 0;
          restartPolicy: OnFailure
          
```

Hace falta montar assets con un volumen al container, para eso primero se debe enlazar el volumen a la vm de minikube:

```bash
~costs_fetcher_docker$ minikube mount $PWD/assets:/siigo-costs/assets
📁  Mounting host path /home/informatica/dev1/prod_siigo_billing/costs_fetcher_docker/assets into VM as /siigo-costs/assets ...
    ▪ Mount type:   
    ▪ User ID:      docker
    ▪ Group ID:     docker
    ▪ Version:      9p2000.L
    ▪ Message Size: 262144
    ▪ Options:      map[]
    ▪ Bind Address: 192.168.39.1:44333
🚀  Userspace file server: ufs starting
✅  Successfully mounted /home/informatica/dev1/prod_siigo_billing/costs_fetcher_docker/assets to /siigo-costs/assets


```
Ahora modificaremos el yaml agregando el volumen

```sh

apiVersion: batch/v1
kind: CronJob
metadata:
  name: FerchTempCosts
spec:
  schedule: "*12 11 1 * *"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: siigo-costs-cron
            image: santos/siigo-costs
            imagePullPolicy: IfNotPresent
            command:
            - /bin/sh
            - -c
            - ls /src/assets/;sleep 20;month=$(date +'%m');year=$(date +'%Y'); python manage.py fetch_costs $month $year $month $year 1 0;

            volumeMounts:
              - name: assets
                mountPath: /src/assets
          restartPolicy: OnFailure
          volumes:
          - name: assets
            hostPath:
              path: /siigo-costs/assets
              type: Directory


```
Por ultimo aplicaremos el cronjob

```sh
$ kubect apply -f cronjob.yaml
```
