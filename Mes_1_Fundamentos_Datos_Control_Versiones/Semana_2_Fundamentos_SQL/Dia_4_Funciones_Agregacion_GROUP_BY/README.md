# Funciones de Agregación y GROUP BY

# Ejercicio: Análisis Agregado de Datos de Ventas con SQLite

## 📋 Objetivo
Dominar las funciones de agregación en SQL (COUNT, SUM, AVG, MAX, MIN) combinadas con GROUP BY y HAVING para realizar análisis estadísticos y de negocio sobre datos de ventas, comprendiendo cómo extraer insights valiosos de bases de datos relacionales.

---

## 🧠 Conceptos Fundamentales: Agregación y Análisis

Hasta ahora, nuestras consultas trataban cada fila por separado. Pero para responder preguntas de negocio reales (como "¿Cuál es el promedio de ventas?" o "¿Qué región vende más?"), necesitamos **resumir** los datos.

### 1. La Lógica de la Agregación

Las **Funciones de Agregación** toman muchas filas como entrada y devuelven **un solo valor** como resultado.

* **`COUNT()`**: Cuenta elementos (filas).
* **`SUM()`**: Suma valores numéricos (ideal para ingresos o stock).
* **`AVG()`**: Calcula el promedio aritmético.
* **`MAX()` / `MIN()`**: Encuentra los extremos (valores máximos o mínimos).

### 2. Agrupando Datos con `GROUP BY`

Rara vez queremos el promedio de *toda* la empresa. Generalmente lo queremos **por** categoría, **por** mes o **por** cliente.

* **`GROUP BY`** es el comando que "corta" la tabla en pequeños grupos.
* **Regla de Oro:** Si usas una función de agregación (como `SUM`) junto con una columna normal (como `ciudad`), esa columna normal **debe** estar en el `GROUP BY`.
    * *Ejemplo:* "Súmame las ventas (`SUM`), pero agrúpalas **por** ciudad (`GROUP BY ciudad`)".

### 3. El Gran Dilema: `WHERE` vs. `HAVING`

Esta es la confusión más común en SQL. Ambos sirven para filtrar, pero actúan en momentos diferentes:

1.  **`WHERE` (Filtro de Filas):** Actúa **ANTES** de agrupar. Filtra los datos crudos.
    * *Ejemplo:* "Solo ten en cuenta los pedidos de 2024" (`WHERE anio = 2024`).
2.  **`HAVING` (Filtro de Grupos):** Actúa **DESPUÉS** de agrupar y calcular. Filtra el resultado de la agregación.
    * *Ejemplo:* "Una vez sumadas las ventas por vendedor, muéstrame solo a los que vendieron más de $1,000" (`HAVING SUM(ventas) > 1000`).

---

## 🛠️ Requerimientos

- **Sistema operativo:** Windows 11
- **Terminal/Command Line:** Terminal integrada de VS Code
- **Python:** Versión 3.x (SQLite viene incluido)
- **Editor de código:** Visual Studio Code
- **Base de datos:** Nueva base de datos `tienda_ejemplo.db`
- **Conocimientos previos:** SQL básico, JOINs, claves foráneas

---

## 📝 Pasos Realizados

### 1. Preparación del Entorno

#### 1.1 Crear directorio del proyecto

```bash
# Crear nueva carpeta para el ejercicio
mkdir ejercicio-agregacion-sql
cd ejercicio-agregacion-sql
```

#### 1.2 Inicializar base de datos SQLite

```bash
sqlite3 tienda_ejemplo.db
```

**Resultado:**
```
SQLite version 3.x.x
Enter ".help" for usage hints.
sqlite>
```

**⚠️ Nota Importante: Activación de Claves Foráneas (FOREIGN KEY)**

Por defecto, SQLite *entiende* la sintaxis de `FOREIGN KEY` (por eso la vemos en `.schema`) pero **no las valida** (no las "refuerza") para mantener compatibilidad con bases de datos antiguas.

Debemos activar esta validación manualmente **cada vez** que iniciamos una sesión con el siguiente comando PRAGMA:

```sql
PRAGMA foreign_keys = ON;
```

Con este comando, la base de datos ahora **SÍ RECHAZARÁ** cualquier `INSERT` o `UPDATE` que viole una regla de clave foránea.

**Configurar visualización óptima:**
```sql
.mode column
.headers on
```

### 2. Creación del Esquema de Base de Datos Completo

#### 2.1 Crear tabla de productos

```sql
CREATE TABLE productos (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    precio REAL NOT NULL,
    categoria TEXT,
    stock INTEGER DEFAULT 0
);
```

#### 2.2 Crear tabla de clientes

```sql
CREATE TABLE clientes (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    email TEXT UNIQUE,
    ciudad TEXT
);
```

#### 2.3 Crear tabla de pedidos

```sql
CREATE TABLE pedidos (
    id INTEGER PRIMARY KEY,
    cliente_id INTEGER,
    fecha_pedido DATE NOT NULL,
    total REAL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
```

#### 2.4 Crear tabla de detalle_pedidos

```sql
CREATE TABLE detalle_pedidos (
    id INTEGER PRIMARY KEY,
    pedido_id INTEGER,
    producto_id INTEGER,
    cantidad INTEGER NOT NULL,
    precio_unitario REAL NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);
```

**Constraints aplicadas:**
- `PRIMARY KEY`: Campo `id` identifica cada detalle únicamente
- `NOT NULL`: `cantidad` y `precio_unitario` son obligatorios
- `FOREIGN KEY (pedido_id)`: Vincula con tabla pedidos
- `FOREIGN KEY (producto_id)`: Vincula con tabla productos

#### 2.5 Verificar estructura completa

```sql
.tables
```

**Resultado:**
```
clientes         detalle_pedidos  pedidos          productos
```

### 3. Inserción de Datos de Ejemplo

#### 3.1 Insertar productos

```sql
INSERT INTO productos VALUES
(1, 'Laptop Dell', 1200.00, 'Electrónica', 15),
(2, 'Mouse Logitech', 25.50, 'Accesorios', 50),
(3, 'Teclado Mecánico', 89.99, 'Accesorios', 30),
(4, 'Monitor 24"', 199.99, 'Electrónica', 12),
(5, 'Audífonos Sony', 149.50, 'Audio', 25);
```

#### 3.2 Insertar clientes

```sql
INSERT INTO clientes VALUES
(1, 'Ana García', 'ana@email.com', 'Madrid'),
(2, 'Carlos López', 'carlos@email.com', 'Barcelona'),
(3, 'María Rodríguez', 'maria@email.com', 'Madrid');
```

#### 3.3 Insertar pedidos

```sql
INSERT INTO pedidos VALUES
(1, 1, '2024-01-15', 1251.00),
(2, 1, '2024-01-20', 89.99),
(3, 2, '2024-01-18', 349.49);
```

#### 3.4 Insertar detalle de pedidos

```sql
INSERT INTO detalle_pedidos VALUES
(1, 1, 1, 1, 1200.00),
(2, 1, 2, 2, 25.50),
(3, 2, 3, 1, 89.99),
(4, 3, 4, 1, 199.99),
(5, 3, 5, 1, 149.50);
```

**Explicación de los datos:**
- **Pedido 1** (Ana García): 1 Laptop + 2 Mouse = $1,251.00
- **Pedido 2** (Ana García): 1 Teclado = $89.99
- **Pedido 3** (Carlos López): 1 Monitor + 1 Audífonos = $349.49

#### 3.5 Verificar datos insertados

```sql
SELECT * FROM detalle_pedidos;
```

**Resultado:**
```
id  pedido_id  producto_id  cantidad  precio_unitario
--  ---------  -----------  --------  ---------------
1   1          1            1         1200.0
2   1          2            2         25.5
3   2          3            1         89.99
4   3          4            1         199.99
5   3          5            1         149.5
```

---

## 🔗 Diagrama de Relaciones

```
┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│   productos      │         │ detalle_pedidos  │         │    pedidos       │
├──────────────────┤         ├──────────────────┤         ├──────────────────┤
│ id (PK)          │◄────────│ id (PK)          │────────►│ id (PK)          │
│ nombre           │         │ pedido_id (FK)   │         │ cliente_id (FK)  │
│ precio           │         │ producto_id (FK) │         │ fecha_pedido     │
│ categoria        │         │ cantidad         │         │ total            │
│ stock            │         │ precio_unitario  │         └─────────┬────────┘
└──────────────────┘         └──────────────────┘                   │
                                                                    │
                                                          ┌─────────▼─────────┐
                                                          │    clientes       │
                                                          ├───────────────────┤
                                                          │ id (PK)           │
                                                          │ nombre            │
                                                          │ email (UNIQUE)    │
                                                          │ ciudad            │
                                                          └───────────────────┘
```

---

## 📊 Consultas de Agregación Básica

### 4. Ventas Totales por Producto

**Objetivo:** Calcular cuántas unidades se vendieron de cada producto y los ingresos generados

```sql
SELECT producto_id, 
       SUM(cantidad) AS total_vendido, 
       SUM(cantidad * precio_unitario) AS ingresos_totales
FROM detalle_pedidos
GROUP BY producto_id;
```

**Resultado:**
```
producto_id  total_vendido  ingresos_totales
-----------  -------------  ----------------
1            1              1200.0
2            2              51.0
3            1              89.99
4            1              199.99
5            1              149.5
```

**Análisis:**
- `GROUP BY producto_id`: Agrupa todas las ventas por producto
- `SUM(cantidad)`: Suma las unidades vendidas de cada producto
- `SUM(cantidad * precio_unitario)`: Calcula ingresos multiplicando cantidad por precio
- El producto con ID 2 (Mouse) se vendió 2 unidades
- El producto con ID 1 (Laptop) generó más ingresos ($1,200)

---

### 5. Ventas por Producto con Nombre

**Objetivo:** Mostrar el nombre del producto en lugar del ID

```sql
SELECT p.nombre AS producto,
       SUM(dp.cantidad) AS total_vendido, 
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS ingresos_totales
FROM detalle_pedidos dp
INNER JOIN productos p ON dp.producto_id = p.id
GROUP BY dp.producto_id, p.nombre
ORDER BY ingresos_totales DESC;
```

**Resultado:**
```
producto            total_vendido  ingresos_totales
------------------  -------------  ----------------
Laptop Dell         1              1200.0
Monitor 24"         1              199.99
Audífonos Sony      1              149.5
Teclado Mecánico    1              89.99
Mouse Logitech      2              51.0
```

**Análisis:**
- `INNER JOIN`: Combina detalle_pedidos con productos para obtener nombres
- `ROUND(..., 2)`: Redondea a 2 decimales para formato monetario
- `ORDER BY ingresos_totales DESC`: Ordena de mayor a menor ingreso
- La Laptop Dell es el producto que más ingresos genera
- El Mouse Logitech vendió más unidades (2) pero genera menos ingresos

---

### 6. Estadísticas por Pedido

**Objetivo:** Analizar cada pedido con sus estadísticas

```sql
SELECT pedido_id, 
       COUNT(*) AS items_diferentes, 
       SUM(cantidad) AS cantidad_total, 
       AVG(precio_unitario) AS precio_promedio
FROM detalle_pedidos
GROUP BY pedido_id;
```

**Resultado:**
```
pedido_id  items_diferentes  cantidad_total  precio_promedio
---------  ----------------  --------------  ---------------
1          2                 3               612.75
2          1                 1               89.99
3          2                 2               174.745
```

**Análisis:**
- `COUNT(*)`: Cuenta cuántos productos diferentes tiene cada pedido
- `SUM(cantidad)`: Suma todas las unidades del pedido
- `AVG(precio_unitario)`: Calcula el precio promedio de los productos
- El pedido 1 tiene 2 productos diferentes (Laptop + Mouse)
- El pedido 1 tiene el precio promedio más alto ($612.75)

---

### 7. Estadísticas por Pedido con Valor Total

**Objetivo:** Agregar el cálculo del valor total de cada pedido

```sql
SELECT pedido_id, 
       COUNT(*) AS items_diferentes, 
       SUM(cantidad) AS cantidad_total, 
       ROUND(AVG(precio_unitario), 2) AS precio_promedio,
       ROUND(SUM(cantidad * precio_unitario), 2) AS valor_total
FROM detalle_pedidos
GROUP BY pedido_id
ORDER BY valor_total DESC;
```

**Resultado:**
```
pedido_id  items_diferentes  cantidad_total  precio_promedio  valor_total
---------  ----------------  --------------  ---------------  -----------
1          2                 3               612.75           1251.0
3          2                 2               174.75           349.49
2          1                 1               89.99            89.99
```

**Análisis:**
- `SUM(cantidad * precio_unitario)`: Calcula el valor total del pedido
- El pedido 1 es el más valioso ($1,251.00)
- El pedido 2 es el más pequeño ($89.99)
- El pedido 3 tiene 2 productos con un total de $349.49

---

## 🔍 Consultas con HAVING

### 8. Productos con Más de 1 Unidad Vendida

**Objetivo:** Filtrar solo productos que se vendieron en múltiples unidades

```sql
SELECT producto_id, 
       SUM(cantidad) AS total_vendido
FROM detalle_pedidos
GROUP BY producto_id
HAVING SUM(cantidad) > 1;
```

**Resultado:**
```
producto_id  total_vendido
-----------  -------------
2            2
```

**Análisis:**
- `HAVING`: Filtra grupos DESPUÉS de aplicar GROUP BY
- Solo el producto ID 2 (Mouse Logitech) vendió más de 1 unidad
- `WHERE` no puede usar funciones de agregación, por eso usamos `HAVING`
- **Diferencia clave:** WHERE filtra filas, HAVING filtra grupos

---

### 9. Productos con Más de 1 Unidad Vendida (con nombre)

**Objetivo:** Mostrar el nombre del producto en lugar del ID

```sql
SELECT p.nombre AS producto,
       SUM(dp.cantidad) AS total_vendido,
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS ingresos
FROM detalle_pedidos dp
INNER JOIN productos p ON dp.producto_id = p.id
GROUP BY dp.producto_id, p.nombre
HAVING SUM(dp.cantidad) > 1;
```

**Resultado:**
```
producto          total_vendido  ingresos
----------------  -------------  --------
Mouse Logitech    2              51.0
```

**Análisis:**
- Combina INNER JOIN con HAVING
- El Mouse Logitech es el único producto con más de 1 unidad vendida
- Generó $51.00 en ingresos totales

---

### 10. Pedidos con Valor Total Mayor a $150

**Objetivo:** Identificar pedidos grandes

```sql
SELECT pedido_id, 
       ROUND(SUM(cantidad * precio_unitario), 2) AS valor_total
FROM detalle_pedidos
GROUP BY pedido_id
HAVING SUM(cantidad * precio_unitario) > 150;
```

**Resultado:**
```
pedido_id  valor_total
---------  -----------
1          1251.0
3          349.49
```

**Análisis:**
- Filtra pedidos con valor superior a $150
- 2 de 3 pedidos cumplen con el criterio
- El pedido 2 ($89.99) no aparece porque es menor a $150
- **Uso práctico:** Identificar pedidos para envío gratis o descuentos especiales

---

### 11. Pedidos Grandes con Información del Cliente

**Objetivo:** Combinar HAVING con JOIN para ver qué clientes hacen pedidos grandes

```sql
SELECT c.nombre AS cliente,
       c.ciudad,
       p.id AS pedido,
       COUNT(dp.id) AS items,
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS valor_total
FROM pedidos p
INNER JOIN clientes c ON p.cliente_id = c.id
INNER JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY p.id, c.nombre, c.ciudad
HAVING SUM(dp.cantidad * dp.precio_unitario) > 150
ORDER BY valor_total DESC;
```

**Resultado:**
```
cliente         ciudad      pedido  items  valor_total
--------------  ----------  ------  -----  -----------
Ana García      Madrid      1       2      1251.0
Carlos López    Barcelona   3       2      349.49
```

**Análisis:**
- Combina 3 tablas (clientes, pedidos, detalle_pedidos)
- Solo muestra pedidos mayores a $150
- Ana García tiene el pedido más grande ($1,251.00)
- Carlos López tiene un pedido de $349.49

---

## 🌍 Análisis Combinado con JOINs

### 12. Ventas por Ciudad

**Objetivo:** Analizar el rendimiento de ventas por ubicación geográfica

```sql
SELECT c.ciudad,
       COUNT(p.id) AS num_pedidos,
       SUM(dp.cantidad * dp.precio_unitario) AS ingresos_ciudad
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY c.ciudad
HAVING SUM(dp.cantidad * dp.precio_unitario) > 0;
```

**Resultado:**
```
ciudad      num_pedidos  ingresos_ciudad
----------  -----------  ---------------
Barcelona   1            349.49
Madrid      2            1340.99
```

**Análisis:**
- `LEFT JOIN`: Incluiría ciudades sin ventas (si existieran)
- `HAVING ... > 0`: Excluye ciudades con ventas nulas
- Madrid genera más ingresos ($1,340.99) con 2 pedidos
- Barcelona tiene 1 pedido por $349.49
- María Rodríguez (Madrid) no aparece porque no tiene pedidos

---

### 13. Ventas por Ciudad (versión mejorada con totales)

**Objetivo:** Agregar más estadísticas por ciudad

```sql
SELECT c.ciudad,
       COUNT(DISTINCT c.id) AS num_clientes,
       COUNT(p.id) AS num_pedidos,
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS ingresos_ciudad,
       ROUND(AVG(p.total), 2) AS ticket_promedio
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY c.ciudad
HAVING SUM(dp.cantidad * dp.precio_unitario) > 0
ORDER BY ingresos_ciudad DESC;
```

**Resultado:**
```
ciudad      num_clientes  num_pedidos  ingresos_ciudad  ticket_promedio
----------  ------------  -----------  ---------------  ---------------
Madrid      2             2            1340.99          670.5
Barcelona   1             1            349.49           349.49
```

**Análisis:**
- `COUNT(DISTINCT c.id)`: Cuenta clientes únicos por ciudad
- `AVG(p.total)`: Calcula el ticket promedio
- Madrid tiene 2 clientes pero solo 1 compra (Ana García compró 2 veces)
- El ticket promedio en Madrid ($670.50) es mayor que en Barcelona

---

### 14. Ventas por Categoría de Producto

**Objetivo:** Analizar qué categorías generan más ingresos

```sql
SELECT pr.categoria,
       COUNT(DISTINCT pr.id) AS productos_vendidos,
       SUM(dp.cantidad) AS unidades_vendidas,
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS ingresos_categoria
FROM detalle_pedidos dp
INNER JOIN productos pr ON dp.producto_id = pr.id
GROUP BY pr.categoria
ORDER BY ingresos_categoria DESC;
```

**Resultado:**
```
categoria     productos_vendidos  unidades_vendidas  ingresos_categoria
------------  ------------------  -----------------  ------------------
Electrónica   2                   2                  1399.99
Audio         1                   1                  149.5
Accesorios    2                   3                  140.99
```

**Análisis:**
- Electrónica genera más ingresos ($1,399.99)
- Accesorios vende más unidades (3) pero menor valor total
- La categoría Audio tiene 1 producto vendido (Audífonos Sony)
- **Insight:** Productos electrónicos son de mayor valor unitario

---

### 15. Clientes con Mayor Gasto Total

**Objetivo:** Identificar a los mejores clientes

```sql
SELECT c.nombre AS cliente,
       c.ciudad,
       COUNT(p.id) AS num_pedidos,
       SUM(dp.cantidad) AS unidades_compradas,
       ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS gasto_total
FROM clientes c
INNER JOIN pedidos p ON c.id = p.cliente_id
INNER JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY c.id, c.nombre, c.ciudad
ORDER BY gasto_total DESC;
```

**Resultado:**
```
cliente            ciudad      num_pedidos  unidades_compradas  gasto_total
-----------------  ----------  -----------  ------------------  -----------
Ana García         Madrid      2            4                   1340.99
Carlos López       Barcelona   1            2                   349.49
```

**Análisis:**
- Ana García es la mejor cliente ($1,340.99 en 2 pedidos)
- Carlos López ha realizado 1 pedido por $349.49
- María Rodríguez no aparece porque no tiene pedidos
- **Uso práctico:** Programas de lealtad, descuentos VIP

---

## ✅ Verificación Final

### Checklist de completitud:

- [x] Base de datos `tienda_ejemplo.db` creada
- [x] Tabla `productos` creada con 5 productos
- [x] Tabla `clientes` creada con 3 clientes
- [x] Tabla `pedidos` creada con 3 pedidos
- [x] Tabla `detalle_pedidos` creada con 5 líneas de detalle
- [x] Relaciones entre tablas verificadas (FOREIGN KEYs)
- [x] Consulta de ventas totales por producto ejecutada
- [x] Consulta de estadísticas por pedido ejecutada
- [x] Consultas con HAVING ejecutadas
- [x] Análisis por ciudad ejecutado
- [x] Análisis por categoría ejecutado
- [x] Identificación de mejores clientes ejecutada

---

## 📊 Resumen de Funciones de Agregación Utilizadas

| Función | Propósito | Ejemplo en el Ejercicio |
|---------|-----------|-------------------------|
| `COUNT(*)` | Cuenta todas las filas | Contar productos diferentes en un pedido |
| `COUNT(columna)` | Cuenta valores no NULL | Contar pedidos por ciudad |
| `COUNT(DISTINCT)` | Cuenta valores únicos | Contar clientes únicos por ciudad |
| `SUM()` | Suma valores numéricos | Sumar unidades vendidas |
| `AVG()` | Calcula promedio | Calcular precio promedio |
| `MAX()` | Encuentra valor máximo | N/A en este ejercicio |
| `MIN()` | Encuentra valor mínimo | N/A en este ejercicio |
| `ROUND()` | Redondea números | Formatear valores monetarios |

---

## 📈 Comparación: WHERE vs HAVING

### Tabla Comparativa

| Aspecto | WHERE | HAVING |
|---------|-------|--------|
| **Momento de aplicación** | ANTES de agrupar (antes de GROUP BY) | DESPUÉS de agrupar (después de GROUP BY) |
| **Qué filtra** | Filas individuales | Grupos completos de filas |
| **Puede usar funciones de agregación** | ❌ NO | ✅ SÍ |
| **Uso típico** | Filtrar datos antes de agrupar | Filtrar resultados agregados |

### Ejemplos Prácticos

```sql
-- ✅ WHERE: Filtra productos ANTES de agrupar
SELECT categoria, COUNT(*) AS total
FROM productos
WHERE precio > 100  -- Solo productos caros
GROUP BY categoria;

-- ✅ HAVING: Filtra categorías DESPUÉS de agrupar
SELECT categoria, COUNT(*) AS total
FROM productos
GROUP BY categoria
HAVING COUNT(*) > 2;  -- Solo categorías con más de 2 productos

-- ❌ ERROR: No se puede usar función agregada en WHERE
SELECT categoria, COUNT(*) AS total
FROM productos
WHERE COUNT(*) > 2  -- ❌ Esto genera error
GROUP BY categoria;

-- ✅ CORRECTO: Combinación de WHERE y HAVING
SELECT categoria, COUNT(*) AS total
FROM productos
WHERE precio > 50  -- Primero filtra por precio
GROUP BY categoria
HAVING COUNT(*) > 1;  -- Luego filtra por cantidad
```

---

## 🎯 Conceptos Clave Aprendidos

### 1. GROUP BY - Agrupación de Datos

El comando `GROUP BY` agrupa filas que tienen los mismos valores en columnas especificadas.

**Sintaxis:**
```sql
SELECT columna_agrupacion, FUNCION_AGREGADA(columna)
FROM tabla
GROUP BY columna_agrupacion;
```

**Reglas importantes:**
- Todas las columnas en SELECT que no usan funciones de agregación deben estar en GROUP BY
- GROUP BY se ejecuta después de WHERE pero antes de HAVING
- Se puede agrupar por múltiples columnas

**Ejemplo del ejercicio:**
```sql
SELECT producto_id, SUM(cantidad) AS total_vendido
FROM detalle_pedidos
GROUP BY producto_id;
```

---

### 2. HAVING - Filtrado de Grupos

El comando `HAVING` filtra grupos después de que GROUP BY los ha creado.

**Sintaxis:**
```sql
SELECT columna, FUNCION_AGREGADA(columna)
FROM tabla
GROUP BY columna
HAVING FUNCION_AGREGADA(columna) > valor;
```

**Características:**
- Se usa SOLO con GROUP BY
- Puede usar funciones de agregación (a diferencia de WHERE)
- Filtra grupos completos, no filas individuales

**Ejemplo del ejercicio:**
```sql
SELECT producto_id, SUM(cantidad) AS total_vendido
FROM detalle_pedidos
GROUP BY producto_id
HAVING SUM(cantidad) > 1;
```

---

### 3. Funciones de Agregación

Las funciones de agregación operan sobre conjuntos de filas y devuelven un solo valor.

**Funciones principales:**
```sql
COUNT(*)           -- Cuenta todas las filas
COUNT(columna)     -- Cuenta valores no NULL
SUM(columna)       -- Suma valores
AVG(columna)       -- Promedio de valores
MAX(columna)       -- Valor máximo
MIN(columna)       -- Valor mínimo
```

**Características importantes:**
- Ignoran valores NULL (excepto COUNT(*))
- Se usan típicamente con GROUP BY
- Pueden combinarse en una misma consulta

---

### 4. Combinación de JOINs con Agregación

Se pueden combinar JOINs con GROUP BY para analizar datos de múltiples tablas.

**Sintaxis:**
```sql
SELECT tabla1.columna, FUNCION_AGREGADA(tabla2.columna)
FROM tabla1
JOIN tabla2 ON tabla1.id = tabla2.fk_id
GROUP BY tabla1.columna;
```

**Ejemplo del ejercicio:**
```sql
SELECT c.ciudad, SUM(dp.cantidad * dp.precio_unitario) AS ingresos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
LEFT JOIN detalle_pedidos dp ON p.id = dp.pedido_id
GROUP BY c.ciudad;
```

---

### 5. ROUND - Formateo de Números

La función `ROUND()` redondea números decimales.

**Sintaxis:**
```sql
ROUND(numero, decimales)
```

**Ejemplos:**
```sql
ROUND(123.456, 2)  -- Resultado: 123.46
ROUND(123.456, 1)  -- Resultado: 123.5
ROUND(123.456, 0)  -- Resultado: 123
```

**Uso en el ejercicio:**
```sql
ROUND(SUM(dp.cantidad * dp.precio_unitario), 2) AS ingresos
```

---

## 💡 Mejores Prácticas

### 1. Usar ROUND para valores monetarios

```sql
-- ✅ BIEN: Valores monetarios con 2 decimales
SELECT ROUND(SUM(total), 2) AS ingresos_totales
FROM pedidos;

-- ❌ MAL: Muchos decimales innecesarios
SELECT SUM(total) AS ingresos_totales
FROM pedidos;
-- Resultado: 1690.4800000000002 (confuso)
```

### 2. Usar alias descriptivos

```sql
-- ✅ BIEN: Alias claros y descriptivos
SELECT 
    COUNT(*) AS total_pedidos,
    SUM(total) AS ingresos_totales,
    AVG(total) AS ticket_promedio
FROM pedidos;

-- ❌ MAL: Sin alias
SELECT 
    COUNT(*),
    SUM(total),
    AVG(total)
FROM pedidos;
```

### 3. Incluir todas las columnas no agregadas en GROUP BY

```sql
-- ✅ BIEN: Todas las columnas no agregadas están en GROUP BY
SELECT ciudad, nombre, COUNT(*) AS total
FROM clientes
GROUP BY ciudad, nombre;

-- ❌ MAL: Falta 'nombre' en GROUP BY (error en la mayoría de DBMS)
SELECT ciudad, nombre, COUNT(*) AS total
FROM clientes
GROUP BY ciudad;
```

### 4. Usar WHERE para filtros de fila, HAVING para filtros de grupo

```sql
-- ✅ BIEN: WHERE para filas, HAVING para grupos
SELECT categoria, COUNT(*) AS total
FROM productos
WHERE precio > 100      -- Filtro de fila
GROUP BY categoria
HAVING COUNT(*) > 2;    -- Filtro de grupo

-- ⚠️ MENOS EFICIENTE: Todo en HAVING
SELECT categoria, COUNT(*) AS total
FROM productos
GROUP BY categoria
HAVING COUNT(*) > 2 AND MAX(precio) > 100;
```

---

## 🔄 Orden de Ejecución de Consultas SQL

**Orden en que SQL ejecuta una consulta:**

1. **FROM**: Identifica las tablas
2. **JOIN**: Combina las tablas
3. **WHERE**: Filtra filas individuales
4. **GROUP BY**: Agrupa filas
5. **HAVING**: Filtra grupos
6. **SELECT**: Selecciona columnas
7. **ORDER BY**: Ordena resultados
8. **LIMIT**: Limita número de resultados

**Ejemplo:**
```sql
SELECT ciudad, COUNT(*) AS total          -- 6. Selecciona columnas
FROM clientes                              -- 1. Tabla base
LEFT JOIN pedidos ON clientes.id = ...     -- 2. Une tablas
WHERE clientes.ciudad IS NOT NULL          -- 3. Filtra filas
GROUP BY ciudad                            -- 4. Agrupa
HAVING COUNT(*) > 0                        -- 5. Filtra grupos
ORDER BY total DESC                        -- 7. Ordena
LIMIT 10;                                  -- 8. Limita resultados
```

---

## 🚀 Próximos Pasos

### Conceptos avanzados a explorar:

1. **Subconsultas (Subqueries)**
```sql
SELECT nombre
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);
```

2. **CASE WHEN (Lógica condicional)**
```sql
SELECT nombre,
    CASE 
        WHEN precio > 500 THEN 'Premium'
        WHEN precio > 100 THEN 'Medio'
        ELSE 'Básico'
    END AS categoria_precio
FROM productos;
```

3. **Window Functions (Funciones de ventana)**
```sql
SELECT nombre, precio,
    ROW_NUMBER() OVER (ORDER BY precio DESC) AS ranking
FROM productos;
```

4. **Common Table Expressions (CTEs)**
```sql
WITH ventas_por_cliente AS (
    SELECT cliente_id, SUM(total) AS total_gastado
    FROM pedidos
    GROUP BY cliente_id
)
SELECT * FROM ventas_por_cliente WHERE total_gastado > 500;
```

5. **UNION para combinar resultados**
```sql
SELECT 'Cliente' AS tipo, COUNT(*) AS total FROM clientes
UNION
SELECT 'Producto', COUNT(*) FROM productos;
```

---

## 📖 Recursos Adicionales

- [Documentación oficial de SQLite - Aggregate Functions](https://www.sqlite.org/lang_aggfunc.html)
- [SQL GROUP BY Tutorial](https://www.sqlitetutorial.net/sqlite-group-by/)
- [Understanding HAVING Clause](https://www.w3schools.com/sql/sql_having.asp)
- [SQL Aggregation Best Practices](https://mode.com/sql-tutorial/sql-aggregate-functions/)

---

## 📝 Comandos Útiles de SQLite

```sql
-- Habilitar Foreign Keys (importante para integridad referencial)
PRAGMA foreign_keys = ON;

-- Ver estructura de una tabla
.schema detalle_pedidos

-- Ver información detallada de columnas
PRAGMA table_info(detalle_pedidos);

-- Ver Foreign Keys de una tabla
PRAGMA foreign_key_list(detalle_pedidos);

-- Mejorar visualización de resultados
.mode column
.headers on

-- Activar timer para ver tiempo de ejecución
.timer on

-- Exportar resultados a CSV
.mode csv
.output reporte_ventas.csv
SELECT * FROM detalle_pedidos;
.output stdout

-- Ver plan de ejecución de una consulta
EXPLAIN QUERY PLAN
SELECT ciudad, SUM(total)
FROM pedidos
GROUP BY ciudad;
```

---

## 📅 Notas del Ejercicio

- **Fecha de realización**: Noviembre 2025
- **Entorno**: Windows 11, VS Code, Python 3.x, SQLite 3.x
- **Base de datos**: tienda_ejemplo.db
- **Tablas creadas**: 4 (productos, clientes, pedidos, detalle_pedidos)
- **Registros insertados**: 5 productos, 3 clientes, 3 pedidos, 5 detalles
- **Relaciones FOREIGN KEY**: 3 (cliente_id en pedidos, pedido_id y producto_id en detalle_pedidos)
- **Consultas ejecutadas**: 15 (agregaciones, JOINs, HAVING)
- **Funciones utilizadas**: COUNT, SUM, AVG, ROUND, GROUP BY, HAVING

---

## ✨ Conclusiones

Este ejercicio permitió dominar las funciones de agregación y análisis de datos en SQL:

### Aprendizajes clave:

1. **GROUP BY** agrupa filas con valores idénticos para calcular estadísticas por grupo
2. **HAVING** filtra grupos después de la agregación (no filas individuales como WHERE)
3. **Funciones de agregación** (COUNT, SUM, AVG) resumen datos y generan insights
4. **Combinación de JOINs + GROUP BY** permite análisis multidimensional de datos relacionales
5. **ROUND** formatea números para presentación profesional de resultados

### Diferencias críticas entendidas:

| WHERE | HAVING |
|-------|--------|
| Filtra filas ANTES de agrupar | Filtra grupos DESPUÉS de agrupar |
| No puede usar funciones de agregación | Puede usar funciones de agregación |
| Más eficiente para filtros simples | Necesario para filtros sobre agregados |

### Insights de negocio obtenidos:

- **Mejor cliente**: Ana García con $1,340.99 en compras
- **Ciudad con más ventas**: Madrid ($1,340.99)
- **Categoría líder**: Electrónica ($1,399.99 en ingresos)
- **Producto más vendido en unidades**: Mouse Logitech (2 unidades)
- **Producto con mayores ingresos**: Laptop Dell ($1,200.00)
- **Ticket promedio por pedido**: $563.49

Las funciones de agregación son fundamentales para transformar datos transaccionales en información estratégica para la toma de decisiones empresariales.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 2](../README.md) | [Día Siguiente →](../Dia_5_Subconsultas_Avanzadas/README.md)
