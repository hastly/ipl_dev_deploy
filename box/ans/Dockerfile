FROM ubuntu:xenial

ENV ANSIBLE_VERSION 2.8.0
ENV DOCKER_HOST="tcp://127.0.0.1:2375"
ENV IPL_DEV_DEPLOY_ROOT=../
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y \
        git \
        openssh-server \
        bison \ 
        flex \
        libpq5 \
        libpq-dev \
        postgresql-server-dev-9.5 \
        postgresql-client-9.5 \
        socat \
        python3-pip && \
    pip3 install --upgrade pip && \
    pip install \
        pyOpenSSL \
        ansible==${ANSIBLE_VERSION} \
        docker \
        psycopg2-binary && \
    pip install \
        ipmt && \
    pip install \
        docker-compose

RUN sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config
RUN mkdir /root/.ssh;chown -R root:root /root/.ssh;chmod -R 700 /root/.ssh
RUN mkdir /var/run/sshd
WORKDIR /ansible/art

ENTRYPOINT ["/ansible/art/files/init_script"]

