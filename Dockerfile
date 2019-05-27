FROM ubuntu:xenial

ENV ANSIBLE_VERSION 2.8.0

RUN apt-get update && \
    apt-get install -y bison && \
    apt-get install -y flex && \
    apt-get install -y libpq5 && \
    apt-get install -y libpq-dev && \
    apt-get install -y postgresql-server-dev-9.5 && \
    apt-get install -y postgresql-client-9.5 && \
    apt-get install -y socat && \
    apt-get install -y python3-pip && \
    pip3 install --upgrade pip && \
    pip install pyOpenSSL && \
    pip install ansible==${ANSIBLE_VERSION} && \
    pip install docker && \
    pip install ipmt && \
    pip install psycopg2-binary && \

ENV DOCKER_HOST="tcp://127.0.0.1:2375"


WORKDIR /ansible

ENTRYPOINT ["/ansible/files/init_script"]

