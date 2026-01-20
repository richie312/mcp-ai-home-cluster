FROM alpine:latest

RUN apk add --no-cache \
    bash \
    yq \
    openssh-client \
    docker-cli

WORKDIR /executor

COPY entrypoint.sh /executor/entrypoint.sh
COPY ../configs/deployment.yaml /executor/deployment.yaml

RUN chmod +x /executor/entrypoint.sh

ENTRYPOINT ["/executor/entrypoint.sh"]
