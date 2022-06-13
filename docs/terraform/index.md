# Terraform
Siigo tiene la meta de tener toda su infraestructura desplegada con terraform, hasta el momento va un aproximado del 40% y esta se maneja en dos repositorios en azure devops.
 
## Repositorios
 
 
### Infrastructure Modules
* Este repositorio tiene las plantillas para desplegar los diferentes servicios con los estándares ya incorporados.
* Se manejan TAGS para el versionamiento de cada módulo siguiendo el siguiente estándar `{modulename}v{version-No}`, algunos ejemplos son: `aks-istio-sp-v0.0.1`, `aks-nodepools-v0.0.9`
* Por lo general cada módulo tiene un `README.MD` donde explica los cambios más importantes en cada versión.
* La estructura de carpetas está divida de la siguiente forma: `Proveedor/Servicio`.
* La rama principal es `dev`, se utiliza el esquema de `Git Flow`, más adelante se explica el proceso.
* Ver el repositorio en el siguiente  [link](https://dev.azure.com/SiigoDevOps/Architecture/_git/infrastructure-modules){target=_blank}
### Repositorio IAC
* En este repositorio está escrita la infraestructura de `SIIGO`, implementando las diferentes plantillas del repo `Infrastructure Modules`.
* La estructura de carpetas del repositorio está dividida así  `Pais/Ambiente/Servicio`.
* La rama principal de este repositorio es `infrastructure-code`.
* Ver el repositorio en el siguiente  [link](https://dev.azure.com/SiigoDevOps/Architecture/_git/iac){target=_blank}
 
## Gestión de cambios
La gestión de cambios en los repositorios se hace usando la metodología  [`Git Flow`](https://www.youtube.com/watch?v=abtqhoMqCWY){target=_blank}, estos cambio se dividen en 2 tipos
### Actualización de los módulos de  Infraestructura Modules
Por lo general los cambios en este repositorio tienen que ver con utilizar nuevas versiones de diferentes tecnologías, solucionar bugs, registrar namespaces, actualizar o agregar módulos, etc. Todo cambio sustancial en este repositorio es Taggeado con el objetivo de poder referenciar desde el repo de `IaC`.
 
 Mas sobre `GitFlow` sobre este repo  en [`link`](/terraform/gitflow/gitflow-infraestructure-modules/)
 
### Cambios en IaC
Los cambios en este repositorio tienen que ver con cambios en la infraestructura, esta infraestructura es creada implementando los módulos del repo de `infrastructure-modules`.
 
 Mas sobre `GitFlow` sobre este repo  en [`link`](/terraform/gitflow/gitflow-iac/)
 
 

