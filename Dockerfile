# Use a base image with Java 11 installed
FROM openjdk:11 as build

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot executable JAR file into the container
COPY target/spark-lms-0.0.1-SNAPSHOT.jar app.jar

# Expose the port that the application listens on (change it if your application uses a different port)
EXPOSE 8080

# Set the command to run the Spring Boot application when the container starts
ENTRYPOINT ["java", "-jar", "app.jar"]
