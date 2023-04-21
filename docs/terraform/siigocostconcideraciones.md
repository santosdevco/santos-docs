
# Concideraciones:


1.  El objetivo de `siigo costs`  es procesar la informacion de costos de infraestructura de siigo(por el momento solo azure), este procesamiento conta de consultar la informacion de los diferentes providers(azure, rocket), y determinar cual es el recurso especifico que se esta cobrando en cada registro que viene en esta respuesta,  informacion procesada queda en la base de datos de la siguiente manera:
<!-- ```        -->

|PROVIDER | MONTH | YEAR | DAY  | COST | RESOURCE_ID|
|---------|------|-------|-----|------|------------|
|azure | 1 | 2022 | 2 | 12.123123 | `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/resourcegroups/othesomereourcegroup/providers/microsoft.compute/virtualmachinescalesets/akswinser`      |
|azure | 1 | 2022 | 2 | 3323.1231 | `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/resourcegroups/somereourcegroup/providers/microsoft.compute/virtualmachinescalesets/otherresource`      |
 
2. Un recurso en azure se puede identificar si y solo si se tiene la siguiente informacion:
           
    1. Suscripcion
    2. Grupo de recursos
    3. Tipo del recurso
        nombre

3. Hasta el momento me he encontrado con dos tipos de ids en azure:
    1. Id principal:     
       `"/subscription/$sub_id/resource_groups/$resource_groupname/providers/$ttype/$name"`
    2. Id sin grupo de recursos:<br/>
       `"/subscriptions/$sub_id/providers/$type/$location/$subtype/name/…."`

    El `tipo b`. no dice cual es el grupo de recursos


4. La respuesta de costos de  azure viene en el siguiente formato:
```json
[
    [
        "$cost",
        "$resource_group",
        "$location",
        "$id",
        "$service_name",
        "$sub_service_name",
        "$sub_sub_service_name",
        "$tags",
        "$currency"

    ],
    [....],
    [....]

]
```
Ejemplo
```json
   [
        0.0045940330857411026,
        "mc_rgpdcolwinapps02_pdcolclusterwinapps02_northcentralus",
        "Microsoft.Compute/virtualMachineScaleSets",
        "us north central",
        "/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/resourcegroups/mc_rgpdcolwinapps02_pdcolclusterwinapps02_northcentralus/providers/microsoft.compute/virtualmachinescalesets/akswinser",
        "Virtual Network",
        "Global Virtual Network Peering",
        "Inter-Region Egress",
        [
            "\"date\":\"15-02-2022\"",
            "\"aks-managed-poolname\":\"winser\"",
            "\"aks-managed-resourcenamesuffix\":\"46237\"",
            "\"env\":\"prod-col-zona-02\"",
            "\"owner\":\"david rosero calle\"",
            "\"tribu\":\"sre\"",
            "\"aks-managed-orchestrator\":\"kubernetes:1.20.15\""
        ],
        "USD"
    ]
```

5. La respuesta de `rocket` tiene el siguiente formato:
```json
[
    {
        "resource": "$resource_name",
        "resource_id": "$resource_na,e",
        "resource_category": "$service_nae=me",
        "parent_id": "$resource_group",
        "total": "$total",
        "last_total": "$total_in_lastmonth",
        "forecast": "$forectas in next month",
        "forecast_percentage": 0,
        "invoice_type": "1",
        "estimate": 0,
        "usage_issue_date": "0001-01-01T00:00:00Z"
    },
    [...],
    [...]

]
```


Ejemplo:

```json
{
    "resource": "saacademicoecucontifico",
    "resource_id": "saacademicoecucontifico",
    "resource_category": "Bandwidth",
    "parent_id": "rgacademicostorageaccounts",
    "total": 0.0010533347533790694,
    "last_total": 0.0010981801299513078,
    "forecast": 0.0010533347533790694,
    "forecast_percentage": 0,
    "invoice_type": "1",
    "estimate": 0,
    "usage_issue_date": "0001-01-01T00:00:00Z"
}
```

Procesar esta informacion presenta un reto, con la informacion del item no se puede identificar el recurso que esta facturando, hace falta el `resource_type`(ver el `inciso  2` de esta pagina). Se han hecho muchas pocs para tratar de asociar el `service name` que viene en la respuesta  a un `resource_type` pero hasta el momento la unica efectiva es por cada item, buscar el mismo en la respuesta de azure, ya que alla si estan los dos `resource_type`, `resource_service_name`. Sin embargo queda un porcentaje de items sin poderse porcesar(no se puede determinar el recurso que se esta cobrando).


## Problemas actuales en el procesamiento
La aplicacion ya tiene una nueva version con un proceso de pasos automatizados, y se han identificado algunos inconvenientes:

### Problema 1: Respuestas de costos sin grupo de recursos
El `id` de cada item de una respuesta, la mayoria de veces viene con un id  normal(procesable), pero en algunos casos viene sin grupo de recursos, tal y como se explica en el  inciso 3 de la de `Concideraciones`(ids tipo b). Y como se explica en el `inciso 2` de concideraciones,  hace falta el resource group para identificar el recurso.

### Problema 2: Respuesta de costos de rocket con resource_group erroneo
Algunos items de una respuesta de rocket normal, vienen con un `parent_id` equivocado,  la hipotesis es que rocket no tiene en cuenta el `Problema 1` que se acaba de explicar al momento que el internamente procesa los datos de azure.
Veamos una vez mas los dos tipos de ids identificados:

1. Id principal:     
       `"/subscription/$sub_id/resource_groups/$resource_groupname/providers/$ttype/$name"`
2. Id sin grupo de recursos:<br/>
       `"/subscriptions/$sub_id/providers/$type/$location/$subtype/name/…."`

Rocket asume que el grupo siempre vendra en la posicion 3 del id, esto seria correcto si no existiera el id `tipo b`, pero  al procesar los ids `tipo b` de la misma  forma manda el  `$type` a `parent_id` lo cual es un error.

Algunos ejemplos de este inconveniente:

```json
[{
            "resource": "azsql-colombia-05",
            "resource_id": "azsql-colombia-05",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 24.22078686894035,
            "last_total": 0,
            "forecast": 24.22078686894035,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
        {
            "resource": "azsql-colombia-07",
            "resource_id": "azsql-colombia-07",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 20.547235678012683,
            "last_total": 0,
            "forecast": 20.547235678012683,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
        {
            "resource": "azsql-colombia-01",
            "resource_id": "azsql-colombia-01",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 18.033207130194658,
            "last_total": 0,
            "forecast": 18.033207130194658,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
         {
            "resource": "azsql-colombia-06",
            "resource_id": "azsql-colombia-06",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 17.801407030948628,
            "last_total": 0,
            "forecast": 17.801407030948628,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
        {
            "resource": "azsql-colombia-02",
            "resource_id": "azsql-colombia-02",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 17.008705109911766,
            "last_total": 0,
            "forecast": 17.008705109911766,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
        {
            "resource": "azsql-colombia-03",
            "resource_id": "azsql-colombia-03",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 12.695468064088187,
            "last_total": 0,
            "forecast": 12.695468064088187,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
        {
            "resource": "azsql-colombia-04",
            "resource_id": "azsql-colombia-04",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 8.625845396746817,
            "last_total": 0,
            "forecast": 8.625845396746817,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
         {
            "resource": "azsql-interno",
            "resource_id": "azsql-interno",
            "resource_category": "SQL Database",
            "parent_id": "microsoft.sql",
            "total": 0.031849870842988,
            "last_total": 0,
            "forecast": 0.031849870842988,
            "forecast_percentage": 0,
            "invoice_type": "1",
            "estimate": 0,
            "usage_issue_date": "0001-01-01T00:00:00Z"
        },
          {
                    "resource": "Basic",
                    "resource_id": "Basic",
                    "resource_category": "Azure DevOps",
                    "parent_id": "microsoft.visualstudio",
                    "total": 2084.524456448333,
                    "last_total": 0,
                    "forecast": 2084.524456448333,
                    "forecast_percentage": 0,
                    "invoice_type": "1",
                    "estimate": 0,
                    "usage_issue_date": "0001-01-01T00:00:00Z"
                }
]
```

Que hizo mal rocket?, proceso mal estos `ids`:

- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-01`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-02`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-03`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-04`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-05`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-06`
- `/subscriptions/7fefb755-c8be-4623-8ecd-b0d39089f788/providers/microsoft.sql/locations/northcentralus/longtermretentionservers/azsql-colombia-07`
    

           


### Problema 3: Recursos que se cobran un mes en rocket no son facturados mismo mes por azure:
Este problema es mas dificil de identificar, pero se visibilizo cuando  se automatizo el codigo, debido a que el paso de extraccion de recursos no existentes de los mismos costos, se hace mes a mes en la nueva version(antes se extraian todos los recursos de todos los meses, y luego se procedia al procesamiento de costos), por ende quedan estos  costos sin poderse asignar.

Listo algunos de los  que presentan este problema:
    Name: azsql-colombia-06
    Period: 1-2022
    Subscription: Prod
   
    Name: azsql-colombia-07
    Period: 1-2022
    Subscription: Prod
    
    Name: akswinser
    Period: 1-2022
    Subscription: Prod

    Name: vmpdmexbpmfrontmanager01
    Period: 4-2022
    Subscription: RE1D_azure

    ....



Este problema solo aparecio en dos subs en el periodo 1-2022, y el periodo 4-2022.



