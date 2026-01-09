# Base image with Java 17
FROM eclipse-temurin:17-jdk

# Set working directory inside container
WORKDIR /app

# Copy the Spring Boot JAR into container
COPY target/*.jar app.jar

# Expose Spring Boot port
EXPOSE 8080

# Run the Spring Boot application
CMD ["java", "-jar", "app.jar"]
