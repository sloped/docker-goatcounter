FROM golang:1.21 AS build

ARG GIT_CI_REF=master
WORKDIR /goatcounter
RUN git clone --branch=release-2.5 https://github.com/arp242/goatcounter.git .

RUN go build -tags osusergo,netgo,sqlite_omit_load_extension \
    -ldflags="-X zgo.at/goatcounter/v2.Version=$(git log -n1 --format='%h_%cI') -extldflags=-static" \
    ./cmd/goatcounter

FROM alpine:3.19


WORKDIR /goatcounter

ENV GOATCOUNTER_LISTEN '0.0.0.0:8080'
ENV GOATCOUNTER_DB 'sqlite:///conf/goatcounter.sqlite3'
ENV GOATCOUNTER_SMTP ''
ENV GOATCOUNTER_DOMAIN 'localhost'
ENV GOATCOUNTER_EMAIL 'goatcounter@localhost'
ENV GOATCOUNTER_PASSWORD 'password'

COPY --from=build /goatcounter/goatcounter /usr/bin/goatcounter
COPY goatcounter.sh ./
COPY entrypoint.sh /entrypoint.sh

RUN apk update && apk upgrade && apk add bash

EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/goatcounter/goatcounter.sh"]