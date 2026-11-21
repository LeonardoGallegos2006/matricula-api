@P2
Feature: Seguridad de la sesión
  Como responsable de calidad de CIBERTEC
  Quiero validar la rotación de tokens, el cierre de sesión, el bloqueo de cuenta y los permisos
  Para garantizar la seguridad de la API de matrícula

  Scenario: Rotación del refresh token
    Given que el actor "Pedro" accede a la API de seguridad
    And el actor inicia sesión con usuario "i202610006" y clave "Cibertec2026"
    When el actor renueva su sesión usando su refresh token actual
    Then el actor recibe el código HTTP 200
    And los tokens renovados son distintos a los anteriores
    When el actor intenta renovar su sesión reutilizando el refresh token original
    Then el actor recibe el código HTTP 401
    And el código de error obtenido es "REFRESH_REUTILIZADO"
    And la respuesta de seguridad cumple el esquema "schemas/error.json"
    When el actor consulta su perfil con el access token actual
    Then el actor recibe el código HTTP 401
    And el código de error obtenido es "TOKEN_INVALIDO"
    And la respuesta de seguridad cumple el esquema "schemas/error.json"

  Scenario: Cierre de sesión
    Given que el actor "Pedro" accede a la API de seguridad
    And el actor inicia sesión con usuario "i202610006" y clave "Cibertec2026"
    When el actor cierra su sesión actual
    Then el actor recibe el código HTTP 204
    When el actor consulta su perfil con el access token actual
    Then el actor recibe el código HTTP 401
    And el código de error obtenido es "TOKEN_INVALIDO"
    And la respuesta de seguridad cumple el esquema "schemas/error.json"

  Scenario: Bloqueo de cuenta por intentos fallidos
    Given que el actor "Jorge" accede a la API de seguridad
    When intenta iniciar sesión fallidamente con usuario "i202610004" validando cada intento:
      | intento | clave      | status | codigo                 |
      | 1       | ClaveMala1 | 401    | CREDENCIALES_INVALIDAS |
      | 2       | ClaveMala2 | 401    | CREDENCIALES_INVALIDAS |
      | 3       | ClaveMala3 | 401    | CREDENCIALES_INVALIDAS |
      | 4       | ClaveMala4 | 401    | CREDENCIALES_INVALIDAS |
      | 5       | ClaveMala5 | 423    | CUENTA_BLOQUEADA       |
    When el actor inicia sesión con usuario "i202610004" y clave "Cibertec2026"
    Then el actor recibe el código HTTP 423
    And el código de error obtenido es "CUENTA_BLOQUEADA"
    And la respuesta de seguridad cumple el esquema "schemas/error.json"

  Scenario: Alumno sin permiso de administrador
    Given que el actor "Pedro" accede a la API de seguridad
    And el actor inicia sesión con usuario "i202610006" y clave "Cibertec2026"
    When el actor intenta listar todos los alumnos
    Then el actor recibe el código HTTP 403
    And el código de error obtenido es "ACCESO_DENEGADO"
    And la respuesta de seguridad cumple el esquema "schemas/error.json"
