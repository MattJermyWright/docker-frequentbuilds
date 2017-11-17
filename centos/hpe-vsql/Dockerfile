FROM centos:latest

COPY vertica-client-8.1.0-0.x86_64.rpm /root
RUN rpm -Uvh /root/vertica-client-8.1.0-0.x86_64.rpm
RUN yum -y install epel-release
RUN yum -y install openconnect vpnc net-tools
RUN yum -y update

COPY startOpenclient.sh /root
RUN chmod 755 /root/startOpenclient.sh



