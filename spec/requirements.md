# Lineamientos de Calidad del Proyecto

1. Todos los tests automatizados deben pasar exitosamente en el pipeline.
2. El código debe cumplir estrictamente con el contrato SDD definido.
3. El proyecto debe compilar correctamente en Docker sin errores.
4. El Quality Gate de SonarCloud debe pasar (sin bugs, code smells o duplications críticos).
5. El deployment en Render debe ser automático y exitoso tras cada merge a main.
6. El mecanismo de feedback debe notificar fallos al equipo vía Trello y Telegram.
