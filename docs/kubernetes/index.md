# Kubernetes
Mis anotaciones de kubernetes


## Preparacion de laboratorio local en linux

Herramientas necesarias:

- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
```bash
# download
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
# check checksum 
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
# install 
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
# check installation
kubectl version --client
```
<!-- - minikube con kvm o virtualbox -->
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
```bash
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
```
- [Quemu Kvm](https://linuxize.com/post/how-to-install-kvm-on-ubuntu-20-04/)
```sh
sudo apt install qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils virtinst virt-manager
sudo systemctl is-active libvirtd
sudo usermod -aG libvirt $USER
sudo usermod -aG kvm $USER
```





## Minilab Levantar NGINX en un pod en MINIKUBE
En este laboratorio se levantara un pod con un servicio de nginx y se expondra el puerto a la maquina local.

```bash
# Create a cluster
minikube start --driver=kvm2
# start the pod running nginx
kubectl create deployment --image=nginx nginx-app
# [OPTIONAL] add env to nginx-app
kubectl set env deployment/nginx-app  DOMAIN=cluster
# expose a port through with a service
kubectl expose deployment nginx-app --port=80 --name=nginx-http
# [TEST] access to service
curl 127.0.0.1:8010
```


## Minilab Levantar  imagen local de Docker en Kubernetes
En este laboratorio se creara una imagen docker de prueba  y se desplegara en un `pod`.

* Crear `Dockerfile`  que imprime en pantalla el mensaje `Hello World!`.

```docker
FROM busybox
CMD [ "echo", "Hello World!"]
```

* Crear la imagen Docker.

```bash
$ docker build . -t santos/hello-world
    # Sending build context to Docker daemon  3.072kB
    # Step 1/2 : FROM busybox
    #  ---> 62aedd01bd85
    # Step 2/2 : CMD [ "echo", "Hello World!"]
    #  ---> Using cache
    #  ---> 79b4e6c1bd0d
    # Successfully built 79b4e6c1bd0d
    # Successfully tagged santos/hello-world:latest

```

* Levantar un contenedor de prueba.

```bash
$ docker run santos/hello-world
    # Hello World!
```

* Crear el archivo de configuracion `helloworld.yml` para crear un job de kubernetes que corra el container  Docker.
```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: hello-world
spec:
  template:
    metadata:
      name: hello-world-pod
    spec:
      containers:
      - name: hello-world
        image: santos/hello-world
        imagePullPolicy: Never
      restartPolicy: Never
```
`restartPolicy` es `Never` debido que el container solo va a ejecutar el mensaje `Hello World!` y terminar, si se deja en `Always` se va a ejecutar infinitas veces.

`imagePullPolicy` es `Never` debido a que se quiere que busque la imagen localmente solamente, si no la encuentra no intentara bajarla del container registry.


* Crear el job de kubernetes con este archivo de configuracion y `kubectl`.
```sh
$ kubectl create -f helloworld.yml
    # job.batch/hello-world created
```

* Revisar si se ejecuto correctamente.
```sh
$ kubectl get pods
    # NAME              READY STATUS            RESTARTS AGE
    # hello-world-r4g9g 0/1   ErrImageNeverPull 0        6s
```

El error  `ErrImageNeverPull`  significa  que el nodo minikube usa su propio repositorio de Docker que no está conectado al registro de Docker en la máquina local, por lo que, sin extraer, no sabe de dónde obtener la imagen.

Para solucionar esto, utilizo el comando `minikube docker-env` que genera las variables de entorno necesarias para apuntar el demonio local de Docker al registro interno de Docker de minikube:

```sh
$ minikube docker-env
    # export DOCKER_TLS_VERIFY=”1"
    # export DOCKER_HOST=”tcp://172.17.0.2:2376"
    # export DOCKER_CERT_PATH=”/home/user/.minikube/certs”
    # export MINIKUBE_ACTIVE_DOCKERD=”minikube”# To point your shell to minikube’s docker-daemon, run:
    ## eval $(minikube -p minikube docker-env)

```

* Aplicar las variables de `minikube`
```sh
$ eval $(minikube -p minikube docker-env)
```

* Construyo la imagen de docker nuevamente, esta vez en el registro interno de `minukube`.
```sh
$ docker build . -t santos/hello-world
```

* Recrear el job otra vez.
```sh
$ kubectl delete -f helloworld.yml
$ kubectl create -f helloworld.yml
```

* Revisar si se ejecuto correctamente.
```sh
$ kubectl get pods
    # NAME              READY STATUS            RESTARTS AGE
    # hello-world-r4g9g 0/1   Completed         0        6s
```

* Revisar los logs del pod.
```sh
$ kubectl logs hello-world-f5hzz
    # Hello World!
```