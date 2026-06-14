# 2da Instancia de Evaluación: Integración y Entrega Continua

[cite_start]El objetivo de esta consigna es aplicar los conceptos y herramientas de la integración continua en un proyecto de software[cite: 4]. [cite_start]La integración continua es una práctica que consiste en integrar los cambios en un repositorio común de forma frecuente y automatizada[cite: 2]. [cite_start]Esto permite detectar y corregir errores rápidamente, mejorar la calidad del código y acelerar el proceso de entrega[cite: 3].

## Requisitos para Aprobar

Para aprobar la evaluación, se deben cumplir los siguientes puntos:

* [cite_start]**Entorno de Integración Continua (IC):** Se debe crear un entorno configurando los componentes básicos vistos en teoría, lo cual incluye[cite: 7]:
    * [cite_start]1 repositorio de código[cite: 7].
    * [cite_start]1 servidor de IC[cite: 7].
    * [cite_start]1 entorno para los desarrolladores que incluya una build local[cite: 7].
    * [cite_start]1 prueba automatizada[cite: 7].
* [cite_start]**Despliegue:** Se debe configurar una build que realice el despliegue en el entorno de entrega previamente configurado[cite: 8].
* [cite_start]**Material de Presentación:** Es necesario crear 1 slide que contenga la imagen del esquema de la arquitectura y los logos de las herramientas utilizadas[cite: 10].
* [cite_start]**Demostración y Teoría:** Se debe demostrar el entorno funcionando y responder a las preguntas teóricas correspondientes[cite: 11]. [cite_start]La evaluación será oral e incluirá la demostración del funcionamiento del entorno[cite: 12].

## Elementos del Esquema de Arquitectura a Considerar

El flujo del entorno debe contemplar la interacción entre los siguientes componentes:

* [cite_start]**Control de Versiones:** Manejo de ramas y merges[cite: 13, 15].
* [cite_start]**Servidor de IC:** Encargado de la build automatizada, el deployment pipeline, la ejecución de pruebas automáticas y la generación de feedback[cite: 16, 17, 18, 19].
* [cite_start]**Entornos de Entrega:** Espacios destinados para pruebas y producción[cite: 20, 22].
* [cite_start]**Mecanismo de Feedback:** Resultados de la integración, inspección de código, resultados de instalación y pruebas automáticas devueltos al equipo[cite: 25, 26, 27, 28].

## Criterios de Valoración Adicional

Durante la evaluación, se valorarán los siguientes aspectos:

* [cite_start]La solvencia técnica de la solución implementada[cite: 30].
* [cite_start]La presentación de la solución utilizando un ejemplo de código muy simple[cite: 31].
* El agregado de otras herramientas complementarias, tales como:
    * [cite_start]Herramientas de inspección de código (por ejemplo, SonarQube)[cite: 33].
    * [cite_start]Gestores de entornos de ejecución (por ejemplo, Docker o Terraform)[cite: 33].
    * [cite_start]Gestores de paquetes (por ejemplo, Maven, Nuget o Composer)[cite: 33].
* [cite_start]La incorporación de capacidades de Spec Driven Development, lo cual puede sumar hasta 1 punto extra[cite: 34]. [cite_start]La asignación de este punto dependerá de la coherencia y la utilidad de los componentes que se hayan agregado[cite: 35].
* [cite_start]La duración de la presentación, la cual no debe superar los 5 minutos[cite: 36].
