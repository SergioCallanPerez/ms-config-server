# Construccion
FROM gradle:8.10.2-jdk21 AS builder
WORKDIR /home/gradle/project

# copiar todo el proyecto (contexto de build será la carpeta del microservicio)
COPY --chown=gradle:gradle . .
# construir jar (skip tests para acelerar)
RUN gradle bootJar -x test --no-daemon

# Stage 2: runtime
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=builder /home/gradle/project/build/libs/*.jar app.jar
EXPOSE 8888
ENTRYPOINT ["java", "-jar", "app.jar"]
