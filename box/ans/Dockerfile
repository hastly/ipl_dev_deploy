# provision управляющего контейнера, нужен для следующего:
# - подготовить Postgres при инициализации: расширения, структуру, данные
# - запускать утилитарные команды меняющие состояние запущенного набора
# - служить прокси для доступа к службам в других контейнерах


# поддерживаемый дистрибутив, у которого есть всё для работы с postgres 9
FROM ubuntu:xenial

# в этой версии появился postgres_query, да и не только
ENV ANSIBLE_VERSION 2.8.0
# на этот порт будет отражён сокет хоста для доступа к docker API
ENV DOCKER_HOST="tcp://127.0.0.1:2375"
# избавляемся от ошибок apt при работе с терминалом
ARG DEBIAN_FRONTEND=noninteractive

# apt-utils вроде как облегчают ему жизнь. но это не точно
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y \
        # надо же как-то забирать комопненты и миграции
        git \
        # если захотим порты пробросить из внутренней сетки
        openssh-server \
        # эти двое нужны для компиляции расширения postgres js-query
        bison \ 
        flex \
        # джентельменский набор для работы с postgres
        libpq5 \
        libpq-dev \
        postgresql-server-dev-9.5 \
        postgresql-client-9.5 \
        # утилита пробрасывает сокет на tcp порт
        socat \
        python3-pip && \
    pip3 install --upgrade pip && \
    pip install \
        ansible==${ANSIBLE_VERSION} \
        docker \
        psycopg2-binary && \
    pip install \
        ipmt && \
    pip install \
        docker-compose

RUN sed -i 's/Port 22/Port 2222/' /etc/ssh/sshd_config && \
    mkdir /root/.ssh;chown -R root:root /root/.ssh;chmod -R 700 /root/.ssh && \
    mkdir /var/run/sshd

WORKDIR /ansible/art
ENTRYPOINT ["/ansible/art/files/init_script"]

