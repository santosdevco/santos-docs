# Versions: Clone of Git made in C

* Año: 2018
* Repo: [https://gitlab.com/santiagoandre/versions](https://gitlab.com/santiagoandre/versions)

Es un proyecto basico de un sistema de control de versiones, que incluye:
  - Adicionar un archivo al repositorio de versiones.
  - Listar las versiones de un archivo.
  - Recuperar una version anterior de un archivo.
En esta implementación no es recursiva por lo cual sólo se pueden agregar archivos que se encuentren en el directorio desde el cual se invoque el comando.

## Como funciona:
Al invocar el comando versions por primera vez, se  crea un directorio llamado .versions.
Se crea un sub-directorio por cada archivo agregado al repositorio. Dentro de este sub-directorio se almacenan las diferentes versiones del archivo, y un archivo llamado versions.txt que contiene la descripción de cada versión.

### Diagrama de flujo

![FlowrDiagram](img/versionsflow.png)

## Requerimientos:
En las distribuciones basadas en debian se necesita el siguiente paquete  libssl-dev
```bash
 sudo apt install libssl-dev
```
## Compilar
Anadir la bandera -lcrypto 
```bash
 gcc -o versions versions.c hash/openssl_hash.c -lcrypto
```
## Uso:

Agregar una version de un archivo:

```bash
versions add archivo "Comentario sobre la version"
```
Listar las verciones de un archivo:
```bash
versions list archivo
```
recuperar una version de un archivo

```bash
versions get num_ver archivo
```
