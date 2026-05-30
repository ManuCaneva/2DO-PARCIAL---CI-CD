# Evaluación: Integración y Entrega Continua

[![Build Status](https://goya.semaphoreci.com/badges/SEMAPHORE-CI-2DOPARCIAL/branches/master.svg?style=shields&key=92220178-5208-4273-96dd-1e9b73715ea8)](https://goya.semaphoreci.com/projects/SEMAPHORE-CI-2DOPARCIAL)

**Autor:** Cáneva, Franco Manuel
**Institución:** Universidad Tecnológica Nacional (UTN) - Ingeniería en Sistemas de Información
**Materia:** Ingeniería y Calidad de Software 

---

## 🚀 Descripción del Proyecto

Este repositorio contiene la implementación práctica requerida para la segunda instancia de evaluación de Integración y Entrega Continua. El objetivo principal de este trabajo es aplicar los conceptos y herramientas teóricas de la integración continua (IC) en un flujo real de desarrollo de software.

La arquitectura diseñada refleja la práctica de integrar cambios en un repositorio común de forma frecuente y automatizada. Esta automatización permite la detección y corrección rápida de errores, eleva la calidad del código fuente y acelera todo el proceso de entrega de valor.

## 🏗️ Arquitectura y Componentes del Entorno

El entorno de Integración Continua fue estructurado configurando los componentes fundamentales requeridos para el ciclo de vida del software:

* **Control de Versiones:** Gestión centralizada del código mediante Git y GitHub, utilizando una estrategia de *Feature Branches* y protección de la rama `main` mediante *Pull Requests*.
* **Servidor de IC:** El pipeline de construcción y la ejecución de pruebas automáticas se encuentran orquestados a través de **Semaphore CI**.
* **Pruebas Automatizadas y SDD:** Se incorporó una validación estricta de contratos implementando capacidades de *Spec Driven Development* (SDD).
* **Gestión de Entornos:** Se implementó la containerización utilizando **Docker** como gestor del entorno de ejecución aislado (basado en Nginx).
* **Entorno de Entrega:** Se configuró un despliegue continuo automatizado utilizando **Render**, conectando la validación del servidor de IC directamente con la puesta en producción.

## 🔄 Flujo de Trabajo (Pipeline CI/CD)

El proceso automatizado garantiza que cada nuevo bloque de código introducido sea auditado de manera estricta antes de llegar a los usuarios. El flujo consta de las siguientes etapas:

1. **Auditoría de Contrato:** El servidor de IC ejecuta los scripts de validación (SDD). Si la prueba falla, el proceso se aborta inmediatamente, bloqueando la integración y disparando alertas a través de Trello y Telegram.
2. **Construcción (Build):** Únicamente tras la aprobación exitosa de los test automatizados, el pipeline procede a compilar el contenedor Docker, asegurando que la imagen resultante esté libre de errores.
3. **Despliegue Continuo:** Una vez que la imagen es validada y el código es fusionado con la rama principal, el entorno de Render la despliega automáticamente, manteniendo el ciclo de entrega estable y sin intervención manual.

---

## 🌐 Proyecto en Vivo

La última versión estable y validada por la Integración Continua se encuentra desplegada automáticamente. 

Podés ver el proyecto funcionando acá: **[👉 Ver despliegue en Render] https://goya-2do-parcial.onrender.com/**