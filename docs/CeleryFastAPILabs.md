# FastAPI & Celery  Labs

Bienvenido a mi colección de laboratorios prácticos diseñados para llevarlo de cero a intermedio en el uso de FastAPI con Celery. Este repositorio contiene cinco laboratorios progresivos, cada uno de los cuales se basa en los conocimientos y habilidades desarrollados en el anterior.

## Nota importante

Este proyecto tiene su proyecto completo en <a href="https://github.com/SantiagoAndre/celery-fast-api-labs/" target="_blank">Github</a>, y cada laboratorio tiene su documentacion, pero aun no he liberado la documentacion paso a paso estara colocada en subsecciones de este apartado.

## Descripción general

Estos laboratorios ofrecen un enfoque práctico para aprender la integración de FastAPI, un framework rápido para crear API's con Python, con Celery, un potente sistema de cola de tareas distribuidas. Cada laboratorio está estructurado para mejorar su comprensión de manera incremental, desde conceptos básicos hasta implementaciones más avanzadas. Cada laboratorio tiene su propio README y diagramas para entender fácilmente cada uno, todos los laboratorios estan montados sobre Docker y Docker-Compose para ejecutar cada uno en su máquina sin ningún problema.

### Resúmenes de laboratorio

- **Laboratorio 1: Aplicación básica de apio FastAPI**
   Introducción a FastAPI, configuración de una API sencilla.

- **Laboratorio 2: Integración de Project Factory y SqlAlChemy**
   Refactorización a una estructura más escalable e integración SQLAlCHemy

- **Laboratorio 3: Módulo de Gestión de Usuarios y Salas de Chat**
   Implementación de roles de usuario, decoradores de rutas para protegerlos y una función de sala de chat.

- **Laboratorio 4: Aplicación de chat en tiempo real**
   Mejora de la aplicación de la sala de chat con capacidades de mensajería en tiempo real.

- **Laboratorio 5: WebSocket con Apio**
   Incorporación de WebSocket para actualizaciones en vivo sobre los estados de las tareas de Celery.

## Instalación

Debe tener Docker y Docker-Compose configurados en su máquina. Para ejecutar cada laboratorio, debe seguir los siguientes pasos:

1. `cd labfolfer`
2. `docker-componer`

Nota: si el laboratorio tiene modelos de base de datos, después del último comando hay que ejecutar

```bash
docker-compose exec web bash
alembic revision --autogenerate
alembic upgrade head
```


Estos comandos migran los modelos a la base de datos.
