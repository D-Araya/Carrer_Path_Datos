# test_analisis.py
# Script de prueba para verificar instalación de bibliotecas

import numpy as np
import pandas as pd
import matplotlib
import matplotlib.pyplot as plt

print("=" * 50)
print("VERIFICACIÓN DE BIBLIOTECAS INSTALADAS")
print("=" * 50)

# Verificar versiones
print(f"\nNumPy versión: {np.__version__}")
print(f"Pandas versión: {pd.__version__}")
print(f"Matplotlib versión: {matplotlib.__version__}")

print("\n" + "=" * 50)
print("GENERACIÓN DE DATOS DE EJEMPLO")
print("=" * 50)

# Crear datos de ejemplo con NumPy
np.random.seed(42)  # Para reproducibilidad
datos = {
    'x': np.random.randn(100),
    'y': np.random.randn(100)
}

# Crear DataFrame con Pandas
df = pd.DataFrame(datos)

print(f"\nDataFrame creado con {len(df)} filas")
print(f"Columnas: {list(df.columns)}")

print("\n" + "=" * 50)
print("ESTADÍSTICAS BÁSICAS")
print("=" * 50)
print(df.describe())

print("\n" + "=" * 50)
print("PRIMERAS 5 FILAS DEL DATAFRAME")
print("=" * 50)
print(df.head())

print("\n" + "=" * 50)
print("GENERACIÓN DE GRÁFICO")
print("=" * 50)

# Crear gráfico de dispersión
plt.figure(figsize=(10, 6))
plt.scatter(df['x'], df['y'], alpha=0.5, c='blue', edgecolors='black')
plt.title('Primer Gráfico con Python - Datos Aleatorios', fontsize=14, fontweight='bold')
plt.xlabel('Variable X', fontsize=12)
plt.ylabel('Variable Y', fontsize=12)
plt.grid(True, alpha=0.3)
plt.axhline(y=0, color='r', linestyle='--', linewidth=0.5)
plt.axvline(x=0, color='r', linestyle='--', linewidth=0.5)

# Guardar gráfico
nombre_archivo = 'primer_grafico.png'
plt.savefig(nombre_archivo, dpi=300, bbox_inches='tight')
print(f"\n✓ Gráfico guardado como '{nombre_archivo}'")

# Cerrar figura para liberar memoria
plt.close()

print("\n" + "=" * 50)
print("✓ VERIFICACIÓN COMPLETADA EXITOSAMENTE")
print("=" * 50)
print("\nTodas las bibliotecas funcionan correctamente.")
print("El entorno de análisis de datos está listo para usar.")