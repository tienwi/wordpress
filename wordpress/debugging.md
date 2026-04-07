# Guía de Debugging WordPress — Tienwi

## Paso 1: Activar modo debug

Agrega en `wp-config.php` (antes de `/* That's all, stop editing! */`):

```php
define( 'WP_DEBUG', true );
define( 'WP_DEBUG_LOG', true );
define( 'WP_DEBUG_DISPLAY', false ); // No mostrar errores en pantalla en producción
define( 'SCRIPT_DEBUG', true );
```

El log se guarda en: `wp-content/debug.log`

---

## Paso 2: Tipos de errores comunes

### White Screen of Death (WSOD)
**Causa más frecuente**: Error fatal PHP, memory limit, plugin conflictivo
**Diagnóstico**:
1. Revisa `debug.log`
2. Renombra carpeta del último plugin instalado via FTP/cPanel
3. Activa tema por defecto (Twenty Twenty-Four) via BD:
   ```sql
   UPDATE wp_options SET option_value = 'twentytwentyfour' WHERE option_name = 'template';
   UPDATE wp_options SET option_value = 'Twenty Twenty-Four' WHERE option_name = 'stylesheet';
   ```

### Error 500
**Diagnóstico**:
1. Revisa el error_log del servidor en cPanel (`/home/usuario/logs/`)
2. Aumenta memory limit en `wp-config.php`:
   ```php
   define( 'WP_MEMORY_LIMIT', '256M' );
   ```
3. Renombra `.htaccess` y regenera desde Ajustes > Enlaces permanentes

### Conflicto de plugins
**Proceso**:
1. Desactiva TODOS los plugins via BD:
   ```sql
   UPDATE wp_options SET option_value = 'a:0:{}' WHERE option_name = 'active_plugins';
   ```
2. Reactiva de uno en uno hasta reproducir el error
3. Identifica el plugin conflictivo

### Error de base de datos
**Síntoma**: "Error al establecer conexión con la base de datos"
**Diagnóstico**:
1. Verifica credenciales en `wp-config.php`
2. Confirma que el servidor MySQL está corriendo en cPanel
3. Verifica que el usuario tiene permisos sobre la BD

---

## Paso 3: Herramientas de diagnóstico

### Query Monitor (plugin)
Instala en desarrollo para ver:
- Queries lentas (>0.05s)
- Hooks ejecutados
- HTTP requests
- Errores PHP en tiempo real

### WP-CLI (si hay acceso SSH)
```bash
# Ver logs en tiempo real
wp shell

# Verificar estado del sitio
wp core verify-checksums

# Listar plugins activos
wp plugin list --status=active

# Regenerar thumbnails
wp media regenerate --yes
```

---

## Paso 4: Debugging de JavaScript

En `wp-config.php`:
```php
define( 'SCRIPT_DEBUG', true ); // Carga versiones no minificadas
```

En el navegador:
1. Abre DevTools (F12)
2. Tab Console — busca errores JS
3. Tab Network — busca requests fallidos (404, 500)

---

## Paso 5: Verificación post-fix

Antes de cerrar el ticket:
- [ ] El error ya no aparece en `debug.log`
- [ ] Las páginas principales cargan correctamente
- [ ] El checkout/formularios funcionan (si aplica)
- [ ] No hay errores en consola del navegador
- [ ] Se desactivó WP_DEBUG en producción
- [ ] Se documentó en `BITACORA.md`
