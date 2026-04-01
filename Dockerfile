FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
# Note: This path assumes you are building from the project root
COPY target/JtSpringProject-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]