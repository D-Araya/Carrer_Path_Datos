# Repositorios Remotos, GitHub y SSH

# Ejercicio: Configuración SSH y Conexión con GitHub

## 📋 Objetivo
Configurar autenticación SSH para conectar de forma segura con GitHub sin necesidad de ingresar contraseña en cada operación.

---

## 🛠️ Requerimientos

- **Git:** Instalado y configurado (completado en ejercicio anterior)
- **Cuenta GitHub:** Activa en [github.com](https://github.com)
- **Terminal:** Git Bash (Windows), Terminal (macOS/Linux)
- **OpenSSH:** Incluido por defecto en la mayoría de sistemas

---

## 🔐 ¿Qué es SSH?

**SSH (Secure Shell)** es un protocolo de red que permite:
- Conexión segura entre tu máquina y GitHub
- Autenticación sin contraseñas mediante claves criptográficas
- Comunicación encriptada para mayor seguridad

**Ventajas de usar SSH con GitHub:**
- ✅ No necesitas ingresar usuario/contraseña en cada push/pull
- ✅ Mayor seguridad que HTTPS con tokens
- ✅ Autenticación automática una vez configurado

---

## 📝 Pasos Realizados

### 1. Verificación de Configuración Previa

Primero verificamos si ya existe una configuración SSH:

```bash
# Listar archivos en la carpeta .ssh
ls -la ~/.ssh
```

**Posibles resultados:**
- Si existe `id_ed25519` o `id_rsa`: Ya tienes claves SSH generadas
- Si no existe la carpeta o está vacía: Necesitas generar nuevas claves

### 2. Generación de Clave SSH

Generamos un par de claves SSH (pública y privada) usando el algoritmo Ed25519:

```bash
ssh-keygen -t ed25519 -C "tu.email@ejemplo.com"
```

**Durante la ejecución:**
```
Generating public/private ed25519 key pair.
Enter file in which to save the key (/c/Users/TU_USUARIO/.ssh/id_ed25519):
```
→ **Presionar Enter** (acepta ubicación por defecto)

```
Enter passphrase (empty for no passphrase):
```
→ **Opcional:** Ingresar passphrase para mayor seguridad o Enter para omitir

```
Enter same passphrase again:
```
→ Confirmar passphrase

**Resultado:**
```
Your identification has been saved in /c/Users/TU_USUARIO/.ssh/id_ed25519
Your public key has been saved in /c/Users/TU_USUARIO/.ssh/id_ed25519.pub
The key fingerprint is:
SHA256:XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX tu.email@ejemplo.com
```

**Archivos generados:**
- 🔒 `id_ed25519` - Clave privada (NUNCA compartir)
- 🔓 `id_ed25519.pub` - Clave pública (compartir con GitHub)

### 3. Iniciar el Agente SSH

El agente SSH mantiene tus claves privadas en memoria:

```bash
# Iniciar agente SSH
eval "$(ssh-agent -s)"
```

**Resultado esperado:**
```
Agent pid 12345
```

### 4. Agregar Clave Privada al Agente

```bash
ssh-add ~/.ssh/id_ed25519
```

**Resultado esperado:**
```
Identity added: /c/Users/TU_USUARIO/.ssh/id_ed25519 (tu.email@ejemplo.com)
```

### 5. Obtener la Clave Pública

Visualizamos y copiamos la clave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

**Resultado (ejemplo):**
```
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAbCdEfGhIjKlMnOpQrStUvWxYzAbCdEfGhIjKlMnOpQ tu.email@ejemplo.com
```

**⚠️ IMPORTANTE:** Copia TODA la línea, desde `ssh-ed25519` hasta tu email.

### 6. Agregar Clave SSH a GitHub

#### 6.1 Acceder a configuración de SSH en GitHub

1. Ve a [GitHub.com](https://github.com)
2. Click en tu foto de perfil (esquina superior derecha)
3. Selecciona **Settings**
4. En el menú lateral, click en **SSH and GPG keys**
5. Click en el botón verde **"New SSH key"**

#### 6.2 Completar formulario

- **Title:** Nombre descriptivo (ej: "Laptop Personal - Windows")
- **Key type:** Authentication Key
- **Key:** Pega la clave pública completa

#### 6.3 Guardar

- Click en **"Add SSH key"**
- Confirma con tu contraseña de GitHub si es solicitada

### 7. Verificar Conexión SSH con GitHub

Probamos la conexión SSH:

```bash
ssh -T git@github.com
```

**Primera vez (pregunta de autenticidad):**
```
The authenticity of host 'github.com (IP_ADDRESS)' can't be established.
ED25519 key fingerprint is SHA256:+DiY3wvvV6TuJJhbpZisF/zLDA0zPMSvHdkr4UvCOqU.
Are you sure you want to continue connecting (yes/no/[fingerprint])?
```
→ Escribe **`yes`** y presiona Enter

**Resultado exitoso:**
```
Hi TU_USUARIO! You've successfully authenticated, but GitHub does not provide shell access.
```

✅ **Conexión SSH configurada correctamente**

### 8. Conectar Repositorio Local con GitHub

#### 8.1 Crear repositorio en GitHub

1. Ve a [github.com/new](https://github.com/new)
2. **Repository name:** `Carrer_Path_Datos`
3. **Description:** "Programa estructurado de 3 meses para dominar el stack completo de datos"
4. **⚠️ IMPORTANTE:** NO marques README, .gitignore, ni licencia
5. Click en **"Create repository"**

#### 8.2 Agregar remote al repositorio local

```bash
# Navegar al repositorio
cd /c/Users/mlops/Documents/proyectos/Carrer_Path_Datos

# Agregar remote con SSH
git remote add origin git@github.com:TU_USUARIO/Carrer_Path_Datos.git

# Verificar remote
git remote -v
```

**Resultado esperado:**
```
origin  git@github.com:TU_USUARIO/Carrer_Path_Datos.git (fetch)
origin  git@github.com:TU_USUARIO/Carrer_Path_Datos.git (push)
```

#### 8.3 Cambiar Remote de HTTPS a SSH (si es necesario)

Si ya tenías el repositorio configurado con HTTPS, necesitas cambiar a SSH:

```bash
# Ver remote actual
git remote -v

# Si muestra HTTPS (https://github.com/...), cambiar a SSH:
# 1. Eliminar remote HTTPS
git remote remove origin

# 2. Agregar remote SSH
git remote add origin git@github.com:TU_USUARIO/Carrer_Path_Datos.git

# 3. Verificar cambio
git remote -v
```

**Resultado esperado después del cambio:**
```
origin  git@github.com:TU_USUARIO/Carrer_Path_Datos.git (fetch)
origin  git@github.com:TU_USUARIO/Carrer_Path_Datos.git (push)
```

#### 8.4 Subir código a GitHub

```bash
# Push inicial
git push -u origin main
```

**Resultado esperado:**
```
Enumerating objects: X, done.
Counting objects: 100% (X/X), done.
Delta compression using up to N threads
Compressing objects: 100% (Y/Y), done.
Writing objects: 100% (Z/Z), KKK KiB | MMM MiB/s, done.
Total Z (delta W), reused V (delta U), pack-reused 0
To github.com:TU_USUARIO/Carrer_Path_Datos.git
 * [new branch]      main -> main
Branch 'main' set up to track remote branch 'main' from 'origin'.
```

✅ **Repositorio sincronizado con GitHub usando SSH**

---

## ✅ Verificación Final

### Checklist de completitud:

- [x] Clave SSH generada (Ed25519)
- [x] Agente SSH iniciado
- [x] Clave privada agregada al agente
- [x] Clave pública copiada
- [x] Clave SSH agregada a GitHub
- [x] Conexión SSH verificada exitosamente
- [x] Repositorio remoto creado en GitHub
- [x] Remote configurado en repositorio local
- [x] Push inicial realizado correctamente
- [x] Operaciones sin solicitud de contraseña

---

## 📊 Comandos Utilizados - Resumen

| Comando | Propósito |
|---------|-----------|
| `ssh-keygen -t ed25519` | Generar par de claves SSH |
| `eval "$(ssh-agent -s)"` | Iniciar agente SSH |
| `ssh-add ~/.ssh/id_ed25519` | Agregar clave privada al agente |
| `cat ~/.ssh/id_ed25519.pub` | Mostrar clave pública |
| `ssh -T git@github.com` | Probar conexión SSH con GitHub |
| `git remote add origin` | Conectar repo local con remoto |
| `git push -u origin main` | Subir cambios a GitHub |
| `git remote -v` | Ver remotes configurados |

---

## 🔑 Conceptos Clave Aprendidos

1. **Autenticación SSH:** Método seguro basado en criptografía de clave pública/privada
2. **Par de claves:** Clave privada (secreta) y clave pública (compartible)
3. **Agente SSH:** Programa que mantiene claves privadas en memoria
4. **Remote:** Versión del repositorio alojada en servidor (GitHub)
5. **Origin:** Nombre convencional para el remote principal

---

## 🔐 Diagrama de Autenticación SSH

```
┌─────────────────┐                           ┌─────────────────┐
│  Tu Computadora │                           │     GitHub      │
│                 │                           │                 │
│  Clave Privada  │──── Solicitud SSH ───────▶│                 │
│   (secreta)     │                           │  Clave Pública  │
│                 │◀──── Desafío ─────────────│   (guardada)    │
│                 │                           │                 │
│  Firma con      │──── Respuesta firmada ───▶│                 │
│  clave privada  │                           │  Verifica firma │
│                 │                           │                 │
│                 │◀──── Acceso Concedido ────│   ✅ Éxito     │
└─────────────────┘                           └─────────────────┘
```

---

## 🛡️ Buenas Prácticas de Seguridad

### ✅ Hacer:
- Usar algoritmo Ed25519 (más seguro y rápido)
- Agregar passphrase a la clave para mayor seguridad
- Mantener clave privada siempre segura
- Usar nombres descriptivos para claves en GitHub
- Revisar y revocar claves no utilizadas

### ❌ No hacer:
- Nunca compartir tu clave privada (`id_ed25519`)
- No copiar claves privadas a servidores remotos
- No commitear claves en repositorios
- No usar la misma clave en múltiples servicios críticos

---

## 🔄 Flujo de Trabajo con Git y GitHub

```mermaid
graph LR
    A[Working Directory] -->|git add| B[Staging Area]
    B -->|git commit| C[Local Repository]
    C -->|git push| D[GitHub Remote]
    D -->|git pull| C
    C -->|git pull| A
```

---

## 🚨 Solución de Problemas Comunes

### Error: "Permission denied (publickey)"

**Causa:** GitHub no reconoce tu clave SSH

**Solución:**
```bash
# Verificar que la clave esté en el agente
ssh-add -l

# Si no aparece, agregar nuevamente
ssh-add ~/.ssh/id_ed25519

# Verificar conexión
ssh -T git@github.com
```

### Error: "Could not resolve hostname github.com"

**Causa:** Problema de conexión a internet o DNS

**Solución:**
```bash
# Verificar conectividad
ping github.com

# Verificar DNS
nslookup github.com
```

### Error: Remote already exists

**Causa:** Ya existe un remote llamado "origin"

**Solución:**
```bash
# Ver remotes actuales
git remote -v

# Eliminar remote existente
git remote remove origin

# Agregar nuevamente
git remote add origin git@github.com:TU_USUARIO/REPO.git
```

---

## 📚 Recursos Adicionales

- [Documentación SSH de GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Troubleshooting SSH](https://docs.github.com/en/authentication/troubleshooting-ssh)
- [About SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh)
- [Managing SSH Keys](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

---

## 🎯 Diferencias: HTTPS vs SSH

| Aspecto | HTTPS | SSH |
|---------|-------|-----|
| Autenticación | Usuario/Contraseña o Token | Par de claves |
| Seguridad | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| Configuración | Más simple | Requiere configuración inicial |
| Uso diario | Solicita credenciales | Sin solicitudes |
| Firewall | Funciona en redes restrictivas | Puede ser bloqueado |
| Recomendado para | Uso ocasional | Uso frecuente |

---

## 🚀 Próximos Pasos

1. Practicar flujo de trabajo: pull → cambios → commit → push
2. Aprender sobre ramas (branches) y merge
3. Colaborar con otros usando Pull Requests
4. Configurar múltiples claves SSH para diferentes servicios
5. Explorar GitHub Actions para CI/CD

---

**Configuración aplicada:**
- Algoritmo: Ed25519
- Passphrase: [Sí/No]
- Ubicación clave: `~/.ssh/id_ed25519`
- Remote configurado: `origin` (SSH)

---


[Volver al índice principal](../../../README.md) | [Volver al Mes 1](../../README.md) | [Volver a Semana 1](../README.md) | [Día Siguiente →](../Dia_4_Pull_Requests_Ramas_Merge/README.md)
