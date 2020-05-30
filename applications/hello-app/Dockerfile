FROM openjdk:11-jre-alpine
ADD target/hello-app-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]