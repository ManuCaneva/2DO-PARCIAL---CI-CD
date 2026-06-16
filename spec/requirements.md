# Requisitos de Calidad del Proyecto

## Contractuales
1. El `index.html` debe cumplir estrictamente el contrato SDD: el texto renderizado
   en el body debe ser exactamente `"MINOLI"` (sin espacios extra, etiquetas visibles
   o texto adicional).

2. Todos los tests automatizados del pipeline deben pasar exitosamente.

## Estructurales
3. El HTML debe ser válido y completo: toda etiqueta abierta debe cerrarse, el
   `<!DOCTYPE html>` debe mantenerse, y no debe perderse contenido existente.

4. El CSS embebido (`<style>`) debe mantenerse funcional: no introducir reglas rotas,
   selectores inválidos ni estilos que rompan el diseño actual.

5. El JavaScript embebido (`<script>`) debe mantenerse funcional: no introducir
   errores de sintaxis, ni romper la animación de partículas o el renderizado del DOM.

## Mantenibilidad
6. El código debe ser limpio y legible, siguiendo la indentación y estructura del
   proyecto. No dejar código comentado, debugging (`console.log`, `alert`) o
   fragmentos muertos.
