FROM jboss/keycloak

ENV KEYCLOAK_USER=admin
ENV KEYCLOAK_PASSWORD=password

# Add demo realm with clients and roles
ADD keycloak-realm.json /opt/jboss/keycloak/

COPY /plugins/keycloak-metrics-spi-master/build/libs/keycloak-metrics-spi-2.0.2-SNAPSHOT.jar /opt/jboss/keycloak/standalone/deployments

# Import to keycloak
CMD ["-b", "0.0.0.0", "-Dkeycloak.import=/opt/jboss/keycloak/keycloak-realm.json"]


EXPOSE 8080
EXPOSE 8443
EXPOSE 8787