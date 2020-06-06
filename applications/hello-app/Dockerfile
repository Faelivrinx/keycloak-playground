FROM openjdk:11.0.7-jre-slim-buster
ADD target/hello-app-1.0.0.jar app.jar
EXPOSE 8080
EXPOSE 8787
ENTRYPOINT ["java", "-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=*:8787", "-jar", "app.jar"]