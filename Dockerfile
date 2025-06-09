FROM openjdk:17-oracle

ARG JAR_PATH=target/*.jar
COPY ${JAR_PATH} spring-petclinic.jar

# ✅ application.properties가 classpath에 있도록 복사
COPY src/main/resources/application.properties /application.properties

EXPOSE 8080

CMD ["java", "-jar", "spring-petclinic.jar"]
