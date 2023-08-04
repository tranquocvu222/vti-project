FROM openjdk:8-jdk-alpine
RUN adduser -D -u 1001 appuser

WORKDIR /app
COPY build/libs/vti-project-0.0.1-SNAPSHOT.jar vti-api-project.jar
RUN chown appuser:appuser vti-api-project.jar

USER appuser

EXPOSE 8082

CMD ["java", "-jar", "vti-api-project.jar"]