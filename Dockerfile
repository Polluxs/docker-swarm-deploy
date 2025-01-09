FROM alpinelinux/docker-cli:latest

LABEL maintainer="polluxs" \
   org.label-schema.name="swarminator" \
   org.label-schema.description="Deploy docker swarm" \
   org.label-schema.vendor="polluxs" \
   org.opencontainers.image.source="https://github.com/polluxs/swarminator" \
   org.label-schema.docker.cmd="docker run -rm -v "${PWD}":/github/workspace ghcr.io/polluxs/swarminator"

RUN apk add --no-cache openssh-client findutils bash expect

COPY scripts/*.sh /

WORKDIR /github/workspace

ENTRYPOINT [ "/docker-entrypoint.sh" ]
