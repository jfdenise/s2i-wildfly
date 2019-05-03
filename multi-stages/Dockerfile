# Copy the provisioned WildFly and deployment from a single build onto runtime image

FROM  wildfly/wildfly-openshift-runtime:latest

COPY --from=tasks-rs-app-from-s2i:latest /s2i-output/wildfly $JBOSS_HOME
USER root
RUN chown -R jboss:root $JBOSS_HOME && chmod -R ug+rwX $JBOSS_HOME

USER jboss

CMD ["/opt/jboss/wildfly/bin/openshift-launch.sh"]