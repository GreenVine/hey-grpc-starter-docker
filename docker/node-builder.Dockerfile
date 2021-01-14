ARG BASE_IMAGE=hey-grpc-base-builder
ARG BASE_IMAGE_TAG=latest
ARG NODE_VERSION=14

### Base Image ###
FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} AS base
LABEL maintainer="Robin Liu <opensource@greenvine.dev>"
ARG NODE_VERSION

### Builder Image ###
FROM node:${NODE_VERSION}-alpine AS builder

WORKDIR /workspace

RUN apk add --update --no-cache ca-certificates grpc protobuf \
    && rm -rf /var/cache/apk/*

COPY --from=base /usr/local/bin /usr/local/bin
COPY --from=base /usr/include /usr/include

ENV TS_PROTOC_VERSION=0.14.0
RUN yarn global add "ts-protoc-gen@${TS_PROTOC_VERSION}" \
    && yarn cache clean --all

ENV PROTOTOOL_PROTOC_BIN_PATH=/usr/bin/protoc \
    PROTOTOOL_PROTOC_WKT_PATH=/usr/include

ENTRYPOINT ["prototool"]
