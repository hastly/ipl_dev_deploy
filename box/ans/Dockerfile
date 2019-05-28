FROM ubuntu:xenial

ENV ANSIBLE_VERSION 2.8.0
ENV DOCKER_HOST="tcp://127.0.0.1:2375"
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y \
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
        ipmt


WORKDIR /ansible

ENTRYPOINT ["/ansible/files/init_script"]

