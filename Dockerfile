FROM golang:1.26.4-alpine

RUN apk update
RUN apk add git
RUN apk add curl
RUN go install github.com/air-verse/air@latest
RUN go clean -cache -modcache

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/entrypoint.sh"]
