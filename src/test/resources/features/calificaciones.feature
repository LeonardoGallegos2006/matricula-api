
@P3
Feature: Calificación de matrículas
  Como docente de CIBERTEC
  Quiero registrar las notas finales de los cursos pagados
  Para que el historial académico actualice los créditos aprobados y el promedio ponderado

  Scenario Outline: El docente registra la nota y el historial se actualiza
    Given que la alumna "Rosa" inicia sesión con usuario "i202610005" y clave "Cibertec2026"
    And la alumna obtiene el id de su matrícula del curso "PI5620"
    When el docente "D0001" con clave "Cibertec2026" registra la nota <nota> en esa matrícula
    Then la calificación responde con código HTTP 200
    And la matrícula calificada tiene condición "<condicion>"
    When la alumna consulta su historial académico "i202610005"
    Then el historial responde con código HTTP 200
    And el historial muestra condición "<condicion>" para el curso "PI5620", <creditosAprobados> créditos aprobados y promedio ponderado <promedio>
    And el historial cumple el esquema "schemas/historial.json"

    Examples:
      | nota | condicion   | creditosAprobados | promedio |
      | 19.0 | APROBADO    | 13                | 17.08    |
      | 12.5 | DESAPROBADO | 7                 | 14.08    |

  Scenario: Un docente que no dicta el curso intenta registrar la nota
    Given que la alumna "Rosa" inicia sesión con usuario "i202610005" y clave "Cibertec2026"
    And la alumna obtiene el id de su matrícula del curso "PI5620"
    When el docente "D0002" con clave "Cibertec2026" registra la nota 15.0 en esa matrícula
    Then la calificación responde con código HTTP 403
    And el error de calificación tiene código "ACCESO_DENEGADO"
    And la respuesta de calificación cumple el esquema "schemas/error.json"

  Scenario: No se puede calificar una matrícula que no está pagada
    Given que la alumna "Rosa" inicia sesión con usuario "i202610005" y clave "Cibertec2026"
    And la alumna obtiene el id de su matrícula del curso "PS5511"
    When el docente "D0001" con clave "Cibertec2026" registra la nota 16.0 en esa matrícula
    Then la calificación responde con código HTTP 409
    And el error de calificación tiene código "MATRICULA_NO_PAGADA"
    And la respuesta de calificación cumple el esquema "schemas/error.json"
