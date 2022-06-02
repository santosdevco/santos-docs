# Datadog
Un pequeno texto de lo que se hace con datadog en siigo Un pequeno texto de lo que se hace con kubernetes en siigo Un pequeno texto de lo que se hace con kubernetes en siigo Un pequeno texto de lo que se hace con kubernetes en siigo Un pequeno texto de lo que se hace con kubernetes en siigo 


## COnfiguraciond e Dashboard
Migracion de clusters de QA Mex a SPOT,  proceso detallado de como actualizar los clusters a la nueva version de el modulo de `infraestructure-modules` de Clusters con `spot`

[Url Reunion](https://www.mkdocs.org)

### Breakpoints
* Min 0 Ambientacion
* Min 15 Modificacion de terra
* Min 50 Spotins
* Min 120 Network en Azure

### Anotaciones 
Anotaciones importantes de la grabacion



## Alertas
Migracion de clusters de QA Mex a SPOT,  proceso detallado de como actualizar los clusters a la nueva version de el modulo de `infraestructure-modules` de Clusters con `spot`

[Url Reunion](https://www.mkdocs.org)

### Breakpoints
* Min 0 Ambientacion
* Min 15 Modificacion de terra
* Min 50 Spotins
* Min 120 Network en Azure

### Anotaciones 
Anotaciones importantes de la grabacion


##  Manejo de Kubectl
Migracion de clusters de QA Mex a SPOT,  proceso detallado de como actualizar los clusters a la nueva version de el modulo de `infraestructure-modules` de Clusters con `spot`

[Url Reunion](https://www.mkdocs.org)

### Breakpoints
* Min 0 Ambientacion
* Min 15 Modificacion de terra
* Min 50 Spotins
* Min 120 Network en Azure

### Anotaciones 
Anotaciones importantes de la grabacion

```bash
# Ejemplo de creacion de pods
kubectl get pods --namespace curso-namespace
kubectl apply -f mongopod.yaml 
kubectl get pods  --namespace curso-namespace
kubectl describe pod mongo --namespace  curso-namespace
kubectl  run custom-nginx --image=bitnami/nginx --restart=Never --namespace  curso-namespace
kubectl get pods  --namespace curso-namespace
kubectl get pod custom-nginx --namespace  curso-namespace   -o json
kubectl get pod custom-nginx --namespace  curso-namespace   -o yaml
kubectl exec  -ti custom-nginx --namespace  curso-namespace --  bash
kubectl logs  custom-nginx --namespace  curso-namespace
kubectl port-forward  custom-nginx 8080  --namespace  curso-namespace &
curl localhost:8080

```

```json
{
    "key":"value"
}
```