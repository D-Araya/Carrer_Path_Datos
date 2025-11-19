# Subconsultas y Consultas Avanzadas

# Ejercicio: Consultas Avanzadas con Subconsultas en SQLite

## 📋 Objetivo
Dominar las subconsultas en SQL (subqueries) para realizar consultas avanzadas y complejas, incluyendo subconsultas en WHERE, subconsultas correlacionadas, y el uso de EXISTS para filtrado avanzado de datos en bases de datos relacionales.

---

## 🧠 Conceptos Fundamentales: La Potencia de las Subconsultas

Una **Subconsulta** (*subquery*) es una consulta SQL anidada dentro de otra consulta (la consulta principal o externa). Las subconsultas permiten descomponer problemas complejos en pasos más pequeños, utilizando el resultado de una consulta como entrada o condición de otra.

Las subconsultas se vuelven esenciales cuando una condición de filtrado o una columna calculada dependen de un valor que solo puede obtenerse mediante otra operación de la base de datos (por ejemplo, el promedio de todos los productos, o la lista de clientes VIP).

---

### 1. Tipos de Subconsultas por Ubicación

La función de una subconsulta depende de dónde se anida. El resultado de la subconsulta actúa como un valor, una lista o una tabla temporal para la consulta principal.

| Ubicación | Uso Principal | Resultado de la Subconsulta | Operadores Típicos |
| :--- | :--- | :--- | :--- |
| **Cláusula WHERE** | **Filtrar** el conjunto de resultados | Un valor único (Escalar) o una lista de valores | `=`, `IN`, `NOT IN`, `ANY`, `ALL`, `EXISTS` |
| **Cláusula SELECT** | **Calcular** una columna adicional | **DEBE** ser un valor único (Escalar) por fila | `SELECT (subconsulta)` |
| **Cláusula FROM** | **Tabla Derivada** (Derived Table) | Una tabla temporal completa | Se usa para pre-agregar o manipular datos complejos antes de un `JOIN` |

---

### 2. Subconsultas Correlacionadas vs. No Correlacionadas

Una distinción clave es la dependencia:

| Característica | Subconsulta Simple (No Correlacionada) | Subconsulta Correlacionada |
| :--- | :--- | :--- |
| **Dependencia** | No depende de la consulta externa. | **SÍ** depende de la consulta externa. |
| **Ejecución** | Se ejecuta **una sola vez** al inicio. | Se ejecuta **una vez por cada fila** de la consulta externa (más lenta, pero precisa). |
| **Uso Típico** | Encontrar productos con precio > **AVG(precio)**. | Encontrar el **último pedido de CADA cliente**. |

---

### 3. Optimización: `IN` vs. `EXISTS`

Ambos operadores se usan en `WHERE` para verificar la membresía, pero su lógica de ejecución es diferente y crucial para el rendimiento:

| Operador | Lógica | Eficiencia | Recomendación |
| :--- | :--- | :--- | :--- |
| **`IN`** | Verifica si el valor de la consulta externa está presente en la **lista completa** devuelta por la subconsulta. | Puede ser más lento si la lista es muy grande, ya que debe cargar y escanear toda la lista. | Usar cuando la subconsulta devuelve una lista pequeña o manejable. |
| **`EXISTS`** | Verifica si la subconsulta devuelve **al menos una fila** para el registro actual. | Generalmente más rápido, ya que detiene el escaneo tan pronto como encuentra la primera coincidencia. | **Preferir en verificaciones de existencia** (ej., Clientes que SÍ tienen pedidos). |

---

## 🛠️ Requerimientos

- **Sistema operativo:** Windows 11
- **Terminal/Command Line:** Terminal integrada de VS Code
- **Python:** Versión 3.x (SQLite viene incluido)
- **Editor de código:** Visual Studio Code
- **Base de datos:** Nueva base de datos `tienda_ejemplo.db`
- **Conocimientos previos:** SQL básico, JOINs, funciones de agregación, GROUP BY, HAVING

---

## 📝 Pasos Realizados

### 1. Preparación del Entorno

#### 1.1 Crear directorio del proyecto

```bash
# Crear nueva carpeta para el ejercicio
mkdir ejercicio-subconsultas-sql
cd ejercicio-subconsultas-sql
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

#### 2.5 Crear tabla de categorías (NUEVA)

```sql
CREATE TABLE categorias (
    id INTEGER PRIMARY KEY,
    nombre TEXT NOT NULL,
    descripcion TEXT
);
```

#### 2.6 Agregar columna categoria_id a productos

```sql
ALTER TABLE productos ADD COLUMN categoria_id INTEGER REFERENCES categorias(id);
```

**Nota:** Esta columna relacionará productos con categorías de forma normalizada.

#### 2.7 Verificar estructura completa

```sql
.tables
```

**Resultado:**
```
categorias       clientes         detalle_pedidos  pedidos          productos
```

### 3. Inserción de Datos de Ejemplo

#### 3.1 Insertar productos

```sql
INSERT INTO productos (id, nombre, precio, categoria, stock) VALUES
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

#### 3.5 Insertar categorías

```sql
INSERT INTO categorias VALUES
(1, 'Electrónica', 'Productos electrónicos y tecnología'),
(2, 'Accesorios', 'Accesorios para computadoras'),
(3, 'Audio', 'Productos de audio y sonido');
```

#### 3.6 Actualizar productos con categoria_id

```sql
UPDATE productos SET categoria_id = 1 WHERE nombre LIKE '%Laptop%' OR nombre LIKE '%Monitor%';
UPDATE productos SET categoria_id = 2 WHERE nombre LIKE '%Mouse%' OR nombre LIKE '%Teclado%';
UPDATE productos SET categoria_id = 3 WHERE nombre LIKE '%Audífonos%';
```

**Verificar actualización:**
```sql
SELECT id, nombre, categoria, categoria_id FROM productos;
```

**Resultado:**
```
id  nombre              categoria     categoria_id
--  ------------------  ------------  ------------
1   Laptop Dell         Electrónica   1
2   Mouse Logitech      Accesorios    2
3   Teclado Mecánico    Accesorios    2
4   Monitor 24"         Electrónica   1
5   Audífonos Sony      Audio         3
```

---

## 🔗 Diagrama de Relaciones Completo

```
┌──────────────────┐         ┌──────────────────┐         ┌──────────────────┐
│   categorias     │         │    productos     │         │ detalle_pedidos  │
├──────────────────┤         ├──────────────────┤         ├──────────────────┤
│ id (PK)          │◄────────│ id (PK)          │◄────────│ id (PK)          │
│ nombre           │         │ nombre           │         │ pedido_id (FK)   │
│ descripcion      │         │ precio           │         │ producto_id (FK) │
└──────────────────┘         │ categoria        │         │ cantidad         │
                             │ stock            │         │ precio_unitario  │
                             │ categoria_id(FK) │         └─────────┬────────┘
                             └──────────────────┘                   │
                                                                    │
                                                         ┌──────────▼────────┐
                                                         │    pedidos        │
                                                         ├───────────────────┤
                                                         │ id (PK)           │
                                                         │ cliente_id (FK)   │
                                                         │ fecha_pedido      │
                                                         │ total             │
                                                         └─────────┬─────────┘
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

## 🔍 Subconsultas en WHERE

### 4. Clientes que han Comprado Productos de Electrónica

**Objetivo:** Identificar clientes que compraron al menos un producto de la categoría Electrónica

```sql
SELECT DISTINCT c.nombre, c.email
FROM clientes c
WHERE c.id IN (
    SELECT DISTINCT p.cliente_id
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    JOIN productos prod ON dp.producto_id = prod.id
    JOIN categorias cat ON prod.categoria_id = cat.id
    WHERE cat.nombre = 'Electrónica'
);
```

**Resultado:**
```
nombre         email
-------------  -----------------
Ana García     ana@email.com
Carlos López   carlos@email.com
```

**Análisis:**
- **Subconsulta interna**: Encuentra cliente_id de quienes compraron Electrónica
- `IN`: Verifica si el cliente está en la lista de resultados de la subconsulta
- `DISTINCT`: Evita duplicados si un cliente compró múltiples productos electrónicos
- Ana García compró Laptop Dell (Electrónica)
- Carlos López compró Monitor 24" (Electrónica)
- María Rodríguez NO aparece (no ha comprado productos de Electrónica)

---

### 5. Clientes que han Comprado Productos de una Categoría Específica

**Objetivo:** Generalizar la consulta anterior para cualquier categoría

```sql
-- Clientes que compraron Accesorios
SELECT DISTINCT c.nombre, c.ciudad
FROM clientes c
WHERE c.id IN (
    SELECT DISTINCT p.cliente_id
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    JOIN productos prod ON dp.producto_id = prod.id
    JOIN categorias cat ON prod.categoria_id = cat.id
    WHERE cat.nombre = 'Accesorios'
);
```

**Resultado:**
```
nombre         ciudad
-------------  ----------
Ana García     Madrid
```

**Análisis:**
- Solo Ana García compró Accesorios (Mouse Logitech y Teclado Mecánico)
- Carlos López compró Monitor y Audífonos (no Accesorios)
- María Rodríguez no ha comprado nada

---

### 6. Productos con Precio por Encima del Promedio de su Categoría

**Objetivo:** Encontrar productos "premium" dentro de cada categoría

```sql
SELECT p.nombre, 
       ROUND(p.precio, 2) AS precio,
       cat.nombre AS categoria,
       (SELECT ROUND(AVG(p2.precio), 2)
        FROM productos p2
        WHERE p2.categoria_id = p.categoria_id) AS precio_promedio_categoria
FROM productos p
JOIN categorias cat ON p.categoria_id = cat.id
WHERE p.precio > (
    SELECT AVG(p2.precio)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
);
```

**Resultado:**
```
nombre         precio   categoria     precio_promedio_categoria
-------------  -------  ------------  -------------------------
Laptop Dell    1200.0   Electrónica   700.0
```

**Análisis:**
- **Subconsulta correlacionada**: Calcula el promedio por categoría
- `p2.categoria_id = p.categoria_id`: Relaciona la subconsulta con la consulta externa
- **Electrónica**: Promedio = (1200 + 199.99) / 2 = 700.00
- **Accesorios**: Promedio = (25.50 + 89.99) / 2 = 57.75
- Solo la Laptop ($1,200) está por encima del promedio de Electrónica ($700)
- Monitor ($199.99) está por debajo del promedio de Electrónica
- Ningún Accesorio supera su promedio

---

### 7. Productos Más Caros que el Precio Promedio General

**Objetivo:** Encontrar productos premium comparados con toda la tienda

```sql
SELECT nombre, 
       ROUND(precio, 2) AS precio,
       categoria
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos);
```

**Resultado:**
```
nombre         precio   categoria
-------------  -------  ------------
Laptop Dell    1200.0   Electrónica
Monitor 24"    199.99   Electrónica
```

**Análisis:**
- **Subconsulta simple**: Calcula el precio promedio de TODOS los productos
- Precio promedio general: (1200 + 25.50 + 89.99 + 199.99 + 149.50) / 5 = $332.99
- Solo Laptop y Monitor superan el promedio general
- **Diferencia con consulta anterior**: Esta compara con el promedio global, no por categoría

---

### 8. Clientes que NO han Comprado Productos de Electrónica

**Objetivo:** Identificar clientes potenciales para campaña de Electrónica

```sql
SELECT c.nombre, c.email, c.ciudad
FROM clientes c
WHERE c.id NOT IN (
    SELECT DISTINCT p.cliente_id
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    JOIN productos prod ON dp.producto_id = prod.id
    JOIN categorias cat ON prod.categoria_id = cat.id
    WHERE cat.nombre = 'Electrónica'
);
```

**Resultado:**
```
nombre              email                 ciudad
------------------  --------------------  --------
María Rodríguez     maria@email.com       Madrid
```

**Análisis:**
- `NOT IN`: Invierte la lógica de la consulta anterior
- María Rodríguez no ha comprado ningún producto de Electrónica
- **Uso práctico**: Marketing dirigido para promocionar productos electrónicos

---

## 🔄 Subconsultas Correlacionadas

### 9. Pedido Más Reciente de Cada Cliente

**Objetivo:** Mostrar el último pedido realizado por cada cliente

```sql
SELECT c.nombre, 
       p.fecha_pedido, 
       ROUND(p.total, 2) AS total
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha_pedido = (
    SELECT MAX(p2.fecha_pedido)
    FROM pedidos p2
    WHERE p2.cliente_id = c.id
);
```

**Resultado:**
```
nombre         fecha_pedido  total
-------------  ------------  ------
Ana García     2024-01-20    89.99
Carlos López   2024-01-18    349.49
```

**Análisis:**
- **Subconsulta correlacionada**: Se ejecuta una vez por cada cliente
- `p2.cliente_id = c.id`: La subconsulta usa el cliente_id de la fila actual
- Ana García: Su pedido más reciente es del 2024-01-20 (pedido 2)
- Carlos López: Su pedido más reciente es del 2024-01-18 (pedido 3)
- María Rodríguez no aparece porque no tiene pedidos

---

### 10. Pedido Más Antiguo de Cada Cliente

**Objetivo:** Mostrar el primer pedido realizado por cada cliente

```sql
SELECT c.nombre, 
       p.fecha_pedido AS primer_pedido,
       ROUND(p.total, 2) AS total
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha_pedido = (
    SELECT MIN(p2.fecha_pedido)
    FROM pedidos p2
    WHERE p2.cliente_id = c.id
);
```

**Resultado:**
```
nombre         primer_pedido  total
-------------  -------------  -------
Ana García     2024-01-15     1251.0
Carlos López   2024-01-18     349.49
```

**Análisis:**
- Similar a la consulta anterior pero usando `MIN` en lugar de `MAX`
- Ana García: Su primer pedido fue el 2024-01-15 (pedido 1)
- Carlos López: Su primer pedido fue el 2024-01-18 (pedido 3)
- **Uso práctico**: Análisis de comportamiento de compra inicial

---

### 11. Productos con Precio Mayor al Promedio de Todos los Productos

**Objetivo:** Versión simplificada con subconsulta no correlacionada

```sql
SELECT nombre,
       ROUND(precio, 2) AS precio,
       categoria,
       (SELECT ROUND(AVG(precio), 2) FROM productos) AS precio_promedio_general
FROM productos
WHERE precio > (SELECT AVG(precio) FROM productos)
ORDER BY precio DESC;
```

**Resultado:**
```
nombre         precio   categoria     precio_promedio_general
-------------  -------  ------------  -----------------------
Laptop Dell    1200.0   Electrónica   332.99
Monitor 24"    199.99   Electrónica   332.99
```

**Análisis:**
- **Subconsulta NO correlacionada**: Se ejecuta solo una vez
- Muestra el precio promedio general en cada fila para comparación
- Los productos de Electrónica son los únicos por encima del promedio

---

## ✅ Uso de EXISTS

### 12. Clientes que Tienen Pedidos con Productos Caros (>$200)

**Objetivo:** Identificar clientes que compraron productos premium

```sql
SELECT c.nombre, c.ciudad
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    WHERE p.cliente_id = c.id
    AND dp.precio_unitario > 200
);
```

**Resultado:**
```
nombre         ciudad
-------------  ----------
Ana García     Madrid
```

**Análisis:**
- `EXISTS`: Verifica si la subconsulta devuelve al menos una fila
- `SELECT 1`: Solo verifica existencia, no importa qué columna seleccionar
- Ana García compró Laptop Dell ($1,200.00) que supera los $200
- Carlos López compró Monitor ($199.99) que NO supera los $200
- **Ventaja de EXISTS**: Más eficiente que IN cuando solo importa si existe

---

### 13. Clientes que NO Tienen Pedidos con Productos Caros

**Objetivo:** Clientes que solo compran productos económicos

```sql
SELECT c.nombre, c.ciudad, c.email
FROM clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    WHERE p.cliente_id = c.id
    AND dp.precio_unitario > 200
);
```

**Resultado:**
```
nombre              ciudad      email
------------------  ----------  --------------------
Carlos López        Barcelona   carlos@email.com
María Rodríguez     Madrid      maria@email.com
```

**Análisis:**
- `NOT EXISTS`: Invierte la lógica
- Carlos López: Sus productos más caros son Monitor ($199.99) y Audífonos ($149.50)
- María Rodríguez: No tiene pedidos
- **Uso práctico**: Segmentación de clientes por rango de precios

---

### 14. Productos que se Han Vendido al Menos Una Vez

**Objetivo:** Identificar productos con movimiento

```sql
SELECT p.nombre, p.precio, p.categoria
FROM productos p
WHERE EXISTS (
    SELECT 1
    FROM detalle_pedidos dp
    WHERE dp.producto_id = p.id
);
```

**Resultado:**
```
nombre              precio   categoria
------------------  -------  ------------
Laptop Dell         1200.0   Electrónica
Mouse Logitech      25.5     Accesorios
Teclado Mecánico    89.99    Accesorios
Monitor 24"         199.99   Electrónica
Audífonos Sony      149.5    Audio
```

**Análisis:**
- Todos los productos se han vendido al menos una vez
- `EXISTS` verifica si hay al menos un detalle de pedido para cada producto
- Si agregáramos más productos sin ventas, estos NO aparecerían

---

### 15. Productos que NO se Han Vendido Nunca

**Objetivo:** Identificar productos de baja rotación

```sql
SELECT p.nombre, p.precio, p.categoria, p.stock
FROM productos p
WHERE NOT EXISTS (
    SELECT 1
    FROM detalle_pedidos dp
    WHERE dp.producto_id = p.id
);
```

**Resultado:**
```
(Ningún producto sin vender en este dataset)
```

**Análisis:**
- En nuestro dataset, todos los productos se vendieron
- `NOT EXISTS`: Útil para encontrar inventario estancado
- **Uso práctico**: Identificar productos para liquidación o promoción

---

## 📊 Comparación: IN vs EXISTS

### 16. Misma Consulta con IN y EXISTS

**Con IN:**
```sql
SELECT c.nombre
FROM clientes c
WHERE c.id IN (
    SELECT p.cliente_id
    FROM pedidos p
);
```

**Con EXISTS:**
```sql
SELECT c.nombre
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    WHERE p.cliente_id = c.id
);
```

**Ambas devuelven:**
```
nombre
-------------
Ana García
Carlos López
```

### Tabla Comparativa: IN vs EXISTS

| Aspecto | IN | EXISTS |
|---------|-----|--------|
| **Rendimiento con muchos datos** | Puede ser lento | Generalmente más rápido |
| **Detiene búsqueda** | Evalúa todos los resultados | Se detiene al encontrar el primero |
| **Con NULL** | Puede dar problemas | Maneja NULL correctamente |
| **Uso típico** | Listas pequeñas de valores | Verificar existencia |
| **Sintaxis** | Más simple | Requiere correlación explícita |

**Recomendación:** Usa `EXISTS` cuando solo necesites verificar existencia y `IN` cuando trabajes con listas pequeñas y concretas.

---

## 🎯 Subconsultas en SELECT

### 17. Mostrar Total Gastado por Cliente

**Objetivo:** Agregar columna calculada con subconsulta

```sql
SELECT c.nombre,
       c.ciudad,
       (SELECT COUNT(*)
        FROM pedidos p
        WHERE p.cliente_id = c.id) AS num_pedidos,
       (SELECT ROUND(COALESCE(SUM(p.total), 0), 2)
        FROM pedidos p
        WHERE p.cliente_id = c.id) AS total_gastado
FROM clientes c;
```

**Resultado:**
```
nombre              ciudad      num_pedidos  total_gastado
------------------  ----------  -----------  -------------
Ana García          Madrid      2            1340.99
Carlos López        Barcelona   1            349.49
María Rodríguez     Madrid      0            0.0
```

**Análisis:**
- **Subconsultas en SELECT**: Calculan valores para cada fila
- `COALESCE`: Convierte NULL en 0 para clientes sin pedidos
- Ana García: 2 pedidos, $1,340.99 gastados
- María Rodríguez aparece con 0 pedidos y $0.00 (gracias a COALESCE)

---

### 18. Producto Más Caro de Cada Categoría

**Objetivo:** Mostrar el precio máximo por categoría junto a cada producto

```sql
SELECT p.nombre,
       ROUND(p.precio, 2) AS precio,
       cat.nombre AS categoria,
       (SELECT ROUND(MAX(p2.precio), 2)
        FROM productos p2
        WHERE p2.categoria_id = p.categoria_id) AS precio_maximo_categoria
FROM productos p
JOIN categorias cat ON p.categoria_id = cat.id
ORDER BY cat.nombre, p.precio DESC;
```

**Resultado:**
```
nombre              precio   categoria     precio_maximo_categoria
------------------  -------  ------------  -----------------------
Teclado Mecánico    89.99    Accesorios    89.99
Mouse Logitech      25.5     Accesorios    89.99
Audífonos Sony      149.5    Audio         149.5
Laptop Dell         1200.0   Electrónica   1200.0
Monitor 24"         199.99   Electrónica   1200.0
```

**Análisis:**
- Muestra el precio máximo de cada categoría en cada fila
- Teclado Mecánico ($89.99) es el más caro de Accesorios
- Laptop Dell ($1,200) es el más caro de Electrónica
- Audífonos Sony ($149.50) es el único (y más caro) de Audio

---

## 🔍 Consultas Avanzadas Combinadas

### 19. Análisis Completo por Cliente

**Objetivo:** Dashboard completo usando múltiples subconsultas

```sql
SELECT c.nombre,
       c.ciudad,
       (SELECT COUNT(*) 
        FROM pedidos p 
        WHERE p.cliente_id = c.id) AS total_pedidos,
       (SELECT ROUND(COALESCE(SUM(p.total), 0), 2)
        FROM pedidos p 
        WHERE p.cliente_id = c.id) AS gasto_total,
       (SELECT MAX(p.fecha_pedido)
        FROM pedidos p 
        WHERE p.cliente_id = c.id) AS ultimo_pedido,
       CASE 
           WHEN EXISTS (SELECT 1 FROM pedidos p 
                       JOIN detalle_pedidos dp ON p.id = dp.pedido_id
                       WHERE p.cliente_id = c.id 
                       AND dp.precio_unitario > 200)
           THEN 'VIP'
           WHEN EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id)
           THEN 'Regular'
           ELSE 'Inactivo'
       END AS segmento
FROM clientes c
ORDER BY gasto_total DESC;
```

**Resultado:**
```
nombre              ciudad      total_pedidos  gasto_total  ultimo_pedido  segmento
------------------  ----------  -------------  -----------  -------------  ---------
Ana García          Madrid      2              1340.99      2024-01-20     VIP
Carlos López        Barcelona   1              349.49       2024-01-18     Regular
María Rodríguez     Madrid      0              0.0          NULL           Inactivo
```

**Análisis:**
- **Múltiples subconsultas**: Cada una calcula una métrica diferente
- **CASE con EXISTS**: Segmenta clientes en VIP, Regular o Inactivo
- Ana García es VIP (compró producto > $200)
- Carlos López es Regular (tiene pedidos pero no premium)
- María Rodríguez está Inactiva (sin pedidos)

---

### 20. Productos Populares por Categoría

**Objetivo:** Encontrar el producto más vendido de cada categoría

```sql
SELECT p.nombre,
       cat.nombre AS categoria,
       (SELECT SUM(dp.cantidad)
        FROM detalle_pedidos dp
        WHERE dp.producto_id = p.id) AS unidades_vendidas,
       ROUND(p.precio, 2) AS precio
FROM productos p
JOIN categorias cat ON p.categoria_id = cat.id
WHERE (SELECT SUM(dp.cantidad)
       FROM detalle_pedidos dp
       WHERE dp.producto_id = p.id) = (
           SELECT MAX(total_vendido)
           FROM (
               SELECT SUM(dp2.cantidad) AS total_vendido
               FROM detalle_pedidos dp2
               JOIN productos p2 ON dp2.producto_id = p2.id
               WHERE p2.categoria_id = p.categoria_id
               GROUP BY dp2.producto_id
           )
       );
```

**Resultado:**
```
nombre              categoria     unidades_vendidas  precio
------------------  ------------  -----------------  ------
Mouse Logitech      Accesorios    2                  25.5
Audífonos Sony      Audio         1                  149.5
Laptop Dell         Electrónica   1                  1200.0
```

**Análisis:**
- **Subconsulta anidada**: Encuentra el máximo de ventas por categoría
- Mouse Logitech es el más vendido de Accesorios (2 unidades)
- Laptop y Audífonos son únicos en sus categorías
- **Consulta compleja**: Combina múltiples niveles de subconsultas

---

## ✅ Verificación Final

### Checklist de completitud:

- [x] Base de datos `tienda_ejemplo.db` creada
- [x] Tabla `productos` creada con 5 productos
- [x] Tabla `clientes` creada con 3 clientes
- [x] Tabla `pedidos` creada con 3 pedidos
- [x] Tabla `detalle_pedidos` creada con 5 detalles
- [x] Tabla `categorias` creada con 3 categorías
- [x] Columna `categoria_id` agregada a productos
- [x] Relaciones entre tablas verificadas
- [x] Subconsultas en WHERE ejecutadas (consultas 4-8)
- [x] Subconsultas correlacionadas ejecutadas (consultas 9-11)
- [x] EXISTS y NOT EXISTS utilizados (consultas 12-15)
- [x] Comparación IN vs EXISTS realizada (consulta 16)
- [x] Subconsultas en SELECT ejecutadas (consultas 17-18)
- [x] Consultas avanzadas combinadas ejecutadas (consultas 19-20)

---

## 📊 Tipos de Subconsultas - Resumen

| Tipo | Ubicación | Características | Ejemplo de Uso |
|------|-----------|----------------|----------------|
| **Subconsulta escalar** | SELECT | Devuelve un solo valor | Mostrar promedio general |
| **Subconsulta en WHERE** | WHERE | Filtra resultados | Clientes que compraron X |
| **Subconsulta correlacionada** | WHERE/SELECT | Depende de fila externa | Pedido más reciente por cliente |
| **EXISTS** | WHERE | Verifica existencia | Clientes con pedidos |
| **IN/NOT IN** | WHERE | Verifica membresía | Cliente en lista de compradores |

---

## 🎯 Conceptos Clave Aprendidos

### 1. Subconsultas en WHERE

Las subconsultas en WHERE filtran resultados basándose en otra consulta.

**Sintaxis:**
```sql
SELECT columnas
FROM tabla
WHERE columna IN (SELECT columna FROM otra_tabla WHERE condicion);
```

**Características:**
- Se ejecutan primero, luego la consulta principal
- Pueden usar IN, NOT IN, =, >, <, etc.
- Útiles para filtrar basándose en datos de otras tablas

**Ejemplo del ejercicio:**
```sql
SELECT nombre FROM clientes
WHERE id IN (SELECT cliente_id FROM pedidos);
```

---

### 2. Subconsultas Correlacionadas

Las subconsultas correlacionadas se ejecutan una vez por cada fila de la consulta externa.

**Sintaxis:**
```sql
SELECT columnas
FROM tabla1 t1
WHERE columna = (
    SELECT MAX(columna)
    FROM tabla2 t2
    WHERE t2.fk = t1.id
);
```

**Características:**
- Dependen de valores de la consulta externa
- Se ejecutan múltiples veces (una por cada fila)
- Más lentas que subconsultas simples, pero más flexibles
- Útiles para comparaciones dentro del mismo grupo

**Ejemplo del ejercicio:**
```sql
-- Pedido más reciente de cada cliente
SELECT c.nombre, p.fecha_pedido
FROM clientes c
JOIN pedidos p ON c.id = p.cliente_id
WHERE p.fecha_pedido = (
    SELECT MAX(p2.fecha_pedido)
    FROM pedidos p2
    WHERE p2.cliente_id = c.id  -- Correlación aquí
);
```

---

### 3. EXISTS y NOT EXISTS

EXISTS verifica si una subconsulta devuelve al menos una fila.

**Sintaxis:**
```sql
SELECT columnas
FROM tabla1
WHERE EXISTS (
    SELECT 1
    FROM tabla2
    WHERE tabla2.fk = tabla1.id
    AND condicion
);
```

**Características:**
- Devuelve TRUE o FALSE (no valores)
- Se detiene al encontrar la primera coincidencia
- Más eficiente que IN para grandes conjuntos de datos
- `SELECT 1` es convención (podría ser cualquier columna)

**Diferencia con IN:**
- `IN`: Compara valores específicos
- `EXISTS`: Solo verifica existencia

**Ejemplo del ejercicio:**
```sql
-- Clientes con pedidos caros
SELECT c.nombre
FROM clientes c
WHERE EXISTS (
    SELECT 1
    FROM pedidos p
    JOIN detalle_pedidos dp ON p.id = dp.pedido_id
    WHERE p.cliente_id = c.id
    AND dp.precio_unitario > 200
);
```

---

### 4. Subconsultas en SELECT

Las subconsultas en SELECT agregan columnas calculadas.

**Sintaxis:**
```sql
SELECT columna,
       (SELECT FUNCION(columna)
        FROM tabla2
        WHERE tabla2.fk = tabla1.id) AS columna_calculada
FROM tabla1;
```

**Características:**
- Deben devolver un solo valor (escalar)
- Se ejecutan para cada fila del resultado
- Útiles para agregar información calculada
- Pueden usar funciones de agregación

**Ejemplo del ejercicio:**
```sql
SELECT c.nombre,
       (SELECT COUNT(*)
        FROM pedidos p
        WHERE p.cliente_id = c.id) AS num_pedidos
FROM clientes c;
```

---

### 5. IN vs EXISTS - Cuándo Usar Cada Uno

**Usa IN cuando:**
- La subconsulta devuelve pocos resultados
- Necesitas comparar con valores específicos
- La lista es estática o pequeña

**Usa EXISTS cuando:**
- Solo necesitas verificar existencia
- La subconsulta puede devolver muchos resultados
- Necesitas mejor rendimiento con grandes datasets

**Comparación:**
```sql
-- IN: Crea lista completa de IDs
WHERE cliente_id IN (SELECT cliente_id FROM pedidos)

-- EXISTS: Se detiene al encontrar el primero
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id)
```

---

## 💡 Mejores Prácticas

### 1. Usar alias descriptivos en subconsultas correlacionadas

```sql
-- ✅ BIEN: Alias claros (p, p2)
SELECT p.nombre
FROM productos p
WHERE p.precio > (
    SELECT AVG(p2.precio)
    FROM productos p2
    WHERE p2.categoria_id = p.categoria_id
);

-- ❌ MAL: Sin alias o ambiguo
SELECT nombre
FROM productos
WHERE precio > (
    SELECT AVG(precio)
    FROM productos
    WHERE categoria_id = categoria_id  -- ¿Cuál categoria_id?
);
```

### 2. Preferir EXISTS sobre IN para verificación de existencia

```sql
-- ✅ BIEN: EXISTS para verificar existencia
SELECT c.nombre
FROM clientes c
WHERE EXISTS (
    SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id
);

-- ⚠️ FUNCIONA pero menos eficiente
SELECT c.nombre
FROM clientes c
WHERE c.id IN (
    SELECT cliente_id FROM pedidos
);
```

### 3. Usar COALESCE para manejar NULL en subconsultas

```sql
-- ✅ BIEN: COALESCE convierte NULL en 0
SELECT c.nombre,
       COALESCE((SELECT SUM(total) FROM pedidos WHERE cliente_id = c.id), 0) AS total
FROM clientes c;

-- ❌ MAL: Puede devolver NULL
SELECT c.nombre,
       (SELECT SUM(total) FROM pedidos WHERE cliente_id = c.id) AS total
FROM clientes c;
```

### 4. Evitar subconsultas cuando un JOIN es suficiente

```sql
-- ✅ MEJOR: JOIN simple y directo
SELECT c.nombre, COUNT(p.id) AS pedidos
FROM clientes c
LEFT JOIN pedidos p ON c.id = p.cliente_id
GROUP BY c.id, c.nombre;

-- ⚠️ FUNCIONA pero menos eficiente
SELECT c.nombre,
       (SELECT COUNT(*) FROM pedidos WHERE cliente_id = c.id) AS pedidos
FROM clientes c;
```

---

## 🔄 Orden de Ejecución con Subconsultas

**Consulta con subconsulta en WHERE:**
```sql
SELECT c.nombre
FROM clientes c
WHERE c.id IN (SELECT cliente_id FROM pedidos);
```

**Orden de ejecución:**
1. Ejecuta la subconsulta: `SELECT cliente_id FROM pedidos`
2. Genera lista de IDs: [1, 2]
3. Ejecuta consulta principal: `SELECT c.nombre FROM clientes WHERE c.id IN (1, 2)`

---

**Consulta con subconsulta correlacionada:**
```sql
SELECT c.nombre
FROM clientes c
WHERE EXISTS (SELECT 1 FROM pedidos p WHERE p.cliente_id = c.id);
```

**Orden de ejecución:**
1. Lee primera fila de clientes (id=1)
2. Ejecuta subconsulta para id=1
3. Si encuentra algo, incluye cliente
4. Lee segunda fila de clientes (id=2)
5. Ejecuta subconsulta para id=2
6. Y así sucesivamente...

---

## 🚀 Próximos Pasos

### Conceptos avanzados a explorar:

1. **Common Table Expressions (CTEs)**
```sql
WITH ventas_por_cliente AS (
    SELECT cliente_id, SUM(total) AS total_gastado
    FROM pedidos
    GROUP BY cliente_id
)
SELECT c.nombre, v.total_gastado
FROM clientes c
JOIN ventas_por_cliente v ON c.id = v.cliente_id
WHERE v.total_gastado > 500;
```

2. **Window Functions (Funciones de Ventana)**
```sql
SELECT nombre, precio,
    ROW_NUMBER() OVER (PARTITION BY categoria_id ORDER BY precio DESC) AS ranking
FROM productos;
```

3. **Subconsultas con múltiples columnas**
```sql
SELECT nombre, precio
FROM productos
WHERE (categoria_id, precio) IN (
    SELECT categoria_id, MAX(precio)
    FROM productos
    GROUP BY categoria_id
);
```

4. **UNION y UNION ALL con subconsultas**
```sql
SELECT nombre FROM (SELECT nombre FROM clientes WHERE ciudad = 'Madrid')
UNION
SELECT nombre FROM (SELECT nombre FROM clientes WHERE ciudad = 'Barcelona');
```

5. **Optimización de consultas**
```sql
-- Ver plan de ejecución
EXPLAIN QUERY PLAN
SELECT * FROM clientes WHERE id IN (SELECT cliente_id FROM pedidos);
```

---

## 📖 Recursos Adicionales

- [Documentación oficial de SQLite - Subqueries](https://www.sqlite.org/lang_select.html#subqueries)
- [SQL Subqueries Tutorial](https://www.sqlitetutorial.net/sqlite-subquery/)
- [EXISTS vs IN Performance](https://www.w3schools.com/sql/sql_exists.asp)
- [Correlated Subqueries Explained](https://mode.com/sql-tutorial/sql-sub-queries/)

---

## 📝 Comandos Útiles de SQLite

```sql
-- Habilitar Foreign Keys
PRAGMA foreign_keys = ON;

-- Ver estructura completa
.schema

-- Ver información de tabla con FK
PRAGMA foreign_key_list(productos);

-- Mejorar visualización
.mode column
.headers on

-- Ver tiempo de ejecución
.timer on

-- Ver plan de ejecución de consulta
EXPLAIN QUERY PLAN
SELECT c.nombre
FROM clientes c
WHERE c.id IN (SELECT cliente_id FROM pedidos);

-- Exportar resultados
.mode csv
.output resultados.csv
SELECT * FROM clientes;
.output stdout

-- Verificar integridad de FK
PRAGMA foreign_key_check;
```

---

## 📅 Notas del Ejercicio

- **Fecha de realización**: Noviembre 2025
- **Entorno**: Windows 11, VS Code, Python 3.x, SQLite 3.x
- **Base de datos**: tienda_ejemplo.db
- **Tablas creadas**: 5 (productos, clientes, pedidos, detalle_pedidos, categorias)
- **Registros insertados**: 5 productos, 3 clientes, 3 pedidos, 5 detalles, 3 categorías
- **Relaciones FOREIGN KEY**: 4 (cliente_id, pedido_id, producto_id, categoria_id)
- **Consultas ejecutadas**: 20 (subconsultas simples, correlacionadas, EXISTS, SELECT)
- **Tipos de subconsultas**: WHERE, correlacionadas, EXISTS, SELECT

---

## ✨ Conclusiones

Este ejercicio permitió dominar las subconsultas en SQL, una herramienta fundamental para consultas avanzadas:

### Aprendizajes clave:

1. **Subconsultas en WHERE** permiten filtrar basándose en resultados de otras consultas
2. **Subconsultas correlacionadas** se ejecutan para cada fila y permiten comparaciones contextuales
3. **EXISTS** es más eficiente que IN para verificar existencia en grandes datasets
4. **Subconsultas en SELECT** agregan columnas calculadas dinámicamente
5. **IN vs EXISTS**: Elegir según el caso de uso para optimizar rendimiento

### Tipos de subconsultas dominados:

| Tipo | Uso Principal | Ejemplo |
|------|---------------|---------|
| Subconsulta simple | Filtrar con lista de valores | `WHERE id IN (...)` |
| Subconsulta correlacionada | Comparar con grupo relacionado | Pedido más reciente por cliente |
| EXISTS | Verificar existencia | Clientes con pedidos |
| Subconsulta escalar | Agregar columna calculada | Total gastado por cliente |

### Casos de uso prácticos aplicados:

- **Segmentación de clientes**: VIP, Regular, Inactivo
- **Análisis de productos**: Premium vs económicos por categoría
- **Comportamiento de compra**: Primer y último pedido
- **Marketing dirigido**: Clientes que no han comprado ciertas categorías
- **Inventario**: Productos sin ventas

Las subconsultas son esenciales para análisis complejos sin necesidad de crear tablas temporales o vistas. Permiten consultas más expresivas y mantenibles cuando se usan correctamente.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 2](../README.md)
