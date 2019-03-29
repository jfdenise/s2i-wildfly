# This image provides a base for building and running WildFly applications.
# It builds using maven and runs the resulting artifacts on WildFly 16.0.0 Final

FROM centos:7

RUN INSTALL_PKGS="bc java-11-openjdk" && \
    yum install -y --enablerepo=centosplus $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all -y

RUN mkdir /opt/jboss/
ENV HOME=/home/jboss

RUN mkdir ${HOME} && useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin \
      -c "JBoss Application User" jboss && \
      chown -R 1001:0 /opt/jboss && chmod -R ug+rwX /opt/jboss