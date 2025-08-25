# Eureka - Registro de Microservicios

## Objetivo

Este documento describe el proceso de verificación manual del registro de los microservicios en el servidor Eureka. Forma parte del aseguramiento de calidad del sistema distribuido basado en microservicios del proyecto de inventario.

## Servicios esperados registrados en Eureka

- `ms-cloud-gateway`
- `ms-search`
- `ms-operator`
- `ms-eureka`

## Archivos relevantes para la configuración de Eureka

| Archivo                                 | Descripción                                                                                          |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------- |
| `application.yml` de cada microservicio | Define `spring.application.name`, `eureka.client.service-url.defaultZone`, `prefer-ip-address`, etc. |
| `.env` de cada microservicio            | Variables como `SERVER_NAME`, `EUREKA_URL`, `SERVER_PORT`                                            |
| `docker-compose.dev.yml`                | Orquesta los servicios y asegura que estén en la misma red para comunicación interna                 |

## Variables de entorno clave

| Variable           | Función                                                                 |
| ------------------ | ----------------------------------------------------------------------- |
| `EUREKA_URL`       | Define la URL del servidor Eureka (e.g. `http://localhost:8761/eureka`) |
| `SERVER_NAME`      | Nombre lógico del microservicio usado por Eureka                        |
| `EUREKA_PREFER_IP` | Determina si el registro en Eureka usa IP o nombre de host              |

## Procedimiento de verificación manual

### 1. Levantar el stack completo

```bash
docker compose -f docker-compose.dev.yml up --build
```

### 2. Verificación visual en Eureka

- Abrir navegador: `http://localhost:8761`
- Confirmar que los servicios aparecen en estado **UP**

### 3. Simulación de caída

- Ejecutar: `docker stop ms-operator`
- Refrescar la UI de Eureka
- Confirmar que el servicio `ms-operator` desaparece o marca como `DOWN`
- Reiniciar: `docker start ms-operator`

### 4. Validar peticiones a través del Gateway

Usar Postman:

```http
GET http://localhost:8762/ms-search/v1/items
```

- Confirmar que responde correctamente (código 200, JSON esperado)

### 5. Probar ruta inexistente

```http
GET http://localhost:8762/ms-invalido/v1/test
```

- Confirmar que devuelve error 404 o 503

## Documentación recomendada

Agregar en el README del proyecto:

```markdown
### Verificación Manual del Registro en Eureka

1. Acceder a `http://localhost:8761`
2. Validar que los servicios `ms-eureka`, `ms-search`, `ms-operator`, `ms-cloud-gateway` aparecen en estado `UP`
3. Detener `ms-operator` y confirmar que desaparece o marca `DOWN`
4. Probar peticiones a través del gateway en Postman
5. Validar respuesta para servicios válidos e inválidos
```

## Resultado esperado

- Todos los servicios aparecen como registrados y activos (UP)
- Eureka responde a cambios en tiempo real (caídas y recuperaciones)
- Gateway enruta correctamente las peticiones
- Servicios no registrados no pueden ser alcanzados

## Buenas prácticas

- Usar `defaultZone` con fallback: `${EUREKA_URL:http://localhost:8761/eureka}`
- Asegurar nombres únicos (`spring.application.name`) en cada microservicio
- Documentar en el README general del proyecto cómo verificar Eureka y los servicios esperados
- Validar manualmente tras cada cambio estructural o de red

---

Este documento puede ser referenciado como evidencia de pruebas manuales para los criterios de aceptación de tareas relacionadas con la integración de Eureka.
