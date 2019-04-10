# Copy the provisioned WildFly and deployment from a single build onto runtime image

FROM  wildfly-runtime-dependencies-image:latest

COPY --from=tasks-jaxrs-from-s2i:latest /s2i-output/wildfly /opt/jboss/wildfly
RUN chown -R 1001:0 /opt/jboss/wildfly && chmod -R ug+rwX /opt/jboss/wildfly
USER 1001
EXPOSE 8080 9090
CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0"]