FROM maven:3.6-jdk-11

COPY target/ /app/
WORKDIR /app/

EXPOSE 8080
CMD ["java", "-jar", "app.jar"]