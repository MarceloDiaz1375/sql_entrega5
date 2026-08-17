# 📊 Análisis Avanzado de Ventas con SQL y Window Functions

Este repositorio contiene un script SQL profesional diseñado para la base de datos `tienda`. El objetivo de este script es resolver un caso de análisis de negocio complejo utilizando técnicas avanzadas de PostgreSQL, como Expresiones de Tablas Comunes (**CTEs**), **Funciones de Ventana** (*Window Functions*) y lógica condicional.

---

## 🚀 Escenario de Negocio y Objetivo
Como analista de datos de la tienda, se requiere generar un reporte financiero y operativo mensual que permita evaluar el desempeño de las diferentes categorías de productos. El reporte debe responder a las siguientes preguntas clave:
1. ¿Cuál es el volumen total de ventas de cada categoría por mes?
2. ¿Cómo se posiciona (ranking) cada categoría frente a las demás en un mismo periodo?
3. ¿Cuál es la evolución histórica acumulada (*running total*) de las ventas por categoría?
4. ¿Qué meses superaron el rendimiento promedio histórico de su categoría ("Exitoso") frente a aquellos que estuvieron por debajo?

---

## 🛠️ Tecnologías y Características Utilizadas
* **Motor de Base de Datos:** PostgreSQL
* **Conceptos Aplicados:**
  * `WITH` (CTEs anidadas / modulares).
  * `DATE_TRUNC()` para normalización de fechas a nivel mensual.
  * Funciones de Ventana (`OVER`, `PARTITION BY`, `ORDER BY`):
    * `RANK()` para la jerarquía de ventas por mes.
    * `SUM()` para el cálculo acumulado cronológico.
    * `AVG()` para la línea base de comparación histórica.
  * Condicionales lógicos (`CASE WHEN`).
  * Funciones de agregación y modelado relacional (`JOIN`, `GROUP BY`).

---

## 📂 Estructura del Script (`preentrega_analisis_avanzado.sql`)

El script se divide en tres bloques lógicos principales:

### 1. Primera CTE (`ventas_mensuales`)
Filtra los pedidos completados, uniendo las tablas `pedidos`, `detalle_pedidos`, `productos` y `categorias`. Agrupa y normaliza las fechas al inicio de cada mes para unificar la granularidad.
```sql
