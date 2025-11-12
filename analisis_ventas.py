"""
Módulo de análisis y visualización de ventas
Proporciona herramientas para análisis estadístico y gráficos profesionales.
"""

import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import sys
# from io import StringIO  # Esta importación se mantiene comentada ya que no es necesaria para el código actual

# --- 1. Configuración ---

# Configuración de colores corporativos
COLORES_CORPORATIVOS = {
    'primario': '#2C3E50',      # Azul oscuro
    'secundario': '#3498DB',    # Azul brillante
    'acento': '#E74C3C',        # Rojo
    'fondo': '#ECF0F1',         # Gris claro
    'exito': '#27AE60',         # Verde
    'advertencia': '#F39C12'    # Naranja
}


def configurar_estilo_grafico():
    """
    Configura el estilo visual por defecto para todos los gráficos.

    Aplica:
    - Estilo seaborn para apariencia profesional
    - Tamaño de figura optimizado
    - Configuración de fuentes

    Returns:
        bool: True si la configuración fue exitosa
    """
    plt.style.use('seaborn-v0_8')
    plt.rcParams['figure.figsize'] = (12, 6)
    plt.rcParams['font.size'] = 10
    plt.rcParams['axes.labelsize'] = 11
    plt.rcParams['axes.titlesize'] = 14
    return True


def crear_dashboard_basico():
    """
    Inicializa la estructura básica del dashboard de ventas.

    Returns:
        None
    """
    print("=" * 50)
    print("    DASHBOARD DE VENTAS - SISTEMA INICIALIZADO")
    print("=" * 50)
    return None


# --- 2. Funciones de Validación y Cálculo ---

def validar_datos_entrada(datos):
    """
    Valida que los datos sean adecuados para análisis estadístico.

    Realiza múltiples verificaciones:
    - Verifica que no sea None
    - Verifica que no esté vacío (para pandas Series/DataFrame)
    - Verifica que tenga longitud mayor a cero

    Args:
        datos: Datos a validar (pd.Series, pd.DataFrame, list, array)

    Raises:
        ValueError: Si los datos son None, vacíos, o tienen longitud cero
        TypeError: Si el tipo de datos no es compatible con análisis

    Returns:
        bool: True si los datos son válidos y listos para análisis
    """
    # Verificar None
    if datos is None:
        raise ValueError("Los datos no pueden ser None")

    # Verificar si es un objeto pandas vacío
    if hasattr(datos, 'empty') and datos.empty:
        raise ValueError("Los datos no pueden estar vacíos (pandas DataFrame/Series)")

    # Verificar longitud para otros tipos (list, array, etc.)
    if hasattr(datos, '__len__') and len(datos) == 0:
        raise ValueError("Los datos deben tener al menos un elemento")

    # Verificar que sea un tipo compatible
    tipos_validos = (pd.Series, pd.DataFrame, list, tuple, np.ndarray)
    if not isinstance(datos, tipos_validos):
        raise TypeError(
            f"Tipo de datos no compatible: {type(datos)}. "
            f"Se esperaba: pandas Series/DataFrame, list, tuple o numpy array"
        )

    return True


def calcular_metricas_clave(datos):
    """
    Calcula métricas estadísticas clave de los datos de ventas.

    Args:
        datos (pd.Series): Serie con datos numéricos de ventas.

    Returns:
        dict: Diccionario con métricas calculadas.

    Raises:
        ValueError: Si los datos son inválidos, levantada por validar_datos_entrada.
    """
    # Validar datos antes de procesar
    validar_datos_entrada(datos)

    metricas = {
        'total': datos.sum(),
        'promedio': datos.mean(),
        'mediana': datos.median(),
        'maximo': datos.max(),
        'minimo': datos.min(),
        'desviacion': datos.std(),
        'variacion': (datos.std() / datos.mean() * 100) if datos.mean() != 0 else 0
    }
    return metricas


# --- 3. Funciones de Reporte y Visualización ---

def generar_reporte_texto(metricas):
    """
    Genera un reporte en formato texto de las métricas calculadas.

    Args:
        metricas (dict): Diccionario con métricas (output de calcular_metricas_clave)

    Returns:
        str: Reporte formateado y listo para imprimir.
    """
    linea = "=" * 50
    reporte = f"""
{linea}
           REPORTE DE ANÁLISIS DE VENTAS
{linea}

📈 MÉTRICAS PRINCIPALES:
   • Total de Ventas:        ${metricas['total']:>15,.2f}
   • Promedio:               ${metricas['promedio']:>15,.2f}
   • Mediana:                ${metricas['mediana']:>15,.2f}

📊 ESTADÍSTICAS:
   • Venta Máxima:           ${metricas['maximo']:>15,.2f}
   • Venta Mínima:           ${metricas['minimo']:>15,.2f}
   • Desviación Estándar:    ${metricas['desviacion']:>15,.2f}
   • Coef. Variación:        {metricas['variacion']:>15.2f}%

{linea}
"""
    return reporte


def generar_grafico_ventas_mensuales(datos):
    """
    Genera gráfico de líneas para visualizar ventas mensuales.
    """
    validar_datos_entrada(datos)
    configurar_estilo_grafico()

    fig, ax = plt.subplots()
    ax.plot(
        datos.index,
        datos.values,
        color=COLORES_CORPORATIVOS['secundario'],
        linewidth=2.5,
        marker='o',
        markersize=8,
        markerfacecolor=COLORES_CORPORATIVOS['acento'],
        markeredgewidth=2,
        markeredgecolor=COLORES_CORPORATIVOS['primario']
    )

    ax.set_title(
        'Ventas Mensuales - Análisis Temporal',
        fontsize=14,
        fontweight='bold',
        color=COLORES_CORPORATIVOS['primario']
    )
    ax.set_xlabel('Mes', fontweight='bold')
    ax.set_ylabel('Ventas ($)', fontweight='bold')
    ax.grid(True, alpha=0.3, linestyle='--')
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)

    return fig


# --- 4. Ejecución del Módulo ---

if __name__ == "__main__":
    configurar_estilo_grafico()
    crear_dashboard_basico()

    # 1. Datos de ejemplo para el análisis
    datos_ventas = pd.Series(
        [12500, 15000, 13800, 16500, 14200, 18000, 15500, 17200],
        index=['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago']
    )

    print("\n--- INICIANDO ANÁLISIS ---\n")

    # 2. Calcular y mostrar métricas
    try:
        metricas_calculadas = calcular_metricas_clave(datos_ventas)
        reporte = generar_reporte_texto(metricas_calculadas)
        print(reporte)

        # 3. Generar y mostrar gráfico
        fig = generar_grafico_ventas_mensuales(datos_ventas)
        print("Gráfico generado. Puedes descomentar 'plt.show()' para visualizarlo si estás en un entorno gráfico.")
        # plt.show()

    except ValueError as e:
        print(f"Error de Validación: {e}", file=sys.stderr)
    except TypeError as e:
        print(f"Error de Tipo de Datos: {e}", file=sys.stderr)
    except Exception as e:
        print(f"Ocurrió un error inesperado: {e}", file=sys.stderr)
    finally:
        plt.close('all')
        print("\n--- ANÁLISIS FINALIZADO ---")
