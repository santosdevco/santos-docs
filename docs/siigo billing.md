# Siigo Costs

La aplicacion tiene el objetivo de procesar  y guardar los costos de infraestructura de `Siigo SAS`, de los diferentes clouds `azure`, `aws`, `oracle`,  por medio de diferentes providers como `rocket`, `azure costs management`, `aws cost`, para poder  generar metricas, indicadores, reportes, donde se puedan ejecutar analisis y de forma oportuna poder  responder preguntas como:

- Donde y porque se incrementaron los costos este mes.
- Determinar que parte del incremento de costos es de nueva infra y de infra existente.
- Es el dia 7, 15, etc. del mes y quiero saber cuales son los recursos que incrementaron sus costos lo que lleva del mes.
- Cual sera el costo de x recursos el mes que viene(Predicciones mas sofisticadas).
- Cual es el costo exacto de la nueva infraestructura desplegada este mes.
-  Llevar un historico de los costos tambien es algo muy valioso, ya que con esto podremos ver como cambian los costos  de un recurso, grupo de recursos  a lo 
largo del tiempo.
- Cual es el descuento exacto que aplico rocket para cada tipo de recurso el mes que paso.

## Diagrama de arquitectura

<!-- ![diagrama arquitectura](./img/siigocosts/design_siigo_costs.png) -->
<!--  -->
![diagrama arquitectura](./img/siigocosts/C4-Level1 .png)

La aplicacion se compone de 3 componentes principales:

- **Siigo Resources Management**: Tiene como objetivo bajar los recursos que estan desplegados en los diferentes clouds(en este momento solo azure), ya que en los informes de costos se quiere obtener la informacion de cada recurso(tipo, locacion, sku, etc.) como tambien los  tags(owner, tribu, product, solution). 


- **Siigo Cost Procesor**: Tiene como objetivo bajar los costos de infraestructura de  los recursos que estan desplegados en los diferentes clouds, por medio de diferentes providers, como `Rocket`, `Azure Cost Management`, `AWS Costs`, para luego procesarlos, agruparlos y relacionarlos a los recursos que estan guardados en la base de datos. El objetivo es bajar los costos en intervalos establecidos teniendo en cuenta las restricciones de cada provider, por ejemplo: cada mes, cada semana, cada 15 dias.




- **Siigo Cost API**: Es un API enfocada 100% a consultas sobre la info en la db, tiene como objetivo generar diferentes informes de costos, por subscripcion, grupo de recursos, recursos, providers, etc, como tambien de recursos, en `excel` o `json`.

-  **POWER BI**: Esta tecnologia externa nos ayudara a analizar la informacion de una forma mas sencilla, con graficos, consultas complejas etc, power bi tiene las opciones de obtener datos de un API o una db, en este caso MongoDB. 

### Siigo Resources Management
![diagrama arquitectura](./img/siigocosts/C2Resources Management.png)

Por el momento este componente solo baja **NUEVOS RECURSOS**, mas adelante podria ser capaz de  determinar si un recurso ha sido **ELIMINADO** o **ACTUALIZADO**, y reflejarlo en la db.

- **Id Factory**: Este componente tiene el objetivo de generar id aleatorios para cada nuevo recurso o grupo de recursos o sub, en un principio se pensaba generar un tag `_id`, en azure para que este se identificara a traves de este tag, pero nunca se ejecuto. 

- **Subscription Fetcher**: Este componente tiene el objetivo de consultar las subscripciones de azure a traves del api, procesarlas y retornarlas en formato json.

- **Resource Groups  Fetcher**: Este componente tiene el objetivo de consultar los recursos de azure a traves del api, procesarlos y retornarlas en formato json.

- **Resources Fetcher**: Este componente tiene el objetivo de consultar los recursos  de azure a traves del api, procesarlos y retornarlas en formato json.


- **Resources From Costs  Fetcher**: Este componente existe debido a que no es posible obtener todos los recursos que existieron en un mes  con los tres componentes anteriores, ya que el api de azure solo retorna los que existen en el momento que se hace la peticion. Este componente extrae todos los recursos y grupos  de recursos no existentes en la db que vienen en la respuesta de `Azure Cost Management` los procesa y retorna en en formato json.
Cabe aclarar que  usando logica difusa se determina cual es el `Service Name` para cada recurso, ya que en la respuesta de costos para un mismo recurso vienen diferentes `Services Names`(Un problema de ambiguedad), esto se pudo validar con los excels que genera azure  y se encontro que funciona correctamente.
- **Azure Fetcher  Main**: Este componente tiene el objetivo de llamar a los diferentes fetchers y posteriormente guardar la informacion en la base de datos.

### Siigo Costs Processor
![diagrama arquitectura](./img/siigocosts/C2CostsProcessor.png)

Este es un disenio simplificado de este modulo, este componente consulta en este momento informacion de costos directamente de `Azure` y de `Rocket`, los procesa y guarda en la base de datos.

- **Rocket Cost API**: Este componente se comunica con el API de Rocket y consulta los costos por recurso de un periodo determinado, aqui un periodo es un mes especifico: `2022-02`,`2022-03`, y los retorna en formato `JSON`.

- **Azure Cost API**: 
Este componente se comunica con el API de `Azure Cost Management` y consulta los costos por recurso en un intervalo de tiempo, aqui la ventaja que hay es que se pueden consultar costos en cualquier intervalo de tiempo, por ejemplo:   desde `2022-07-1` hasta `2022-07-15`, por el momento solo se generan costos mensuales  pero mas adelante se generaran  costos cada semana(Solo de Azure). Finalmente los retorna en formato `JSON`.

- **Azure Cost Processor**:   
Este componente  llama a `Azure Cost API` y procesa los costos, este procesamiento es principalmente agrupar los costos ya que la respuesta de azure devuelve demasiados registros, se deben agrupar usando el `resource_id` y expresiones regulares. Por otro lado se obtiene el _id del recurso en la db y finalmente se guardan los costos en la db.

- **Rocket Cost Processor**:   
Este componente  llama a `Rocket Cost API` y procesa los costos, este procesamiento es principalmente obtener el recurso espeficico de cada registro, esta tarea no es facil ya que rocket nos da los siguientes datos para identificar cada recurso: `Resource Name`, `Resource Group`, `Subscription`, `Service Name`, este ultimo es por ejemplo: `Storage`. `Virtual Machine`, `App Service Plan`, y hay un problema de ambiguedad(Un mismo recurso puede aparecer con "Bandwidth", o "Virtual Machine", etc y no hay forma de determinar cual es el service name real para buscar el recurso en la db), por esta razon se consulta la informacion de costos del mismo mes de azure directamente y dentro de esta informacion se busca el recurso especifico para poder conseguir el  `ResourceId`,agrupar los costos por resource id, buscar el recurso asociado en la db y guardar los costos procesados.


### Siigo Costs API
![diagrama arquitectura](./img/siigocosts/C2API.png)

Por el momento solo hay un endpoint, este genera un reporte, en formato  `excel`, hay que especificar la siguiente informacion:

- periods: Son los periodos que se quieren ver en el reporte, ej:  `2022-1`,`2022-2`,`2022-3`.
- subscriptions: Son las suscripciones a las cuales se quiere generar costos ej : `b3fd9f1c-0ed5-4f6e-9a93-75ae90718vfa`, se generara una hoja de excel para cada sub.
- providers: Se puede elegir si bajar los costos que se obtuvieron de `azure` o `rocket`, aun no se ha creado una funcionalidad para bajar de ambos al tiempo.

Al final el reporte generara dos hojas de calculo por sub, uno con los costos por recurso,   otro por grupo de recursos.

#### Ejemplo de una peticion con curl.
```bash
curl -X 'POST' \
  'http://localhost:8000/excel_report' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "periods": [
    "1-2022","2-2022","3-2022","4-2022","5-2022"
  ],
  "subscriptions": [
    "b3fd9f1c-0ed5-4f6e-9a93-75ae90718vfa"
  ],
  "providers": [
    "rocket"
  ],
  "minimal_cost": -1
}'

```
