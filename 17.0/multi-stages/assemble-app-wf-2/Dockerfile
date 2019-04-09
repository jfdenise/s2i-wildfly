# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 16.0.0 Final

FROM  wildfly-runtime-dependencies-image:latest

COPY --from=cloud-profile-from-s2i:latest /s2i-output/wildfly /opt/jboss/wildfly
COPY --from=tasks-rs-app-from-s2i:latest /s2i-output/deployments/ /opt/jboss/wildfly/standalone/deployments
COPY --from=tasks-rs-app-from-s2i:latest /s2i-output/standalone/configuration/ /opt/jboss/wildfly/standalone
COPY --from=tasks-rs-app-from-s2i:latest /s2i-output/provided_modules /opt/jboss/wildfly/provided_modules
RUN chown -R 1001:0 /opt/jboss/wildfly && chmod -R ug+rwX /opt/jboss/wildfly
USER 1001
EXPOSE 8080 9090
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]