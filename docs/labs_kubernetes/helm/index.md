# Helm 
- (Helm Oficial Page)[https://helm.sh/]
- [Curso Youtube](https://www.youtube.com/playlist?list=PLSwo-wAGP1b8svO5fbAr7ko2Buz6GuH1g){target=_blank}
- [Artifact Hub](https://artifacthub.io/){target=_blank}


## Instalacion
```
$ apt install helm
```
## Ejemplo de uso

Instalando `nginx`

```
$ helm install nginx

```


## Helm Repos
Funcionan de manera analoga a los repositorios de paquetes de las distros de gnu linux, de donde bajar los paquetes que quieres instalar

### Agregar un repo

```sh

$ helm repo add <custom_name> <url>
$ helm repo update
```
```sh title="Ejemplo" 
$ helm repo add bitnami https://charts.bitnami.com/bitnami                  
$ helm repo update
```
### Listar repos agregados
```sh
helm repo list
    NAME                    URL                                               
    strimzi                 https://strimzi.io/charts/                        
    bitnami                 https://charts.bitnami.com/bitnami 
```