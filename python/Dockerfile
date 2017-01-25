FROM ubuntu:latest
RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install curl git libssl-dev libsqlite3-dev sqlite3 bzip2 libbz2-dev
RUN apt-get -y install libreadline6 libreadline6-dev build-essential

RUN curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
RUN echo "export PATH=\"/root/.pyenv/bin:\$PATH\"" >> /root/.bashrc
RUN echo "eval \"\$(pyenv init -)\"" >> /root/.bashrc
RUN echo "eval \"\$(pyenv virtualenv-init -)\"" >> /root/.bashrc
RUN /root/.pyenv/bin/pyenv install 3.6.0
# RUN /root/.pyenv/bin/pyenv install 2.7.11
RUN cd /root && /root/.pyenv/bin/pyenv local 3.6.0
