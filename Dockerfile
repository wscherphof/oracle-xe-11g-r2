#
# wscherphof/oracle-xe-11g-r2
#
FROM wscherphof/oracle-linux-7
MAINTAINER Wouter Scherphof <wouter.scherphof@gmail.com>

# Install prerequisites
RUN yum install -y make libaio bc net-tools vte3

# Copy installation files
ADD Disk1/oracle-xe-11.2.0-1.0.x86_64.rpm /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm
ADD Disk1/response/xe.rsp                 /tmp/xe.rsp
ADD init.ora                              /tmp/init.ora
ADD initXETemp.ora                        /tmp/initXETemp.ora

# Install oracle
RUN yum localinstall -y /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm
RUN rm -f /tmp/oracle-xe-11.2.0-1.0.x86_64.rpm

# Move the config files to their spot inside the oracle installation
RUN mv /tmp/*.ora /u01/app/oracle/product/11.2.0/xe/config/scripts

# Configure the new database
RUN /etc/init.d/oracle-xe configure responseFile=/tmp/xe.rsp

ENV ORACLE_SID  XE
ENV ORACLE_HOME /u01/app/oracle/product/11.2.0/xe
ENV PATH        $ORACLE_HOME/bin:$PATH

EXPOSE 1521 8080

ADD start /tmp/start
CMD /tmp/start


