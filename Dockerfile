# Stage 1: Build
FROM eclipse-temurin:21-jdk-jammy as build
WORKDIR /app

# Copy Maven wrapper and configuration
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Fix permissions for the Maven wrapper (crucial for Linux/Docker)
RUN chmod +x mvnw

# Copy source code and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Stage 2: Runtime
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# Explicitly copy the SNAPSHOT jar to avoid grabbing the wrong file
COPY --from=build /app/target/secure-resource-api-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]