#!/bin/bash

APP_NAME="SimpleServletApp"
TOMCAT_PATH="/home/codespace/tomcat"
SERVLET_JAR="$TOMCAT_PATH/jakarta.servlet-api.jar"

CLASSES_DIR="$APP_NAME/WEB-INF/classes"

echo "[1] Compile..."
javac -cp "$SERVLET_JAR" -d "$CLASSES_DIR" $(find "$CLASSES_DIR" -name "*.java")

if [ $? -ne 0 ]; then
  echo "[Error] Compile failed."
  exit 1
fi

echo "[2] WAR package getting ready..."
cd "$APP_NAME"
jar -cvf "$APP_NAME.war" *
mv "$APP_NAME.war" ..
cd ..

echo "[3] Tomcat deploy..."
rm -rf "$TOMCAT_PATH/webapps/$APP_NAME"
cp "$APP_NAME.war" "$TOMCAT_PATH/webapps/"

echo "[4] Tomcat restarting..."
"$TOMCAT_PATH/bin/shutdown.sh"
sleep 3
"$TOMCAT_PATH/bin/startup.sh"

echo "[✓] deploy success: http://localhost:8080/"
