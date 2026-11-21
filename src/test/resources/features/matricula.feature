
# language: es

@P1
Característica: Matrícula del alumno
  Como alumno de CIBERTEC
  Quiero matricularme en mis cursos
  Para llevarlos en el ciclo

  Antecedentes:
    Dado que el alumno "i202610006" inicia sesión con clave "Cibertec2026"

  Escenario: Cotizar el curso de mi fila
    Cuando cotiza el curso "DM5512" para el alumno "i202610006"
    Entonces la respuesta HTTP debe ser 200
    Y la cotización muestra 4 créditos, subtotal 480, descuento 0 y total 480

  Escenario: Matricularse y pagar el curso de mi fila
    Cuando el alumno "i202610006" registra su matrícula en el curso "DM5512"
    Entonces la respuesta HTTP debe ser 201
    Y la matrícula creada tiene estado "REGISTRADA" y monto 480
    Y el cuerpo de la respuesta cumple el esquema "schemas/matricula.json"

    Cuando paga la matrícula registrada usando el método "TRANSFERENCIA"
    Entonces la respuesta HTTP debe ser 200
    Y la matrícula pagada tiene estado "PAGADA" y fecha de pago registrada

    Cuando consulta el listado de sus pagos
    Entonces la respuesta HTTP debe ser 200
    Y existe el pago de la matrícula con método "TRANSFERENCIA" y formato de operación "^OP-[0-9]{6}$"

  Escenario: Regla de negocio que debe fallar por prerrequisito pendiente
    Cuando el alumno "i202610006" registra su matrícula en el curso "QA5517"
    Entonces la respuesta HTTP debe ser 422
    Y el error devuelto tiene código "PRERREQUISITO_PENDIENTE"
    Y el cuerpo de la respuesta cumple el esquema "schemas/error.json"
