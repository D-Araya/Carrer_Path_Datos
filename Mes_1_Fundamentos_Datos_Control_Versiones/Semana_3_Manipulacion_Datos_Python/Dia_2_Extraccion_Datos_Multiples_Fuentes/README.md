# Ejercicio: Extracción de Datos desde Múltiples Fuentes con Python

## 📋 Objetivo
Dominar las técnicas de extracción de datos desde diferentes fuentes heterogéneas (CSV, Excel, JSON, SQLite, APIs) utilizando Python y Pandas, comprendiendo las particularidades de cada formato y cómo consolidarlos en DataFrames para su análisis.

---

## 🧠 Conceptos Fundamentales: La Extracción como Base del Análisis (El Pilar E)

La **Extracción** es el primer y más fundamental paso en cualquier proceso de análisis de datos o flujo ETL (Extract, Transform, Load). Consiste en leer datos desde su fuente original (archivos, bases de datos, APIs) y cargarlos en un entorno de procesamiento unificado.

El uso de **Pandas** en este proceso es clave, ya que proporciona la estructura de datos `DataFrame`, un objeto optimizado que sirve como **contenedor temporal y estándar** para consolidar información heterogénea antes de su limpieza y análisis.

### 1. La Heterogeneidad de las Fuentes

El mundo real presenta datos en múltiples formatos, cada uno con sus propias particularidades que Python debe manejar:

| Tipo de Fuente | Formato | Rol de Pandas y Bibliotecas |
| :--- | :--- | :--- |
| **Datos Tabulares (Archivos Planos)** | `CSV` (Comma Separated Values) | La función `pd.read_csv()` es el estándar para datos delimitados. Es esencial para la carga rápida y el manejo de grandes volúmenes de datos simples. |
| **Datos Tabulares (Estructurados)** | `Excel` (`.xlsx`, `.xls`) | Requiere bibliotecas auxiliares como **`openpyxl`**. Permite leer múltiples hojas de trabajo (sheets) dentro de un mismo archivo, manteniendo la estructura de celdas. |
| **Datos Jerárquicos** | `JSON` (JavaScript Object Notation) | Usado frecuentemente en APIs y NoSQL. Su estructura de clave-valor requiere una "aplanación" o normalización para ser interpretada correctamente por las filas y columnas de un DataFrame. |
| **Bases de Datos Relacionales** | `SQLite` | Pandas utiliza el módulo `sqlite3` y la función `pd.read_sql()` para ejecutar consultas SQL. Esto extrae solo el resultado de la consulta, no la base de datos completa. |
| **Servicios Web** | `API REST` | Requiere la biblioteca **`requests`** para hacer llamadas HTTP y recuperar la respuesta, que usualmente está en formato JSON. Luego, Pandas procesa ese JSON. |

### 2. El Ciclo de Extracción

El objetivo final de la extracción es garantizar la **integridad de los datos** y la **robustez del proceso**. Una extracción bien diseñada debe:

1.  **Establecer la conexión** (ej., ruta de archivo, URL, conexión a base de datos).
2.  **Leer los datos** con la función adecuada (`read_csv`, `read_json`, etc.).
3.  **Manejar Errores** (ej., archivos no encontrados, columnas faltantes).
4.  **Normalizar**: Convertir el formato extraído (JSON, API) a la estructura columnar de un `DataFrame`.
5.  **Cerrar la conexión** (especialmente en bases de datos).

Dominar estas técnicas permite al analista acceder y consolidar la información necesaria para las fases posteriores de Transformación y Análisis.

---

## 🛠️ Requerimientos

- **Sistema operativo:** Windows 11
- **Python:** Versión 3.8 o superior
- **Entorno virtual:** Activo y configurado
- **Editor de código:** Visual Studio Code
- **Bibliotecas necesarias:**
  - pandas (ya instalado)
  - openpyxl (para archivos Excel)
  - requests (para APIs)
- **Conocimientos previos:** Python básico, Pandas básico

---

## 📝 Pasos Realizados

### 1. Preparación del Entorno

#### 1.1 Crear directorio del proyecto

```bash
# Navegar a la carpeta del Career Path
cd Carrer_Path_Datos

# Crear nueva carpeta para el ejercicio
mkdir ejercicio-extraccion-datos
cd ejercicio-extraccion-datos
```

#### 1.2 Crear y activar entorno virtual

```bash
# Crear entorno virtual
python -m venv venv_extraccion

# Activar entorno virtual (Windows)
venv_extraccion\Scripts\activate
```

**Resultado esperado:**
```
(venv_extraccion) C:\Users\...\ejercicio-extraccion-datos>
```

#### 1.3 Instalar bibliotecas necesarias

```bash
# Actualizar pip
python -m pip install --upgrade pip

# Instalar pandas (si no está instalado)
pip install pandas

# Instalar openpyxl para trabajar con Excel
pip install openpyxl

# Instalar requests para APIs
pip install requests
```

**Resultado esperado para openpyxl:**
```
Collecting openpyxl
  Downloading openpyxl-x.x.x-py2.py3-none-any.whl
Collecting et-xmlfile
Installing collected packages: et-xmlfile, openpyxl
Successfully installed et-xmlfile-x.x.x openpyxl-x.x.x
```

**Resultado esperado para requests:**
```
Collecting requests
  Downloading requests-x.x.x-py3-none-any.whl
Collecting charset-normalizer
Collecting idna
Collecting urllib3
Collecting certifi
Installing collected packages: urllib3, idna, charset-normalizer, certifi, requests
Successfully installed certifi-x.x.x charset-normalizer-x.x.x idna-x.x.x requests-x.x.x urllib3-x.x.x
```

#### 1.4 Verificar instalación

```bash
python -c "import pandas as pd; import openpyxl; import requests; print('Pandas:', pd.__version__); print('Openpyxl:', openpyxl.__version__); print('Requests:', requests.__version__)"
```

**Resultado esperado:**
```
Pandas: 2.1.x
Openpyxl: 3.1.x
Requests: 2.31.x
```

---

### 2. Crear Archivos de Datos de Ejemplo

#### 2.1 Crear script generador_datos.py

Crear un archivo llamado `generador_datos.py` con el siguiente contenido:

```python
"""
generador_datos.py
Script para generar datos de ejemplo en diferentes formatos:
- CSV
- Excel (múltiples hojas)
- JSON
- SQLite
"""

import pandas as pd
import sqlite3
import json

print("=" * 60)
print("GENERADOR DE DATOS DE EJEMPLO")
print("=" * 60)

# ============================================
# 1. CREAR ARCHIVO CSV
# ============================================
print("\n[1/4] Generando archivo CSV...")

ventas_csv = pd.DataFrame({
    'id_venta': range(1, 6),
    'producto': ['Laptop', 'Mouse', 'Teclado', 'Monitor', 'Audífonos'],
    'precio': [1200.00, 25.50, 80.00, 300.00, 150.00],
    'cantidad': [1, 2, 1, 1, 3]
})

ventas_csv.to_csv('ventas.csv', index=False)
print("✓ Archivo 'ventas.csv' creado exitosamente")
print(f"  - Registros: {len(ventas_csv)}")
print(f"  - Columnas: {list(ventas_csv.columns)}")

# ============================================
# 2. CREAR ARCHIVO EXCEL CON MÚLTIPLES HOJAS
# ============================================
print("\n[2/4] Generando archivo Excel con múltiples hojas...")

# Hoja 1: Ventas
ventas_excel = pd.DataFrame({
    'id_venta': range(1, 6),
    'producto': ['Laptop', 'Mouse', 'Teclado', 'Monitor', 'Audífonos'],
    'precio': [1200.00, 25.50, 80.00, 300.00, 150.00],
    'cantidad': [1, 2, 1, 1, 3]
})

# Hoja 2: Clientes
clientes_df = pd.DataFrame({
    'id_cliente': [1, 2, 3, 4, 5],
    'nombre': ['Ana García', 'Carlos López', 'María Rodríguez', 'Pedro Martínez', 'Laura Fernández'],
    'ciudad': ['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao'],
    'email': ['ana@email.com', 'carlos@email.com', 'maria@email.com', 'pedro@email.com', 'laura@email.com']
})

# Hoja 3: Categorías
categorias_df = pd.DataFrame({
    'id_categoria': [1, 2, 3],
    'nombre_categoria': ['Electrónica', 'Accesorios', 'Audio'],
    'descripcion': ['Productos electrónicos', 'Accesorios para PC', 'Equipos de audio']
})

# Escribir múltiples hojas en un solo archivo Excel
with pd.ExcelWriter('datos.xlsx', engine='openpyxl') as writer:
    ventas_excel.to_excel(writer, sheet_name='Ventas', index=False)
    clientes_df.to_excel(writer, sheet_name='Clientes', index=False)
    categorias_df.to_excel(writer, sheet_name='Categorias', index=False)

print("✓ Archivo 'datos.xlsx' creado exitosamente")
print(f"  - Hojas: Ventas ({len(ventas_excel)} registros), Clientes ({len(clientes_df)} registros), Categorias ({len(categorias_df)} registros)")

# ============================================
# 3. CREAR ARCHIVO JSON
# ============================================
print("\n[3/4] Generando archivo JSON...")

productos_json = [
    {
        'id_producto': 101,
        'nombre': 'Laptop Dell',
        'categoria': 'Electrónica',
        'precio': 1200.00,
        'stock': 15,
        'disponible': True
    },
    {
        'id_producto': 102,
        'nombre': 'Mouse Logitech',
        'categoria': 'Accesorios',
        'precio': 25.50,
        'stock': 50,
        'disponible': True
    },
    {
        'id_producto': 103,
        'nombre': 'Teclado Mecánico',
        'categoria': 'Accesorios',
        'precio': 80.00,
        'stock': 30,
        'disponible': True
    },
    {
        'id_producto': 104,
        'nombre': 'Monitor 24"',
        'categoria': 'Electrónica',
        'precio': 300.00,
        'stock': 12,
        'disponible': True
    },
    {
        'id_producto': 105,
        'nombre': 'Audífonos Sony',
        'categoria': 'Audio',
        'precio': 150.00,
        'stock': 25,
        'disponible': False
    }
]

with open('productos.json', 'w', encoding='utf-8') as f:
    json.dump(productos_json, f, indent=4, ensure_ascii=False)

print("✓ Archivo 'productos.json' creado exitosamente")
print(f"  - Registros: {len(productos_json)}")

# ============================================
# 4. CREAR BASE DE DATOS SQLITE
# ============================================
print("\n[4/4] Generando base de datos SQLite...")

# Crear conexión a la base de datos
conn = sqlite3.connect('ventas.db')

# Tabla 1: Pedidos
pedidos_df = pd.DataFrame({
    'id_pedido': [1, 2, 3, 4, 5],
    'id_cliente': [1, 2, 1, 3, 2],
    'fecha': ['2024-01-15', '2024-01-16', '2024-01-17', '2024-01-18', '2024-01-19'],
    'total': [1225.00, 51.00, 380.00, 150.00, 1200.00],
    'estado': ['Entregado', 'Entregado', 'En proceso', 'Entregado', 'Pendiente']
})

# Tabla 2: Detalle de pedidos
detalle_pedidos_df = pd.DataFrame({
    'id_detalle': range(1, 8),
    'id_pedido': [1, 1, 2, 3, 3, 4, 5],
    'id_producto': [101, 102, 102, 103, 104, 105, 101],
    'cantidad': [1, 1, 2, 1, 1, 1, 1],
    'precio_unitario': [1200.00, 25.00, 25.50, 80.00, 300.00, 150.00, 1200.00]
})

# Escribir tablas en SQLite
pedidos_df.to_sql('pedidos', conn, index=False, if_exists='replace')
detalle_pedidos_df.to_sql('detalle_pedidos', conn, index=False, if_exists='replace')

# Verificar tablas creadas
cursor = conn.cursor()
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tablas = cursor.fetchall()

conn.close()

print("✓ Base de datos 'ventas.db' creada exitosamente")
print(f"  - Tablas: {[tabla[0] for tabla in tablas]}")
print(f"  - Pedidos: {len(pedidos_df)} registros")
print(f"  - Detalle pedidos: {len(detalle_pedidos_df)} registros")

# ============================================
# RESUMEN
# ============================================
print("\n" + "=" * 60)
print("✓ GENERACIÓN COMPLETADA")
print("=" * 60)
print("\nArchivos creados:")
print("  1. ventas.csv (CSV)")
print("  2. datos.xlsx (Excel con 3 hojas)")
print("  3. productos.json (JSON)")
print("  4. ventas.db (SQLite con 2 tablas)")
print("\n¡Listo para el siguiente paso!")
```

#### 2.2 Ejecutar el script generador

```bash
python generador_datos.py
```

**Resultado esperado:**
```
============================================================
GENERADOR DE DATOS DE EJEMPLO
============================================================

[1/4] Generando archivo CSV...
✓ Archivo 'ventas.csv' creado exitosamente
  - Registros: 5
  - Columnas: ['id_venta', 'producto', 'precio', 'cantidad']

[2/4] Generando archivo Excel con múltiples hojas...
✓ Archivo 'datos.xlsx' creado exitosamente
  - Hojas: Ventas (5 registros), Clientes (5 registros), Categorias (3 registros)

[3/4] Generando archivo JSON...
✓ Archivo 'productos.json' creado exitosamente
  - Registros: 5

[4/4] Generando base de datos SQLite...
✓ Base de datos 'ventas.db' creada exitosamente
  - Tablas: ['pedidos', 'detalle_pedidos']
  - Pedidos: 5 registros
  - Detalle pedidos: 7 registros

============================================================
✓ GENERACIÓN COMPLETADA
============================================================

Archivos creados:
  1. ventas.csv (CSV)
  2. datos.xlsx (Excel con 3 hojas)
  3. productos.json (JSON)
  4. ventas.db (SQLite con 2 tablas)

¡Listo para el siguiente paso!
```

#### 2.3 Verificar archivos creados

En la carpeta del proyecto deben aparecer:
- `ventas.csv`
- `datos.xlsx`
- `productos.json`
- `ventas.db`

---

### 3. Extracción de Datos desde CSV

#### 3.1 Crear script extraccion_csv.py

```python
"""
extraccion_csv.py
Extracción de datos desde archivos CSV
"""

import pandas as pd

print("=" * 60)
print("EXTRACCIÓN DE DATOS DESDE CSV")
print("=" * 60)

# Leer archivo CSV
df_csv = pd.read_csv('ventas.csv')

print("\n📊 Información del DataFrame:")
print(f"  - Dimensiones: {df_csv.shape} (filas x columnas)")
print(f"  - Columnas: {list(df_csv.columns)}")
print(f"  - Tipos de datos:\n{df_csv.dtypes}")

print("\n📋 Primeras 5 filas:")
print(df_csv.head())

print("\n📈 Estadísticas básicas:")
print(df_csv.describe())

print("\n💰 Total de ventas:")
total_ventas = (df_csv['precio'] * df_csv['cantidad']).sum()
print(f"  ${total_ventas:,.2f}")

print("\n✓ Extracción desde CSV completada")
```

#### 3.2 Ejecutar el script

```bash
python extraccion_csv.py
```

**Resultado esperado:**
```
============================================================
EXTRACCIÓN DE DATOS DESDE CSV
============================================================

📊 Información del DataFrame:
  - Dimensiones: (5, 4) (filas x columnas)
  - Columnas: ['id_venta', 'producto', 'precio', 'cantidad']
  - Tipos de datos:
id_venta      int64
producto     object
precio      float64
cantidad      int64
dtype: object

📋 Primeras 5 filas:
   id_venta    producto  precio  cantidad
0         1      Laptop  1200.0         1
1         2       Mouse    25.5         2
2         3     Teclado    80.0         1
3         4     Monitor   300.0         1
4         5  Audífonos   150.0         3

📈 Estadísticas básicas:
       id_venta       precio    cantidad
count       5.0     5.000000    5.000000
mean        3.0   351.100000    1.600000
std         1.6   473.566982    0.894427
min         1.0    25.500000    1.000000
25%         2.0    80.000000    1.000000
50%         3.0   150.000000    1.000000
75%         4.0   300.000000    2.000000
max         5.0  1200.000000    3.000000

💰 Total de ventas:
  $2,001.00

✓ Extracción desde CSV completada
```

---

### 4. Extracción de Datos desde Excel

#### 4.1 Crear script extraccion_excel.py

```python
"""
extraccion_excel.py
Extracción de datos desde archivos Excel (múltiples hojas)
"""

import pandas as pd

print("=" * 60)
print("EXTRACCIÓN DE DATOS DESDE EXCEL")
print("=" * 60)

# Leer archivo Excel y ver todas las hojas disponibles
excel_file = pd.ExcelFile('datos.xlsx')
print(f"\n📑 Hojas disponibles: {excel_file.sheet_names}")

# Hoja 1: Ventas
print("\n" + "=" * 60)
print("HOJA 1: VENTAS")
print("=" * 60)

df_excel_ventas = pd.read_excel('datos.xlsx', sheet_name='Ventas')

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_excel_ventas.shape}")
print(f"  - Columnas: {list(df_excel_ventas.columns)}")

print("\n📋 Datos:")
print(df_excel_ventas)

# Hoja 2: Clientes
print("\n" + "=" * 60)
print("HOJA 2: CLIENTES")
print("=" * 60)

df_excel_clientes = pd.read_excel('datos.xlsx', sheet_name='Clientes')

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_excel_clientes.shape}")
print(f"  - Columnas: {list(df_excel_clientes.columns)}")

print("\n📋 Datos:")
print(df_excel_clientes)

# Hoja 3: Categorías
print("\n" + "=" * 60)
print("HOJA 3: CATEGORÍAS")
print("=" * 60)

df_excel_categorias = pd.read_excel('datos.xlsx', sheet_name='Categorias')

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_excel_categorias.shape}")
print(f"  - Columnas: {list(df_excel_categorias.columns)}")

print("\n📋 Datos:")
print(df_excel_categorias)

# Leer todas las hojas a la vez
print("\n" + "=" * 60)
print("LEER TODAS LAS HOJAS SIMULTÁNEAMENTE")
print("=" * 60)

todas_hojas = pd.read_excel('datos.xlsx', sheet_name=None)

print(f"\n📊 Hojas cargadas: {list(todas_hojas.keys())}")
for nombre_hoja, df in todas_hojas.items():
    print(f"  - {nombre_hoja}: {df.shape[0]} filas, {df.shape[1]} columnas")

print("\n✓ Extracción desde Excel completada")
```

#### 4.2 Ejecutar el script

```bash
python extraccion_excel.py
```

**Resultado esperado:**
```
============================================================
EXTRACCIÓN DE DATOS DESDE EXCEL
============================================================

📑 Hojas disponibles: ['Ventas', 'Clientes', 'Categorias']

============================================================
HOJA 1: VENTAS
============================================================

📊 Información:
  - Dimensiones: (5, 4)
  - Columnas: ['id_venta', 'producto', 'precio', 'cantidad']

📋 Datos:
   id_venta    producto  precio  cantidad
0         1      Laptop  1200.0         1
1         2       Mouse    25.5         2
2         3     Teclado    80.0         1
3         4     Monitor   300.0         1
4         5  Audífonos   150.0         3

============================================================
HOJA 2: CLIENTES
============================================================

📊 Información:
  - Dimensiones: (5, 4)
  - Columnas: ['id_cliente', 'nombre', 'ciudad', 'email']

📋 Datos:
   id_cliente              nombre     ciudad            email
0           1          Ana García     Madrid    ana@email.com
1           2        Carlos López  Barcelona carlos@email.com
2           3    María Rodríguez   Valencia  maria@email.com
3           4     Pedro Martínez    Sevilla  pedro@email.com
4           5    Laura Fernández     Bilbao  laura@email.com

============================================================
HOJA 3: CATEGORÍAS
============================================================

📊 Información:
  - Dimensiones: (3, 3)
  - Columnas: ['id_categoria', 'nombre_categoria', 'descripcion']

📋 Datos:
   id_categoria nombre_categoria           descripcion
0             1      Electrónica  Productos electrónicos
1             2       Accesorios       Accesorios para PC
2             3            Audio        Equipos de audio

============================================================
LEER TODAS LAS HOJAS SIMULTÁNEAMENTE
============================================================

📊 Hojas cargadas: ['Ventas', 'Clientes', 'Categorias']
  - Ventas: 5 filas, 4 columnas
  - Clientes: 5 filas, 4 columnas
  - Categorias: 3 filas, 3 columnas

✓ Extracción desde Excel completada
```

---

### 5. Extracción de Datos desde JSON

#### 5.1 Crear script extraccion_json.py

```python
"""
extraccion_json.py
Extracción de datos desde archivos JSON
"""

import pandas as pd
import json

print("=" * 60)
print("EXTRACCIÓN DE DATOS DESDE JSON")
print("=" * 60)

# Método 1: Leer JSON directamente con Pandas
print("\n📄 MÉTODO 1: pd.read_json()")
df_json = pd.read_json('productos.json')

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_json.shape}")
print(f"  - Columnas: {list(df_json.columns)}")

print("\n📋 Datos:")
print(df_json)

# Método 2: Leer JSON con módulo json y luego convertir a DataFrame
print("\n" + "=" * 60)
print("📄 MÉTODO 2: json.load() + pd.DataFrame()")
print("=" * 60)

with open('productos.json', 'r', encoding='utf-8') as f:
    datos_json = json.load(f)

df_json_manual = pd.DataFrame(datos_json)

print(f"\n📊 Información:")
print(f"  - Tipo de datos original: {type(datos_json)}")
print(f"  - Número de elementos: {len(datos_json)}")

print("\n📋 Primer elemento JSON:")
print(json.dumps(datos_json[0], indent=2, ensure_ascii=False))

print("\n📋 DataFrame resultante:")
print(df_json_manual)

# Análisis de datos
print("\n" + "=" * 60)
print("📈 ANÁLISIS DE DATOS")
print("=" * 60)

print("\n💼 Productos por categoría:")
print(df_json.groupby('categoria')['nombre'].count())

print("\n💰 Precio promedio por categoría:")
print(df_json.groupby('categoria')['precio'].mean())

print("\n📦 Productos disponibles vs no disponibles:")
print(df_json['disponible'].value_counts())

print("\n✓ Extracción desde JSON completada")
```

#### 5.2 Ejecutar el script

```bash
python extraccion_json.py
```

**Resultado esperado:**
```
============================================================
EXTRACCIÓN DE DATOS DESDE JSON
============================================================

📄 MÉTODO 1: pd.read_json()

📊 Información:
  - Dimensiones: (5, 6)
  - Columnas: ['id_producto', 'nombre', 'categoria', 'precio', 'stock', 'disponible']

📋 Datos:
   id_producto              nombre     categoria  precio  stock  disponible
0          101          Laptop Dell   Electrónica  1200.0     15        True
1          102      Mouse Logitech    Accesorios    25.5     50        True
2          103   Teclado Mecánico    Accesorios    80.0     30        True
3          104        Monitor 24"   Electrónica   300.0     12        True
4          105      Audífonos Sony         Audio   150.0     25       False

============================================================
📄 MÉTODO 2: json.load() + pd.DataFrame()
============================================================

📊 Información:
  - Tipo de datos original: <class 'list'>
  - Número de elementos: 5

📋 Primer elemento JSON:
{
  "id_producto": 101,
  "nombre": "Laptop Dell",
  "categoria": "Electrónica",
  "precio": 1200.0,
  "stock": 15,
  "disponible": true
}

📋 DataFrame resultante:
   id_producto              nombre     categoria  precio  stock  disponible
0          101          Laptop Dell   Electrónica  1200.0     15        True
1          102      Mouse Logitech    Accesorios    25.5     50        True
2          103   Teclado Mecánico    Accesorios    80.0     30        True
3          104        Monitor 24"   Electrónica   300.0     12        True
4          105      Audífonos Sony         Audio   150.0     25       False

============================================================
📈 ANÁLISIS DE DATOS
============================================================

💼 Productos por categoría:
categoria
Accesorios     2
Audio          1
Electrónica    2
Name: nombre, dtype: int64

💰 Precio promedio por categoría:
categoria
Accesorios      52.75
Audio          150.00
Electrónica    750.00
Name: precio, dtype: float64

📦 Productos disponibles vs no disponibles:
disponible
True     4
False    1
Name: count, dtype: int64

✓ Extracción desde JSON completada
```

---

### 6. Extracción de Datos desde SQLite

#### 6.1 Crear script extraccion_sqlite.py

```python
"""
extraccion_sqlite.py
Extracción de datos desde base de datos SQLite
"""

import pandas as pd
import sqlite3

print("=" * 60)
print("EXTRACCIÓN DE DATOS DESDE SQLITE")
print("=" * 60)

# Conectar a la base de datos
conn = sqlite3.connect('ventas.db')

# Ver tablas disponibles
print("\n📋 Tablas disponibles en la base de datos:")
cursor = conn.cursor()
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tablas = cursor.fetchall()
for tabla in tablas:
    print(f"  - {tabla[0]}")

# Extracción 1: Tabla pedidos
print("\n" + "=" * 60)
print("TABLA: PEDIDOS")
print("=" * 60)

df_pedidos = pd.read_sql('SELECT * FROM pedidos', conn)

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_pedidos.shape}")
print(f"  - Columnas: {list(df_pedidos.columns)}")

print("\n📋 Datos:")
print(df_pedidos)

# Extracción 2: Tabla detalle_pedidos
print("\n" + "=" * 60)
print("TABLA: DETALLE_PEDIDOS")
print("=" * 60)

df_detalle = pd.read_sql('SELECT * FROM detalle_pedidos', conn)

print(f"\n📊 Información:")
print(f"  - Dimensiones: {df_detalle.shape}")
print(f"  - Columnas: {list(df_detalle.columns)}")

print("\n📋 Datos:")
print(df_detalle)

# Consulta SQL avanzada
print("\n" + "=" * 60)
print("CONSULTA SQL AVANZADA")
print("=" * 60)

query = """
SELECT 
    p.id_pedido,
    p.id_cliente,
    p.fecha,
    COUNT(dp.id_detalle) as num_productos,
    SUM(dp.cantidad) as total_unidades,
    p.total as monto_total,
    p.estado
FROM pedidos p
LEFT JOIN detalle_pedidos dp ON p.id_pedido = dp.id_pedido
GROUP BY p.id_pedido
ORDER BY p.fecha DESC
"""

df_resumen = pd.read_sql(query, conn)

print("\n📊 Resumen de pedidos:")
print(df_resumen)

# Análisis adicional
print("\n" + "=" * 60)
print("📈 ANÁLISIS DE DATOS")
print("=" * 60)

print("\n💰 Total de ventas:")
print(f"  ${df_pedidos['total'].sum():,.2f}")

print("\n📊 Ventas por estado:")
print(df_pedidos.groupby('estado')['total'].sum())

print("\n📅 Pedidos por fecha:")
print(df_pedidos.groupby('fecha').size())

# Cerrar conexión
conn.close()

print("\n✓ Extracción desde SQLite completada")
print("✓ Conexión a la base de datos cerrada")
```

#### 6.2 Ejecutar el script

```bash
python extraccion_sqlite.py
```

**Resultado esperado:**
```
============================================================
EXTRACCIÓN DE DATOS DESDE SQLITE
============================================================

📋 Tablas disponibles en la base de datos:
  - pedidos
  - detalle_pedidos

============================================================
TABLA: PEDIDOS
============================================================

📊 Información:
  - Dimensiones: (5, 5)
  - Columnas: ['id_pedido', 'id_cliente', 'fecha', 'total', 'estado']

📋 Datos:
   id_pedido  id_cliente       fecha   total       estado
0          1           1  2024-01-15  1225.0   Entregado
1          2           2  2024-01-16    51.0   Entregado
2          3           1  2024-01-17   380.0  En proceso
3          4           3  2024-01-18   150.0   Entregado
4          5           2  2024-01-19  1200.0    Pendiente

============================================================
TABLA: DETALLE_PEDIDOS
============================================================

📊 Información:
  - Dimensiones: (7, 5)
  - Columnas: ['id_detalle', 'id_pedido', 'id_producto', 'cantidad', 'precio_unitario']

📋 Datos:
   id_detalle  id_pedido  id_producto  cantidad  precio_unitario
0           1          1          101         1           1200.0
1           2          1          102         1             25.0
2           3          2          102         2             25.5
3           4          3          103         1             80.0
4           5          3          104         1            300.0
5           6          4          105         1            150.0
6           7          5          101         1           1200.0

============================================================
CONSULTA SQL AVANZADA
============================================================

📊 Resumen de pedidos:
   id_pedido  id_cliente       fecha  num_productos  total_unidades  monto_total       estado
0          5           2  2024-01-19              1               1       1200.0    Pendiente
1          4           3  2024-01-18              1               1        150.0   Entregado
2          3           1  2024-01-17              2               2        380.0  En proceso
3          2           2  2024-01-16              1               2         51.0   Entregado
4          1           1  2024-01-15              2               2       1225.0   Entregado

============================================================
📈 ANÁLISIS DE DATOS
============================================================

💰 Total de ventas:
  $3,006.00

📊 Ventas por estado:
estado
En proceso      380.0
Entregado      1426.0
Pendiente      1200.0
Name: total, dtype: float64

📅 Pedidos por fecha:
fecha
2024-01-15    1
2024-01-16    1
2024-01-17    1
2024-01-18    1
2024-01-19    1
Name: count, dtype: int64

✓ Extracción desde SQLite completada
✓ Conexión a la base de datos cerrada
```

---

### 7. Extracción de Datos desde API Simulada

#### 7.1 Crear script extraccion_api.py

```python
"""
extraccion_api.py
Extracción de datos desde API (simulada y real)
"""

import pandas as pd
import json
import requests

print("=" * 60)
print("EXTRACCIÓN DE DATOS DESDE API")
print("=" * 60)

# ============================================
# PARTE 1: API SIMULADA (SIN CONEXIÓN)
# ============================================
print("\n" + "=" * 60)
print("PARTE 1: API SIMULADA")
print("=" * 60)

# Simular respuesta de API
api_response_simulada = {
    'status': 'success',
    'message': 'Datos obtenidos correctamente',
    'data': [
        {'id': 201, 'producto': 'Webcam HD', 'stock': 15, 'precio': 45.00},
        {'id': 202, 'producto': 'Micrófono USB', 'stock': 8, 'precio': 35.00},
        {'id': 203, 'producto': 'Luz LED Ring', 'stock': 20, 'precio': 60.00},
        {'id': 204, 'producto': 'Trípode', 'stock': 12, 'precio': 25.00}
    ],
    'timestamp': '2024-11-21T10:30:00Z'
}

print("\n📡 Respuesta de API simulada:")
print(json.dumps(api_response_simulada, indent=2))

# Convertir a DataFrame
df_api_simulada = pd.DataFrame(api_response_simulada['data'])

print(f"\n📊 Información del DataFrame:")
print(f"  - Dimensiones: {df_api_simulada.shape}")
print(f"  - Columnas: {list(df_api_simulada.columns)}")

print("\n📋 Datos extraídos:")
print(df_api_simulada)

# ============================================
# PARTE 2: API PÚBLICA REAL (CON CONEXIÓN)
# ============================================
print("\n" + "=" * 60)
print("PARTE 2: API PÚBLICA REAL")
print("=" * 60)

try:
    # API pública de ejemplo: JSONPlaceholder
    print("\n🌐 Conectando a API pública (jsonplaceholder.typicode.com)...")
    
    url = "https://jsonplaceholder.typicode.com/users"
    response = requests.get(url, timeout=10)
    
    print(f"  - Código de respuesta: {response.status_code}")
    print(f"  - Tiempo de respuesta: {response.elapsed.total_seconds():.2f} segundos")
    
    if response.status_code == 200:
        print("  ✓ Conexión exitosa")
        
        # Convertir JSON a DataFrame
        df_api_real = pd.DataFrame(response.json())
        
        print(f"\n📊 Información del DataFrame:")
        print(f"  - Dimensiones: {df_api_real.shape}")
        print(f"  - Columnas: {list(df_api_real.columns)}")
        
        print("\n📋 Primeras 5 filas:")
        print(df_api_real[['id', 'name', 'username', 'email']].head())
        
    else:
        print(f"  ✗ Error: {response.status_code}")

except requests.exceptions.RequestException as e:
    print(f"\n⚠️  No se pudo conectar a la API: {e}")
    print("  (Esto es normal si no hay conexión a internet)")

# ============================================
# PARTE 3: API CON PARÁMETROS
# ============================================
print("\n" + "=" * 60)
print("PARTE 3: API CON PARÁMETROS")
print("=" * 60)

try:
    print("\n🌐 Conectando a API con parámetros...")
    
    url = "https://jsonplaceholder.typicode.com/posts"
    params = {'userId': 1}  # Filtrar por usuario 1
    
    response = requests.get(url, params=params, timeout=10)
    
    if response.status_code == 200:
        print("  ✓ Conexión exitosa")
        
        df_posts = pd.DataFrame(response.json())
        
        print(f"\n📊 Posts del usuario 1:")
        print(f"  - Total de posts: {len(df_posts)}")
        print(f"  - Columnas: {list(df_posts.columns)}")
        
        print("\n📋 Primeros 3 títulos:")
        for idx, titulo in enumerate(df_posts['title'].head(3), 1):
            print(f"  {idx}. {titulo}")
        
    else:
        print(f"  ✗ Error: {response.status_code}")

except requests.exceptions.RequestException as e:
    print(f"\n⚠️  No se pudo conectar a la API: {e}")

print("\n" + "=" * 60)
print("✓ Extracción desde API completada")
print("=" * 60)
```

#### 7.2 Ejecutar el script

```bash
python extraccion_api.py
```

**Resultado esperado:**
```
============================================================
EXTRACCIÓN DE DATOS DESDE API
============================================================

============================================================
PARTE 1: API SIMULADA
============================================================

📡 Respuesta de API simulada:
{
  "status": "success",
  "message": "Datos obtenidos correctamente",
  "data": [
    {
      "id": 201,
      "producto": "Webcam HD",
      "stock": 15,
      "precio": 45.0
    },
    {
      "id": 202,
      "producto": "Micrófono USB",
      "stock": 8,
      "precio": 35.0
    },
    {
      "id": 203,
      "producto": "Luz LED Ring",
      "stock": 20,
      "precio": 60.0
    },
    {
      "id": 204,
      "producto": "Trípode",
      "stock": 12,
      "precio": 25.0
    }
  ],
  "timestamp": "2024-11-21T10:30:00Z"
}

📊 Información del DataFrame:
  - Dimensiones: (4, 4)
  - Columnas: ['id', 'producto', 'stock', 'precio']

📋 Datos extraídos:
    id        producto  stock  precio
0  201      Webcam HD     15    45.0
1  202  Micrófono USB      8    35.0
2  203  Luz LED Ring     20    60.0
3  204       Trípode     12    25.0

============================================================
PARTE 2: API PÚBLICA REAL
============================================================

🌐 Conectando a API pública (jsonplaceholder.typicode.com)...
  - Código de respuesta: 200
  - Tiempo de respuesta: 0.15 segundos
  ✓ Conexión exitosa

📊 Información del DataFrame:
  - Dimensiones: (10, 8)
  - Columnas: ['id', 'name', 'username', 'email', 'address', 'phone', 'website', 'company']

📋 Primeras 5 filas:
   id                name    username                    email
0   1      Leanne Graham      Bret       Sincere@april.biz
1   2     Ervin Howell   Antonette    Shanna@melissa.tv
2   3   Clementine Bauch   Samantha  Nathan@yesenia.net
3   4  Patricia Lebsack  Karianne  Julianne.OConner@kory.org
4   5  Chelsey Dietrich  Kamren  Lucio_Hettinger@annie.ca

============================================================
PARTE 3: API CON PARÁMETROS
============================================================

🌐 Conectando a API con parámetros...
  ✓ Conexión exitosa

📊 Posts del usuario 1:
  - Total de posts: 10
  - Columnas: ['userId', 'id', 'title', 'body']

📋 Primeros 3 títulos:
  1. sunt aut facere repellat provident occaecati excepturi optio reprehenderit
  2. qui est esse
  3. ea molestias quasi exercitationem repellat qui ipsa sit aut

============================================================
✓ Extracción desde API completada
============================================================
```

---

### 8. Script Consolidado de Extracción

#### 8.1 Crear script extraccion_completa.py

```python
"""
extraccion_completa.py
Script consolidado que extrae datos de todas las fuentes
"""

import pandas as pd
import sqlite3
import json

print("=" * 70)
print(" " * 15 + "EXTRACCIÓN DESDE MÚLTIPLES FUENTES")
print("=" * 70)

# Diccionario para almacenar todos los DataFrames
dataframes = {}

# ============================================
# 1. DESDE CSV
# ============================================
print("\n[1/5] Extrayendo desde CSV...")
try:
    df_csv = pd.read_csv('ventas.csv')
    dataframes['CSV'] = df_csv
    print(f"  ✓ CSV: {df_csv.shape[0]} filas, {df_csv.shape[1]} columnas")
except Exception as e:
    print(f"  ✗ Error: {e}")

# ============================================
# 2. DESDE EXCEL
# ============================================
print("\n[2/5] Extrayendo desde Excel...")
try:
    df_excel_ventas = pd.read_excel('datos.xlsx', sheet_name='Ventas')
    df_excel_clientes = pd.read_excel('datos.xlsx', sheet_name='Clientes')
    df_excel_categorias = pd.read_excel('datos.xlsx', sheet_name='Categorias')
    
    dataframes['Excel_Ventas'] = df_excel_ventas
    dataframes['Excel_Clientes'] = df_excel_clientes
    dataframes['Excel_Categorias'] = df_excel_categorias
    
    print(f"  ✓ Excel - Ventas: {df_excel_ventas.shape[0]} filas")
    print(f"  ✓ Excel - Clientes: {df_excel_clientes.shape[0]} filas")
    print(f"  ✓ Excel - Categorias: {df_excel_categorias.shape[0]} filas")
except Exception as e:
    print(f"  ✗ Error: {e}")

# ============================================
# 3. DESDE JSON
# ============================================
print("\n[3/5] Extrayendo desde JSON...")
try:
    df_json = pd.read_json('productos.json')
    dataframes['JSON'] = df_json
    print(f"  ✓ JSON: {df_json.shape[0]} filas, {df_json.shape[1]} columnas")
except Exception as e:
    print(f"  ✗ Error: {e}")

# ============================================
# 4. DESDE SQLITE
# ============================================
print("\n[4/5] Extrayendo desde SQLite...")
try:
    conn = sqlite3.connect('ventas.db')
    
    df_pedidos = pd.read_sql('SELECT * FROM pedidos', conn)
    df_detalle = pd.read_sql('SELECT * FROM detalle_pedidos', conn)
    
    dataframes['SQLite_Pedidos'] = df_pedidos
    dataframes['SQLite_Detalle'] = df_detalle
    
    print(f"  ✓ SQLite - Pedidos: {df_pedidos.shape[0]} filas")
    print(f"  ✓ SQLite - Detalle: {df_detalle.shape[0]} filas")
    
    conn.close()
except Exception as e:
    print(f"  ✗ Error: {e}")

# ============================================
# 5. DESDE API (SIMULADA)
# ============================================
print("\n[5/5] Extrayendo desde API simulada...")
try:
    api_response = {
        'data': [
            {'id': 201, 'producto': 'Webcam HD', 'stock': 15},
            {'id': 202, 'producto': 'Micrófono USB', 'stock': 8}
        ]
    }
    df_api = pd.DataFrame(api_response['data'])
    dataframes['API'] = df_api
    print(f"  ✓ API: {df_api.shape[0]} filas, {df_api.shape[1]} columnas")
except Exception as e:
    print(f"  ✗ Error: {e}")

# ============================================
# RESUMEN
# ============================================
print("\n" + "=" * 70)
print(" " * 25 + "RESUMEN DE EXTRACCIÓN")
print("=" * 70)

print(f"\n📊 Total de DataFrames extraídos: {len(dataframes)}")
print("\n📋 Detalle por fuente:")

for nombre, df in dataframes.items():
    print(f"  • {nombre:20} → {df.shape[0]:3} filas × {df.shape[1]:2} columnas")

# Calcular totales
total_filas = sum(df.shape[0] for df in dataframes.values())
print(f"\n📈 Total de registros extraídos: {total_filas}")

print("\n" + "=" * 70)
print("✓ EXTRACCIÓN COMPLETADA EXITOSAMENTE")
print("=" * 70)
```

#### 8.2 Ejecutar el script consolidado

```bash
python extraccion_completa.py
```

**Resultado esperado:**
```
======================================================================
               EXTRACCIÓN DESDE MÚLTIPLES FUENTES
======================================================================

[1/5] Extrayendo desde CSV...
  ✓ CSV: 5 filas, 4 columnas

[2/5] Extrayendo desde Excel...
  ✓ Excel - Ventas: 5 filas
  ✓ Excel - Clientes: 5 filas
  ✓ Excel - Categorias: 3 filas

[3/5] Extrayendo desde JSON...
  ✓ JSON: 5 filas, 6 columnas

[4/5] Extrayendo desde SQLite...
  ✓ SQLite - Pedidos: 5 filas
  ✓ SQLite - Detalle: 7 filas

[5/5] Extrayendo desde API simulada...
  ✓ API: 2 filas, 3 columnas

======================================================================
                         RESUMEN DE EXTRACCIÓN
======================================================================

📊 Total de DataFrames extraídos: 8

📋 Detalle por fuente:
  • CSV                  →   5 filas ×  4 columnas
  • Excel_Ventas         →   5 filas ×  4 columnas
  • Excel_Clientes       →   5 filas ×  4 columnas
  • Excel_Categorias     →   3 filas ×  3 columnas
  • JSON                 →   5 filas ×  6 columnas
  • SQLite_Pedidos       →   5 filas ×  5 columnas
  • SQLite_Detalle       →   7 filas ×  5 columnas
  • API                  →   2 filas ×  3 columnas

📈 Total de registros extraídos: 37

======================================================================
✓ EXTRACCIÓN COMPLETADA EXITOSAMENTE
======================================================================
```

---

## ✅ Verificación Final

### Checklist de completitud:

- [x] Entorno virtual creado y activado
- [x] Bibliotecas instaladas (pandas, openpyxl, requests)
- [x] Archivos de datos generados (CSV, Excel, JSON, SQLite)
- [x] Extracción desde CSV ejecutada y verificada
- [x] Extracción desde Excel (múltiples hojas) ejecutada
- [x] Extracción desde JSON ejecutada
- [x] Extracción desde SQLite ejecutada
- [x] Extracción desde API simulada ejecutada
- [x] Script consolidado ejecutado exitosamente
- [x] Todos los DataFrames creados correctamente

---

## 📊 Resumen de Formatos y Métodos

| Formato | Método Pandas | Uso Común | Ventajas | Desventajas |
|---------|---------------|-----------|----------|-------------|
| **CSV** | `read_csv()` | Datos tabulares simples | Ligero, universal | Sin tipos de datos |
| **Excel** | `read_excel()` | Reportes, múltiples tablas | Múltiples hojas, formato | Pesado, propietario |
| **JSON** | `read_json()` | APIs, configuración | Estructurado, flexible | Puede ser anidado |
| **SQLite** | `read_sql()` | Bases de datos locales | Relacional, eficiente | Requiere SQL |
| **API** | `DataFrame(response.json())` | Datos en tiempo real | Actualizado, remoto | Requiere conexión |

---

## 🎯 Conceptos Clave Aprendidos

### 1. Extracción desde CSV

**Características:**
- Formato de texto plano
- Valores separados por comas
- Universal y ligero

**Método básico:**
```python
df = pd.read_csv('archivo.csv')
```

**Parámetros útiles:**
```python
df = pd.read_csv('archivo.csv',
                 sep=';',              # Separador personalizado
                 encoding='utf-8',     # Codificación
                 na_values=['NA', ''], # Valores nulos
                 skiprows=1)           # Saltar filas
```

---

### 2. Extracción desde Excel

**Características:**
- Puede contener múltiples hojas
- Soporta formatos y fórmulas
- Requiere biblioteca adicional (openpyxl)

**Métodos:**
```python
# Una hoja específica
df = pd.read_excel('archivo.xlsx', sheet_name='Hoja1')

# Todas las hojas
dfs = pd.read_excel('archivo.xlsx', sheet_name=None)

# Múltiples hojas específicas
dfs = pd.read_excel('archivo.xlsx', sheet_name=['Hoja1', 'Hoja2'])
```

---

### 3. Extracción desde JSON

**Características:**
- Formato de intercambio de datos
- Estructura jerárquica
- Común en APIs

**Métodos:**
```python
# Directo con Pandas
df = pd.read_json('archivo.json')

# Con módulo json
import json
with open('archivo.json') as f:
    data = json.load(f)
df = pd.DataFrame(data)
```

---

### 4. Extracción desde SQLite

**Características:**
- Base de datos relacional ligera
- No requiere servidor
- Soporta SQL completo

**Métodos:**
```python
import sqlite3

# Conectar y extraer
conn = sqlite3.connect('base.db')
df = pd.read_sql('SELECT * FROM tabla', conn)
conn.close()

# Con query parametrizada
query = "SELECT * FROM tabla WHERE columna = ?"
df = pd.read_sql(query, conn, params=('valor',))
```

---

### 5. Extracción desde APIs

**Características:**
- Datos en tiempo real
- Requiere conexión a internet
- Usa protocolo HTTP

**Método básico:**
```python
import requests

response = requests.get('https://api.ejemplo.com/data')
if response.status_code == 200:
    df = pd.DataFrame(response.json())
```

**Con parámetros:**
```python
params = {'clave': 'valor'}
response = requests.get(url, params=params)
```

---

## 💡 Mejores Prácticas

### 1. Siempre manejar excepciones

```python
# ✅ BIEN: Con manejo de errores
try:
    df = pd.read_csv('archivo.csv')
except FileNotFoundError:
    print("Archivo no encontrado")
except Exception as e:
    print(f"Error: {e}")

# ❌ MAL: Sin manejo de errores
df = pd.read_csv('archivo.csv')  # Puede fallar sin control
```

### 2. Verificar datos después de cargar

```python
# ✅ BIEN: Verificar estructura
df = pd.read_csv('datos.csv')
print(f"Dimensiones: {df.shape}")
print(f"Columnas: {list(df.columns)}")
print(df.head())
print(df.info())

# ❌ MAL: Asumir que todo está bien
df = pd.read_csv('datos.csv')
# Usar directamente sin verificar
```

### 3. Cerrar conexiones a bases de datos

```python
# ✅ BIEN: Cerrar conexión
conn = sqlite3.connect('base.db')
df = pd.read_sql('SELECT * FROM tabla', conn)
conn.close()

# ✅ MEJOR: Usar context manager
with sqlite3.connect('base.db') as conn:
    df = pd.read_sql('SELECT * FROM tabla', conn)
# Se cierra automáticamente
```

### 4. Especificar codificación

```python
# ✅ BIEN: Especificar encoding
df = pd.read_csv('datos.csv', encoding='utf-8')

# ⚠️ PUEDE FALLAR: Sin encoding
df = pd.read_csv('datos.csv')  # Problemas con caracteres especiales
```

---

## 🔧 Solución de Problemas Comunes

### Problema 1: Error al leer Excel

**Error:**
```
ImportError: Missing optional dependency 'openpyxl'
```

**Solución:**
```bash
pip install openpyxl
```

---

### Problema 2: Encoding en CSV

**Error:**
```
UnicodeDecodeError: 'utf-8' codec can't decode byte
```

**Solución:**
```python
# Probar diferentes encodings
df = pd.read_csv('archivo.csv', encoding='latin-1')
# o
df = pd.read_csv('archivo.csv', encoding='ISO-8859-1')
```

---

### Problema 3: JSON anidado

**Error:**
Estructura JSON compleja no se convierte bien a DataFrame

**Solución:**
```python
import json
import pandas as pd
from pandas import json_normalize

with open('data.json') as f:
    data = json.load(f)

# Normalizar JSON anidado
df = json_normalize(data)
```

---

### Problema 4: Timeout en API

**Error:**
```
requests.exceptions.Timeout
```

**Solución:**
```python
# Aumentar timeout
response = requests.get(url, timeout=30)

# Reintentos
from requests.adapters import HTTPAdapter
from requests.packages.urllib3.util.retry import Retry

session = requests.Session()
retry = Retry(total=3, backoff_factor=0.3)
adapter = HTTPAdapter(max_retries=retry)
session.mount('http://', adapter)
session.mount('https://', adapter)
```

---

## 🚀 Próximos Pasos

### Conceptos a explorar:

1. **Transformación de datos**
   - Limpieza de datos
   - Manejo de valores nulos
   - Cambio de tipos de datos

2. **Combinación de DataFrames**
   - Merge y Join
   - Concatenación
   - Append

3. **Exportación de datos**
   - Guardar en diferentes formatos
   - Optimización de almacenamiento

4. **Web Scraping**
   - BeautifulSoup
   - Selenium
   - Scrapy

5. **Bases de datos avanzadas**
   - PostgreSQL
   - MySQL
   - MongoDB

---

## 📖 Recursos Adicionales

- [Pandas I/O Tools](https://pandas.pydata.org/docs/user_guide/io.html)
- [Requests Documentation](https://requests.readthedocs.io/)
- [SQLite with Python](https://docs.python.org/3/library/sqlite3.html)
- [Working with JSON in Python](https://realpython.com/python-json/)
- [Excel Files in Pandas](https://pandas.pydata.org/docs/reference/api/pandas.read_excel.html)

---

## 📝 Comandos Útiles - Referencia Rápida

```python
# CSV
pd.read_csv('archivo.csv')

# Excel
pd.read_excel('archivo.xlsx', sheet_name='Hoja1')

# JSON
pd.read_json('archivo.json')

# SQLite
pd.read_sql('SELECT * FROM tabla', conn)

# API
response = requests.get(url)
pd.DataFrame(response.json())

# Verificar DataFrame
df.shape
df.info()
df.head()
df.describe()
```

---

## 📅 Notas del Ejercicio

- **Fecha de realización**: Noviembre 2025
- **Entorno**: Windows 11, VS Code, Python 3.x
- **Entorno virtual**: venv_extraccion
- **Bibliotecas utilizadas**: pandas, openpyxl, requests, sqlite3
- **Archivos generados**: ventas.csv, datos.xlsx, productos.json, ventas.db
- **Scripts creados**: 7 scripts de extracción

---

## ✨ Conclusiones

Este ejercicio estableció las bases para la extracción de datos desde múltiples fuentes heterogéneas:

### Logros alcanzados:

1. **Formatos dominados**: CSV, Excel, JSON, SQLite, APIs
2. **Métodos de Pandas**: read_csv(), read_excel(), read_json(), read_sql()
3. **Datos generados**: Archivos de ejemplo en 4 formatos diferentes
4. **Scripts funcionales**: 7 scripts de extracción documentados
5. **Manejo de errores**: Try-except para robustez

### Habilidades adquiridas:

- Extraer datos de archivos planos (CSV)
- Trabajar con archivos Excel de múltiples hojas
- Procesar datos JSON estructurados
- Consultar bases de datos SQLite con SQL
- Consumir APIs REST
- Consolidar datos de múltiples fuentes

La extracción de datos es el primer paso crítico en cualquier proyecto de análisis. Dominar estas técnicas permite trabajar con datos del mundo real, independientemente de su formato o ubicación. Con estas habilidades, ahora es posible obtener datos de prácticamente cualquier fuente y consolidarlos en DataFrames de Pandas para su posterior análisis, transformación y visualización.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 3](../README.md) | [Día Siguiente →](../Dia_3_Limpieza_Transformacion/README.md)
