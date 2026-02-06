#!/bin/bash

# --- Configuración --- [cite: 47]
REPO_DIR="/darioDespliegue"
TOMCAT_WEBAPPS="/var/lib/tomcat10/webapps"
TOMCAT_LIB="/usr/share/tomcat10/lib/servlet-api.jar"

echo "1. Actualizando código desde GitHub..." [cite: 18]
cd $REPO_DIR
git pull origin main

echo "2. Compilando Servlet..." [cite: 19]
# Se usa la librería de Tomcat 10 y se guarda en WEB-INF/classes
mkdir -p WEB-INF/classes
javac -cp "$TOMCAT_LIB" src/hola/HolaServlet.java -d WEB-INF/classes

echo "3. Generando archivo WAR..." [cite: 19]
jar -cvf hola.war WEB-INF

echo "4. Desplegando en Tomcat..." [cite: 20]
sudo cp hola.war $TOMCAT_WEBAPPS/

echo "5. Reiniciando Tomcat..." [cite: 21]
sudo systemctl restart tomcat10

echo "6. Comprobando despliegue..." [cite: 22]
sleep 5
STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/hola/HolaServlet)

if [ "$STATUS" -eq 200 ]; then
    echo "¡Despliegue completado con éxito! (HTTP $STATUS)" [cite: 22]
else
    echo "Error en el despliegue. Código HTTP: $STATUS"
    exit 1
fi
