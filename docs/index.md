# Visión General de la Documentación

Bienvenido a la documentación de **SantosDev**. Aquí encontrarás una colección organizada de laboratorios, tutoriales y proyectos prácticos, estructurados para que puedas aprovechar rápidamente los ejemplos basados en **Python** y **Kubernetes**. Cada sección comienza con un breve párrafo introductorio que explica el propósito y el alcance de los contenidos allí publicados.

---

## 🐍 Proyectos y laboratorios en Python

En esta sección se agrupan todos los ejemplos y proyectos enfocados en el ecosistema **Python**. Encontrarás laboratorios paso a paso para integrar **Celery** con **FastAPI**, así como soluciones prácticas de scraping y proyectos de Recuperación de Imágenes Basada en Contenido (CBIR).

- **Introducción a Celery + FastAPI Labs**  
  Estos cinco laboratorios muestran cómo construir aplicaciones escalables y asincrónicas en Python combinando **FastAPI** y **Celery**. Aprenderás desde la configuración básica hasta el uso de WebSockets para notificaciones en tiempo real.  
  - [CeleryFastAPILabs (página principal)](celeryfastapi/CeleryFastAPILabs/)  
  - [Lab 1 – FastAPI + Celery + Redis (básico)](celeryfastapi/lab1/)  
  - [Lab 2 – Arquitectura escalable + Alembic](celeryfastapi/lab2/)  
  - [Lab 3 – Roles avanzados y módulo de chatroom](celeryfastapi/lab3/)  
  - [Lab 4 – Chat en tiempo real con WebSocket](celeryfastapi/lab4/)  
  - [Lab 5 – Notificaciones WebSocket de tareas Celery](celeryfastapi/lab5/)

- **Google Maps Scraper**  
  Este proyecto en **Python** automatiza la recolección de datos de Google Maps, almacena la información en MongoDB y genera reportes en Excel. Ideal para aprender técnicas de scraping con `requests` y `BeautifulSoup`, así como el manejo de bases de datos NoSQL.  
  - [GoogleMapsScrapper](GoogleMapsScrapper/)

- **CBIR Project (Detección de enfermedades en plantas)**  
  Aplicación distribuida basada en microservicios Docker para realizar **Content-Based Image Retrieval**. Incluye extracción de descriptores, construcción de índices y búsqueda de imágenes similares. Una solución práctica para reconocimiento de enfermedades en plantas mediante visión por computador.  
  - [CBIR_Project](cbir_project/)

---

## ☸️ Laboratorios de Kubernetes

En esta sección encontrarás ejemplos detallados para implementar y gestionar clústeres de **Kubernetes**, tanto en entornos locales con **Minikube** como en producción con **Azure Kubernetes Service (AKS)**. Cada laboratorio está diseñado para ilustrar conceptos clave paso a paso.

- **Introducción a los laboratorios de Minikube**  
  Aprende a configurar un entorno local de Kubernetes usando Minikube y a desplegar aplicaciones Dockerizadas. Este bloque de laboratorios cubre desde la instalación de Minikube hasta la puesta en producción de aplicaciones y servicios internos.  
  - [Minikube (página principal)](labs_kubernetes/minikube/)  
  - [Lab 1 – LoadBalancer + API Flask](labs_kubernetes/minikube/labs1/)  
  - [Lab 2 – Volúmenes compartidos (`emptyDir`)](labs_kubernetes/minikube/labs2/)  
  - [Lab 3 – Comunicación interna entre containers](labs_kubernetes/minikube/labs3/)  
  - [Lab 4 – Service NodePort entre Pods](labs_kubernetes/minikube/labs4/)  
  - [Lab 5 – Docker Coins en Kubernetes](labs_kubernetes/minikube/labs5/)

- **Introducción a AKS (Azure Kubernetes Service)**  
  En este laboratorio aprenderás a crear un Container Registry en Azure, generar un clúster de AKS y desplegar la aplicación Docker Coins con las mismas configuraciones usadas en Minikube. Una guía paso a paso para llevar tus servicios a la nube de Microsoft.  
  - [AKS Lab 1](labs_kubernetes/azure/labs1/)
