FROM phusion/baseimage:latest

# Switch to bash from SH
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update with all the python build dependencies
RUN apt-get update
RUN apt-get install -y \
    build-essential \
    git \
    libssl-dev

# Install Go Language
RUN mkdir -p /opt/local && curl -o /opt/local/go1.7.5.linux-amd64.tar.gz \
    https://storage.googleapis.com/golang/go1.7.5.linux-amd64.tar.gz
RUN cd /opt/local && tar zxvf go1.7.5.linux-amd64.tar.gz && mkdir /go

ENV GOROOT /opt/local/go
ENV GOPATH /go
ENV PATH $GOROOT/bin:$PATH

# Disable these services
RUN rm -rf /etc/service/cron
RUN rm -rf /etc/service/sshd
RUN rm -f  /etc/my_init.d/*ssh*
#RUN rm -rf /etc/service/syslog-forwarder
#RUN rm -rf /etc/service/syslog-ng

COPY sampleService.go /root/sampleService443.go
COPY launchService.sh /root/launchService.sh

# Certs
COPY SSL.cer /root/SSL.cer
COPY measure.agilemeasure.com.key /root/measure.agilemeasure.com.key

# Use baseimage-docker's init system.
CMD ["/sbin/my_init","--","/root/launchService.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose web port
EXPOSE 443