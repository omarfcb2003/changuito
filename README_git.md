🧠 FLUJO DE TRABAJO CON GIT Y GITHUB PARA CHANGUITO

========================================
🔁 FLUJO BÁSICO PARA HACER CAMBIOS
========================================

1. CREAR UNA NUEVA RAMA
----------------------------------------
git checkout -b nombre-de-la-rama
Ejemplos:
  git checkout -b autenticacion-google
  git checkout -b ajuste-ui
  git checkout -b refactor-firebase-service

2. HACER CAMBIOS EN TU PROYECTO
----------------------------------------
Modificá los archivos que necesites en Flutter, probá que todo funcione.

3. GUARDAR LOS CAMBIOS LOCALMENTE
----------------------------------------
git add .
git commit -m "Descripción clara del cambio realizado"

4. SUBIR LA RAMA AL REPOSITORIO REMOTO
----------------------------------------
git push origin nombre-de-la-rama

5. HACER EL MERGE DESDE GITHUB
----------------------------------------
1. Entrá a GitHub y creá un Pull Request (PR)
2. Compará `nombre-de-la-rama` contra `main`
3. Revisá los cambios, aprobá y hacé merge

6. ACTUALIZAR TU RAMA MAIN LOCAL
----------------------------------------
git checkout main
git pull origin main

========================================
🚨 FLUJO PARA VOLVER A LA ÚLTIMA VERSIÓN ESTABLE
========================================

1. CAMBIAR A LA RAMA PRINCIPAL
----------------------------------------
git checkout main

2. REVERTIR A LA ÚLTIMA VERSIÓN SUBIDA A GITHUB
----------------------------------------
git reset --hard origin/main

3. (OPCIONAL) BORRAR ARCHIVOS NO VERSIONADOS
----------------------------------------
git clean -fd

⚠️ Este paso elimina archivos no registrados por Git. Usalo con cuidado.

========================================
