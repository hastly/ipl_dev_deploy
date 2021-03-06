#!/usr/bin/env bash
# env.sh

export IPL_DEV_DEPLOY_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"
export IPL_DEV_DEPLOY_ROOT="$(echo $IPL_DEV_DEPLOY_ROOT | tail -1)"

export IPL_DEV_DEPLOY_HOST_PK="~/.ssh/ip_gitlab_pk"
export IPL_DEV_DEPLOY_HOST_UID="$(id -u)"
export IPL_DEV_DEPLOY_HOST_GUID="$(id -g)"
export IPL_DEV_DEPLOY_PROXY_SSH_PORT=2222

export IPL_DEV_DEPLOY_PG_VERSION=9.5.9
export IPL_DEV_DEPLOY_PG_USER=postgres
export IPL_DEV_DEPLOY_PG_PASSWORD=qweasdzxc
export IPL_DEV_DEPLOY_PG_DATA=/data/postgres

export IPL_DEV_DEPLOY_GITLAB_URL=gitlab.app.ipl
export IPL_DEV_DEPLOY_GITLAB_PATH_API=db/api
