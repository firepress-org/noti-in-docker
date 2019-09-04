# Those are required by Github Action CI
ARG VERSION="3.2.0-r2"
ARG APP_NAME="noti"
#
ARG ALPINE_VERSION="3.10"
ARG USER="onfire"
#
ARG DOCKERHUB_USER="devmtl"
ARG GITHUB_USER="firepress"
ARG GITHUB_ORG="firepress-org"
ARG GITHUB_REGISTRY="registry"
#
ARG GIT_REPO_URL="https://github.com/firepress-org/noti-in-docker"
ARG GIT_REPO_SOURCE="https://github.com/variadico/noti"

# GNU v3 | Please credit my work if you are re-using some of it :)
# by Pascal Andy | https://pascalandy.com/blog/now/

# ----------------------------------------------
# BUILDER LAYER
# ----------------------------------------------
FROM golang:alpine${ALPINE_VERSION} AS gobuilder

ARG VERSION
ARG APP_NAME
ARG USER
ARG GIT_REPO_SOURCE

ENV VERSION="${VERSION}"
ENV APP_NAME="${APP_NAME}"
ENV USER="${USER}"
ENV GIT_REPO_SOURCE="${GIT_REPO_SOURCE}"

# Install common utilities
RUN set -eux && apk --update --no-cache add \
    bash wget curl git openssl ca-certificates upx
# Install common Go dependencies
RUN set -eux && apk --update --no-cache add \
    -t build-deps libc-dev gcc libgcc

# Download source
WORKDIR /go/src/github.com/variadico/noti
RUN set -eux && git clone "${GIT_REPO_SOURCE}" --single-branch --depth 1 -b "${VERSION}" . && \
    git checkout -b "${VERSION}"

# Compile
WORKDIR /go/src/github.com/variadico/noti/cmd/noti
RUN set -eux && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GOFLAGS="-mod=vendor" \
    go build -o /usr/local/bin/"${APP_NAME}"

# Compress
RUN set -eux && upx /usr/local/bin/"${APP_NAME}" && \
    upx -t /usr/local/bin/"${APP_NAME}" && \
    "${APP_NAME}" --version

# Create a non-root user
RUN set -eux && addgroup -S grp_"${USER}" && \
    adduser -S "${USER}" -G grp_"${USER}" && \
    chown "${USER}":grp_"${USER}" /usr/local/bin/"${APP_NAME}"


# ----------------------------------------------
# FINAL LAYER
# ----------------------------------------------
FROM alpine:${ALPINE_VERSION} AS final

ARG VERSION
ARG APP_NAME
ARG USER
ARG ALPINE_VERSION
ARG GIT_REPO_URL

ENV VERSION="${VERSION}"
ENV APP_NAME="${APP_NAME}"
ENV USER="${USER}"
ENV ALPINE_VERSION="${ALPINE_VERSION}"

ENV GIT_REPO_URL="${GIT_REPO_URL}"
ENV CREATED_DATE="$(date "+%Y-%m-%d_%HH%Ms%S")"
ENV SOURCE_COMMIT="$(git rev-parse --short HEAD)"

# Best practice credit: https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="${APP_NAME}"                                              \
      org.opencontainers.image.version="${VERSION}"                                             \
      org.opencontainers.image.description="See README.md"                                      \
      org.opencontainers.image.authors="Pascal Andy https://firepress.org/en/contact/"          \
      org.opencontainers.image.created="${CREATED_DATE}"                                        \
      org.opencontainers.image.revision="${SOURCE_COMMIT}"                                      \
      org.opencontainers.image.source="${GIT_REPO_URL}"                                  \
      org.opencontainers.image.licenses="GNUv3. See README.md"                                  \
      org.firepress.image.user="usr_${APP_NAME}"                                                \
      org.firepress.image.alpineversion="{ALPINE_VERSION}"                                      \
      org.firepress.image.field1="not_set"                                                      \
      org.firepress.image.field2="not_set"                                                      \
      org.firepress.image.schemaversion="1.0"

# Install basics + non-root user
RUN set -eux && apk --update --no-cache add \
    ca-certificates tini && \
    #
    addgroup -S grp_"${USER}" && \
    adduser -S "${USER}" -G grp_"${USER}"

COPY --from=gobuilder --chown="${USER}":grp_"${USER}" /usr/local/bin/"${APP_NAME}" /usr/local/bin/"${APP_NAME}"
WORKDIR /usr/local/bin
USER "${USER}"
ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "noti" ]
