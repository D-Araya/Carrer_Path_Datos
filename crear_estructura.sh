#!/bin/bash

# Script para crear estructura completa del Career Path de Datos
# Autor: Generado automáticamente
# Fecha: $(date +%Y-%m-%d)

# Colores para output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Iniciando creación de estructura Career Path Datos${NC}"

# Crear README.md principal
cat > README.md << 'EOF'
# 📁 Career Path - Datos

Bienvenido al programa completo de formación en Datos. Este repositorio contiene un plan estructurado de 3 meses para convertirte en un profesional de datos, cubriendo desde fundamentos hasta proyectos avanzados.

## 📚 Estructura del Programa

### [Mes 1: Fundamentos de Datos y Control de Versiones](./Mes_1_Fundamentos_Datos_Control_Versiones/README.md)
Aprende las bases esenciales: Git/GitHub, SQL, Python para datos y ETL básico.

### [Mes 2: Análisis de Datos y Estadística](./Mes_2_Analisis_Datos_Estadistica/README.md)
Domina el análisis exploratorio, visualización, estadística y bases de datos avanzadas.

### [Mes 3: Herramientas ETL y Proyecto Final](./Mes_3_Herramientas_ETL_Proyecto_Final/README.md)
Implementa pipelines completos con Python, SQL y Apache Airflow, culminando en un proyecto final integral.

---

## 🎯 Objetivos del Programa

- Dominar el control de versiones con Git y GitHub
- Desarrollar habilidades sólidas en SQL y Python para análisis de datos
- Implementar pipelines ETL completos y automatizados
- Realizar análisis exploratorios y crear visualizaciones efectivas
- Aplicar estadística y machine learning básico
- Desplegar soluciones en producción con mejores prácticas

## 📊 Progreso

- [ ] Mes 1: Fundamentos
- [ ] Mes 2: Análisis
- [ ] Mes 3: Proyecto Final

---

**Última actualización:** $(date +%Y-%m-%d)
EOF

echo -e "${GREEN}✓ README.md principal creado${NC}"

# ============================================
# MES 1: Fundamentos de Datos y Control de Versiones
# ============================================

mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones"

cat > "Mes_1_Fundamentos_Datos_Control_Versiones/README.md" << 'EOF'
# Mes 1: Fundamentos de Datos y Control de Versiones

Este mes establece las bases fundamentales para trabajar con datos, incluyendo control de versiones, SQL, Python y ETL.

## 📅 Semanas

### [Semana 1: Introducción y GitHub](./Semana_1_Introduccion_GitHub/README.md)
Domina Git y GitHub para colaboración efectiva en proyectos de datos.

### [Semana 2: Fundamentos de SQL](./Semana_2_Fundamentos_SQL/README.md)
Aprende a consultar y manipular bases de datos relacionales.

### [Semana 3: Manipulación de Datos con Python](./Semana_3_Manipulacion_Datos_Python/README.md)
Utiliza Python y Pandas para extraer, limpiar y transformar datos.

### [Semana 4: ETL Básico](./Semana_4_ETL_Basico/README.md)
Implementa procesos ETL completos desde múltiples fuentes.

---

[Volver al índice principal](../README.md)
EOF

# Semana 1: Introducción y GitHub
mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_1_Introduccion_GitHub"

cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_1_Introduccion_GitHub/README.md" << 'EOF'
# Semana 1: Introducción y GitHub

Control de versiones y colaboración con Git y GitHub.

## 📝 Actividades Diarias

1. [Día 1: ¿Qué es Git y para qué sirve?](./Dia_1_Que_es_Git/README.md)
2. [Día 2: Instalación, Configuración y Comandos Básicos](./Dia_2_Instalacion_Configuracion_Comandos_Basicos/README.md)
3. [Día 3: Repositorios Remotos, GitHub y SSH](./Dia_3_Repositorios_Remotos_GitHub_SSH/README.md)
4. [Día 4: Pull Requests, Ramas, Merge y Resolución de Conflictos](./Dia_4_Pull_Requests_Ramas_Merge/README.md)
5. [Día 5: Flujo GitHub Flow y Buenas Prácticas de Colaboración](./Dia_5_GitHub_Flow_Buenas_Practicas/README.md)

---

[Volver al Mes 1](../README.md) | [Volver al índice principal](../../README.md)
EOF

# Días Semana 1
dias_s1=(
    "Dia_1_Que_es_Git:¿Qué es Git y para qué sirve?:Dia_2_Instalacion_Configuracion_Comandos_Basicos"
    "Dia_2_Instalacion_Configuracion_Comandos_Basicos:Instalación, Configuración y Comandos Básicos:Dia_3_Repositorios_Remotos_GitHub_SSH"
    "Dia_3_Repositorios_Remotos_GitHub_SSH:Repositorios Remotos, GitHub y SSH:Dia_4_Pull_Requests_Ramas_Merge"
    "Dia_4_Pull_Requests_Ramas_Merge:Pull Requests, Ramas, Merge y Resolución de Conflictos:Dia_5_GitHub_Flow_Buenas_Practicas"
    "Dia_5_GitHub_Flow_Buenas_Practicas:Flujo GitHub Flow y Buenas Prácticas de Colaboración:"
)

for dia_info in "${dias_s1[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_1_Introduccion_GitHub/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_1_Introduccion_GitHub/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 1](../README.md)$next_link
EOF
done

# Semana 2: Fundamentos de SQL
mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_2_Fundamentos_SQL"

cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_2_Fundamentos_SQL/README.md" << 'EOF'
# Semana 2: Fundamentos de SQL

Aprende a trabajar con bases de datos relacionales usando SQL.

## 📝 Actividades Diarias

1. [Día 1: Introducción a Bases de Datos Relacionales y SQL](./Dia_1_Introduccion_Bases_Datos_SQL/README.md)
2. [Día 2: Consultas Básicas (SELECT, WHERE, ORDER BY)](./Dia_2_Consultas_Basicas/README.md)
3. [Día 3: Joins y Relaciones entre Tablas](./Dia_3_Joins_Relaciones/README.md)
4. [Día 4: Funciones de Agregación y GROUP BY](./Dia_4_Funciones_Agregacion_GROUP_BY/README.md)
5. [Día 5: Subconsultas y Consultas Avanzadas](./Dia_5_Subconsultas_Avanzadas/README.md)

---

[Volver al Mes 1](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_s2=(
    "Dia_1_Introduccion_Bases_Datos_SQL:Introducción a Bases de Datos Relacionales y SQL:Dia_2_Consultas_Basicas"
    "Dia_2_Consultas_Basicas:Consultas Básicas (SELECT, WHERE, ORDER BY):Dia_3_Joins_Relaciones"
    "Dia_3_Joins_Relaciones:Joins y Relaciones entre Tablas:Dia_4_Funciones_Agregacion_GROUP_BY"
    "Dia_4_Funciones_Agregacion_GROUP_BY:Funciones de Agregación y GROUP BY:Dia_5_Subconsultas_Avanzadas"
    "Dia_5_Subconsultas_Avanzadas:Subconsultas y Consultas Avanzadas:"
)

for dia_info in "${dias_s2[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_2_Fundamentos_SQL/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_2_Fundamentos_SQL/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 2](../README.md)$next_link
EOF
done

# Semana 3: Manipulación de Datos con Python
mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_3_Manipulacion_Datos_Python"

cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_3_Manipulacion_Datos_Python/README.md" << 'EOF'
# Semana 3: Manipulación de Datos con Python

Domina Python y Pandas para análisis y transformación de datos.

## 📝 Actividades Diarias

1. [Día 1: Introducción a Python para Análisis de Datos](./Dia_1_Introduccion_Python_Analisis/README.md)
2. [Día 2: Extracción de Datos desde Múltiples Fuentes](./Dia_2_Extraccion_Datos_Multiples_Fuentes/README.md)
3. [Día 3: Limpieza y Transformación de Datos](./Dia_3_Limpieza_Transformacion/README.md)
4. [Día 4: Filtrado, Agrupación y Merge de Datos](./Dia_4_Filtrado_Agrupacion_Merge/README.md)
5. [Día 5: Manejo de Datos Faltantes y Outliers](./Dia_5_Datos_Faltantes_Outliers/README.md)

---

[Volver al Mes 1](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_s3=(
    "Dia_1_Introduccion_Python_Analisis:Introducción a Python para Análisis de Datos:Dia_2_Extraccion_Datos_Multiples_Fuentes"
    "Dia_2_Extraccion_Datos_Multiples_Fuentes:Extracción de Datos desde Múltiples Fuentes:Dia_3_Limpieza_Transformacion"
    "Dia_3_Limpieza_Transformacion:Limpieza y Transformación de Datos:Dia_4_Filtrado_Agrupacion_Merge"
    "Dia_4_Filtrado_Agrupacion_Merge:Filtrado, Agrupación y Merge de Datos:Dia_5_Datos_Faltantes_Outliers"
    "Dia_5_Datos_Faltantes_Outliers:Manejo de Datos Faltantes y Outliers:"
)

for dia_info in "${dias_s3[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_3_Manipulacion_Datos_Python/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_3_Manipulacion_Datos_Python/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 3](../README.md)$next_link
EOF
done

# Semana 4: ETL Básico
mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_4_ETL_Basico"

cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_4_ETL_Basico/README.md" << 'EOF'
# Semana 4: ETL Básico

Implementa procesos completos de Extracción, Transformación y Carga de datos.

## 📝 Actividades Diarias

1. [Día 1: Conceptos Fundamentales de ETL](./Dia_1_Conceptos_Fundamentales_ETL/README.md)
2. [Día 2: Extracción de Datos desde Múltiples Fuentes](./Dia_2_Extraccion_Multiples_Fuentes/README.md)
3. [Día 3: Transformación y Limpieza de Datos](./Dia_3_Transformacion_Limpieza/README.md)
4. [Día 4: Carga de Datos a Destinos](./Dia_4_Carga_Datos_Destinos/README.md)
5. [Día 5: Manejo de Errores y Logging en ETL](./Dia_5_Manejo_Errores_Logging/README.md)

---

[Volver al Mes 1](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_s4=(
    "Dia_1_Conceptos_Fundamentales_ETL:Conceptos Fundamentales de ETL:Dia_2_Extraccion_Multiples_Fuentes"
    "Dia_2_Extraccion_Multiples_Fuentes:Extracción de Datos desde Múltiples Fuentes:Dia_3_Transformacion_Limpieza"
    "Dia_3_Transformacion_Limpieza:Transformación y Limpieza de Datos:Dia_4_Carga_Datos_Destinos"
    "Dia_4_Carga_Datos_Destinos:Carga de Datos a Destinos:Dia_5_Manejo_Errores_Logging"
    "Dia_5_Manejo_Errores_Logging:Manejo de Errores y Logging en ETL:"
)

for dia_info in "${dias_s4[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_4_ETL_Basico/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_1_Fundamentos_Datos_Control_Versiones/Semana_4_ETL_Basico/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 4](../README.md)$next_link
EOF
done

echo -e "${GREEN}✓ Mes 1 completo${NC}"

# ============================================
# MES 2: Análisis de Datos y Estadística
# ============================================

mkdir -p "Mes_2_Analisis_Datos_Estadistica"

cat > "Mes_2_Analisis_Datos_Estadistica/README.md" << 'EOF'
# Mes 2: Análisis de Datos y Estadística

Desarrolla habilidades avanzadas en análisis exploratorio, visualización, estadística y bases de datos.

## 📅 Semanas

### [Semana 1: Análisis Exploratorio de Datos](./Semana_1_Analisis_Exploratorio/README.md)
Domina técnicas de EDA y estadística descriptiva.

### [Semana 2: Visualización de Datos](./Semana_2_Visualizacion_Datos/README.md)
Crea visualizaciones efectivas y comunica insights con datos.

### [Semana 3: Estadística para Análisis de Datos](./Semana_3_Estadistica_Analisis/README.md)
Aplica pruebas estadísticas y modelos predictivos básicos.

### [Semana 4: Bases de Datos Avanzadas](./Semana_4_Bases_Datos_Avanzadas/README.md)
Optimiza consultas y diseña arquitecturas de bases de datos escalables.

---

[Volver al índice principal](../README.md)
EOF

# Semana 1: Análisis Exploratorio de Datos
mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_1_Analisis_Exploratorio"

cat > "Mes_2_Analisis_Datos_Estadistica/Semana_1_Analisis_Exploratorio/README.md" << 'EOF'
# Semana 1: Análisis Exploratorio de Datos

Técnicas fundamentales para explorar y entender tus datos.

## 📝 Actividades Diarias

1. [Día 1: Introducción al Análisis Exploratorio (EDA)](./Dia_1_Introduccion_EDA/README.md)
2. [Día 2: Estadística Descriptiva Básica](./Dia_2_Estadistica_Descriptiva/README.md)
3. [Día 3: Distribuciones y Análisis Univariado](./Dia_3_Distribuciones_Univariado/README.md)
4. [Día 4: Análisis de Relaciones y Correlaciones](./Dia_4_Relaciones_Correlaciones/README.md)
5. [Día 5: EDA Completo y Reporte Ejecutivo](./Dia_5_EDA_Completo_Reporte/README.md)

---

[Volver al Mes 2](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m2s1=(
    "Dia_1_Introduccion_EDA:Introducción al Análisis Exploratorio (EDA):Dia_2_Estadistica_Descriptiva"
    "Dia_2_Estadistica_Descriptiva:Estadística Descriptiva Básica:Dia_3_Distribuciones_Univariado"
    "Dia_3_Distribuciones_Univariado:Distribuciones y Análisis Univariado:Dia_4_Relaciones_Correlaciones"
    "Dia_4_Relaciones_Correlaciones:Análisis de Relaciones y Correlaciones:Dia_5_EDA_Completo_Reporte"
    "Dia_5_EDA_Completo_Reporte:EDA Completo y Reporte Ejecutivo:"
)

for dia_info in "${dias_m2s1[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_1_Analisis_Exploratorio/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_2_Analisis_Datos_Estadistica/Semana_1_Analisis_Exploratorio/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 2](../../README.md) | [Volver a Semana 1](../README.md)$next_link
EOF
done

# Semana 2: Visualización de Datos
mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_2_Visualizacion_Datos"

cat > "Mes_2_Analisis_Datos_Estadistica/Semana_2_Visualizacion_Datos/README.md" << 'EOF'
# Semana 2: Visualización de Datos

Crea visualizaciones impactantes y comunica insights efectivamente.

## 📝 Actividades Diarias

1. [Día 1: Principios de Visualización Efectiva y Teoría del Color](./Dia_1_Principios_Visualizacion_Color/README.md)
2. [Día 2: Gráficos Básicos con Matplotlib para Análisis Inicial](./Dia_2_Graficos_Matplotlib/README.md)
3. [Día 3: Visualizaciones Avanzadas y Dashboards Interactivos](./Dia_3_Visualizaciones_Avanzadas_Dashboards/README.md)
4. [Día 4: Storytelling con Datos para Comunicar Insights](./Dia_4_Storytelling_Datos/README.md)
5. [Día 5: Herramientas de Visualización Alternativas](./Dia_5_Herramientas_Alternativas/README.md)

---

[Volver al Mes 2](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m2s2=(
    "Dia_1_Principios_Visualizacion_Color:Principios de Visualización Efectiva y Teoría del Color:Dia_2_Graficos_Matplotlib"
    "Dia_2_Graficos_Matplotlib:Gráficos Básicos con Matplotlib para Análisis Inicial:Dia_3_Visualizaciones_Avanzadas_Dashboards"
    "Dia_3_Visualizaciones_Avanzadas_Dashboards:Visualizaciones Avanzadas y Dashboards Interactivos:Dia_4_Storytelling_Datos"
    "Dia_4_Storytelling_Datos:Storytelling con Datos para Comunicar Insights:Dia_5_Herramientas_Alternativas"
    "Dia_5_Herramientas_Alternativas:Herramientas de Visualización Alternativas:"
)

for dia_info in "${dias_m2s2[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_2_Visualizacion_Datos/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_2_Analisis_Datos_Estadistica/Semana_2_Visualizacion_Datos/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 2](../../README.md) | [Volver a Semana 2](../README.md)$next_link
EOF
done

# Semana 3: Estadística para Análisis de Datos
mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_3_Estadistica_Analisis"

cat > "Mes_2_Analisis_Datos_Estadistica/Semana_3_Estadistica_Analisis/README.md" << 'EOF'
# Semana 3: Estadística para Análisis de Datos

Aplica técnicas estadísticas para análisis robusto y modelado predictivo.

## 📝 Actividades Diarias

1. [Día 1: Probabilidad Básica y Distribuciones de Datos](./Dia_1_Probabilidad_Distribuciones/README.md)
2. [Día 2: Pruebas de Hipótesis y su Aplicación Práctica](./Dia_2_Pruebas_Hipotesis/README.md)
3. [Día 3: Análisis de Varianza (ANOVA) para Comparación de Grupos](./Dia_3_ANOVA_Comparacion_Grupos/README.md)
4. [Día 4: Regresión Lineal Simple para Modelado Predictivo](./Dia_4_Regresion_Lineal_Predictivo/README.md)
5. [Día 5: Estadística No Paramétrica y Pruebas Robustas](./Dia_5_Estadistica_No_Parametrica/README.md)

---

[Volver al Mes 2](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m2s3=(
    "Dia_1_Probabilidad_Distribuciones:Probabilidad Básica y Distribuciones de Datos:Dia_2_Pruebas_Hipotesis"
    "Dia_2_Pruebas_Hipotesis:Pruebas de Hipótesis y su Aplicación Práctica:Dia_3_ANOVA_Comparacion_Grupos"
    "Dia_3_ANOVA_Comparacion_Grupos:Análisis de Varianza (ANOVA) para Comparación de Grupos:Dia_4_Regresion_Lineal_Predictivo"
    "Dia_4_Regresion_Lineal_Predictivo:Regresión Lineal Simple para Modelado Predictivo:Dia_5_Estadistica_No_Parametrica"
    "Dia_5_Estadistica_No_Parametrica:Estadística No Paramétrica y Pruebas Robustas:"
)

for dia_info in "${dias_m2s3[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_3_Estadistica_Analisis/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_2_Analisis_Datos_Estadistica/Semana_3_Estadistica_Analisis/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 2](../../README.md) | [Volver a Semana 3](../README.md)$next_link
EOF
done

# Semana 4: Bases de Datos Avanzadas
mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_4_Bases_Datos_Avanzadas"

cat > "Mes_2_Analisis_Datos_Estadistica/Semana_4_Bases_Datos_Avanzadas/README.md" << 'EOF'
# Semana 4: Bases de Datos Avanzadas

Optimización, diseño avanzado y arquitecturas de bases de datos escalables.

## 📝 Actividades Diarias

1. [Día 1: Diseño Avanzado de Esquemas de Bases de Datos](./Dia_1_Diseno_Avanzado_Esquemas/README.md)
2. [Día 2: Índices y Estrategias de Optimización de Consultas](./Dia_2_Indices_Optimizacion/README.md)
3. [Día 3: Manejo de Grandes Volúmenes de Datos (Big Data Basics)](./Dia_3_Big_Data_Basics/README.md)
4. [Día 4: Arquitecturas NoSQL vs SQL para Diferentes Casos de Uso](./Dia_4_NoSQL_vs_SQL/README.md)
5. [Día 5: Diseño e Implementación de Base de Datos Analítica](./Dia_5_Base_Datos_Analitica/README.md)

---

[Volver al Mes 2](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m2s4=(
    "Dia_1_Diseno_Avanzado_Esquemas:Diseño Avanzado de Esquemas de Bases de Datos:Dia_2_Indices_Optimizacion"
    "Dia_2_Indices_Optimizacion:Índices y Estrategias de Optimización de Consultas:Dia_3_Big_Data_Basics"
    "Dia_3_Big_Data_Basics:Manejo de Grandes Volúmenes de Datos (Big Data Basics):Dia_4_NoSQL_vs_SQL"
    "Dia_4_NoSQL_vs_SQL:Arquitecturas NoSQL vs SQL para Diferentes Casos de Uso:Dia_5_Base_Datos_Analitica"
    "Dia_5_Base_Datos_Analitica:Diseño e Implementación de Base de Datos Analítica:"
)

for dia_info in "${dias_m2s4[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_2_Analisis_Datos_Estadistica/Semana_4_Bases_Datos_Avanzadas/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_2_Analisis_Datos_Estadistica/Semana_4_Bases_Datos_Avanzadas/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 2](../../README.md) | [Volver a Semana 4](../README.md)$next_link
EOF
done

echo -e "${GREEN}✓ Mes 2 completo${NC}"

# ============================================
# MES 3: Herramientas ETL y Proyecto Final
# ============================================

mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final"

cat > "Mes_3_Herramientas_ETL_Proyecto_Final/README.md" << 'EOF'
# Mes 3: Herramientas ETL y Proyecto Final

Implementa pipelines completos con herramientas profesionales y desarrolla un proyecto integral.

## 📅 Semanas

### [Semana 1: ETL con Python y SQL](./Semana_1_ETL_Python_SQL/README.md)
Domina técnicas avanzadas de ETL combinando Python y SQL.

### [Semana 2: Automatización de Pipelines](./Semana_2_Automatizacion_Pipelines/README.md)
Aprende Apache Airflow para orquestar pipelines de datos.

### [Semana 3: Proyecto Final - Pipeline Completo](./Semana_3_Proyecto_Final_Pipeline/README.md)
Desarrolla un pipeline end-to-end aplicando todo lo aprendido.

### [Semana 4: Carrera Profesional y Próximos Pasos](./Semana_4_Carrera_Profesional/README.md)
Aprende despliegue, monitoreo y gestión de pipelines en producción.

---

[Volver al índice principal](../README.md)
EOF

# Semana 1: ETL con Python y SQL
mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_1_ETL_Python_SQL"

cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_1_ETL_Python_SQL/README.md" << 'EOF'
# Semana 1: ETL con Python y SQL

Técnicas avanzadas de ETL combinando el poder de Python y SQL.

## 📝 Actividades Diarias

1. [Día 1: Extracción de Datos con Python](./Dia_1_Extraccion_Datos_Python/README.md)
2. [Día 2: Transformaciones Básicas con Pandas](./Dia_2_Transformaciones_Basicas_Pandas/README.md)
3. [Día 3: Transformaciones Avanzadas y Enriquecimiento](./Dia_3_Transformaciones_Avanzadas/README.md)
4. [Día 4: Carga de Datos y Estrategias de Destino](./Dia_4_Carga_Datos_Estrategias/README.md)
5. [Día 5: Manejo de Errores y Logging en ETL](./Dia_5_Manejo_Errores_Logging_ETL/README.md)

---

[Volver al Mes 3](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m3s1=(
    "Dia_1_Extraccion_Datos_Python:Extracción de Datos con Python:Dia_2_Transformaciones_Basicas_Pandas"
    "Dia_2_Transformaciones_Basicas_Pandas:Transformaciones Básicas con Pandas:Dia_3_Transformaciones_Avanzadas"
    "Dia_3_Transformaciones_Avanzadas:Transformaciones Avanzadas y Enriquecimiento:Dia_4_Carga_Datos_Estrategias"
    "Dia_4_Carga_Datos_Estrategias:Carga de Datos y Estrategias de Destino:Dia_5_Manejo_Errores_Logging_ETL"
    "Dia_5_Manejo_Errores_Logging_ETL:Manejo de Errores y Logging en ETL:"
)

for dia_info in "${dias_m3s1[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_1_ETL_Python_SQL/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_1_ETL_Python_SQL/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 3](../../README.md) | [Volver a Semana 1](../README.md)$next_link
EOF
done

# Semana 2: Automatización de Pipelines
mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_2_Automatizacion_Pipelines"

cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_2_Automatizacion_Pipelines/README.md" << 'EOF'
# Semana 2: Automatización de Pipelines

Orquesta pipelines de datos con Apache Airflow.

## 📝 Actividades Diarias

1. [Día 1: Introducción a Apache Airflow](./Dia_1_Introduccion_Airflow/README.md)
2. [Día 2: DAGs y Dependencias](./Dia_2_DAGs_Dependencias/README.md)
3. [Día 3: Operadores y Sensores](./Dia_3_Operadores_Sensores/README.md)
4. [Día 4: Monitoreo y Alertas](./Dia_4_Monitoreo_Alertas/README.md)
5. [Día 5: Pipelines Complejos y Best Practices](./Dia_5_Pipelines_Complejos_Best_Practices/README.md)

---

[Volver al Mes 3](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m3s2=(
    "Dia_1_Introduccion_Airflow:Introducción a Apache Airflow:Dia_2_DAGs_Dependencias"
    "Dia_2_DAGs_Dependencias:DAGs y Dependencias:Dia_3_Operadores_Sensores"
    "Dia_3_Operadores_Sensores:Operadores y Sensores:Dia_4_Monitoreo_Alertas"
    "Dia_4_Monitoreo_Alertas:Monitoreo y Alertas:Dia_5_Pipelines_Complejos_Best_Practices"
    "Dia_5_Pipelines_Complejos_Best_Practices:Pipelines Complejos y Best Practices:"
)

for dia_info in "${dias_m3s2[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_2_Automatizacion_Pipelines/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_2_Automatizacion_Pipelines/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 3](../../README.md) | [Volver a Semana 2](../README.md)$next_link
EOF
done

# Semana 3: Proyecto Final - Pipeline Completo
mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_3_Proyecto_Final_Pipeline"

cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_3_Proyecto_Final_Pipeline/README.md" << 'EOF'
# Semana 3: Proyecto Final - Pipeline Completo

Desarrolla un pipeline end-to-end integrando todas las habilidades adquiridas.

## 📝 Actividades Diarias

1. [Día 1: Diseño de Arquitectura Completa](./Dia_1_Diseno_Arquitectura_Completa/README.md)
2. [Día 2: Implementación de Pipeline End-to-End](./Dia_2_Implementacion_Pipeline_End_to_End/README.md)
3. [Día 3: Validación y Testing](./Dia_3_Validacion_Testing/README.md)
4. [Día 4: Optimización y Performance](./Dia_4_Optimizacion_Performance/README.md)
5. [Día 5: Documentación y Presentación](./Dia_5_Documentacion_Presentacion/README.md)

---

[Volver al Mes 3](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m3s3=(
    "Dia_1_Diseno_Arquitectura_Completa:Diseño de Arquitectura Completa:Dia_2_Implementacion_Pipeline_End_to_End"
    "Dia_2_Implementacion_Pipeline_End_to_End:Implementación de Pipeline End-to-End:Dia_3_Validacion_Testing"
    "Dia_3_Validacion_Testing:Validación y Testing:Dia_4_Optimizacion_Performance"
    "Dia_4_Optimizacion_Performance:Optimización y Performance:Dia_5_Documentacion_Presentacion"
    "Dia_5_Documentacion_Presentacion:Documentación y Presentación:"
)

for dia_info in "${dias_m3s3[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_3_Proyecto_Final_Pipeline/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_3_Proyecto_Final_Pipeline/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 3](../../README.md) | [Volver a Semana 3](../README.md)$next_link
EOF
done

# Semana 4: Carrera Profesional y Próximos Pasos
mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_4_Carrera_Profesional"

cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_4_Carrera_Profesional/README.md" << 'EOF'
# Semana 4: Carrera Profesional y Próximos Pasos

Aprende las mejores prácticas de despliegue, monitoreo y gestión de pipelines en producción.

## 📝 Actividades Diarias

1. [Día 1: Estrategias de Despliegue (CI/CD)](./Dia_1_Estrategias_Despliegue_CICD/README.md)
2. [Día 2: Monitoreo y Observabilidad](./Dia_2_Monitoreo_Observabilidad/README.md)
3. [Día 3: Gestión de Incidentes y Recuperación](./Dia_3_Gestion_Incidentes_Recuperacion/README.md)
4. [Día 4: Actualización y Escalabilidad de Pipelines](./Dia_4_Actualizacion_Escalabilidad/README.md)
5. [Día 5: Documentación y Presentación](./Dia_5_Documentacion_Presentacion_Final/README.md)

---

[Volver al Mes 3](../README.md) | [Volver al índice principal](../../README.md)
EOF

dias_m3s4=(
    "Dia_1_Estrategias_Despliegue_CICD:Estrategias de Despliegue (CI/CD):Dia_2_Monitoreo_Observabilidad"
    "Dia_2_Monitoreo_Observabilidad:Monitoreo y Observabilidad:Dia_3_Gestion_Incidentes_Recuperacion"
    "Dia_3_Gestion_Incidentes_Recuperacion:Gestión de Incidentes y Recuperación:Dia_4_Actualizacion_Escalabilidad"
    "Dia_4_Actualizacion_Escalabilidad:Actualización y Escalabilidad de Pipelines:Dia_5_Documentacion_Presentacion_Final"
    "Dia_5_Documentacion_Presentacion_Final:Documentación y Presentación:"
)

for dia_info in "${dias_m3s4[@]}"; do
    IFS=':' read -r carpeta titulo siguiente <<< "$dia_info"
    mkdir -p "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_4_Carrera_Profesional/$carpeta"/{documentos,imagenes}
    
    next_link=""
    if [ -n "$siguiente" ]; then
        next_link=" | [Día Siguiente →](../$siguiente/README.md)"
    fi
    
    cat > "Mes_3_Herramientas_ETL_Proyecto_Final/Semana_4_Carrera_Profesional/$carpeta/README.md" << EOF
# $titulo

## 🚧 En Construcción

Este proyecto está actualmente en desarrollo.

---

[Volver al índice principal](../../../README.md) | [Volver al Mes 3](../../README.md) | [Volver a Semana 4](../README.md)$next_link
EOF
done

echo -e "${GREEN}✓ Mes 3 completo${NC}"

echo ""
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Estructura completa creada exitosamente${NC}"
echo -e "${BLUE}════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}Estadísticas:${NC}"
echo -e "  📁 3 Meses"
echo -e "  📅 12 Semanas"
echo -e "  📝 60 Días de contenido"
echo -e "  📂 Carpetas 'documentos' e 'imagenes' en cada día"
echo -e "  📄 README.md con navegación en todos los niveles"
echo ""
echo -e "${BLUE}Para ejecutar este script:${NC}"
echo -e "  1. Guarda este script como 'crear_estructura.sh'"
echo -e "  2. Dale permisos de ejecución: ${GREEN}chmod +x crear_estructura.sh${NC}"
echo -e "  3. Ejecútalo: ${GREEN}./crear_estructura.sh${NC}"
echo ""