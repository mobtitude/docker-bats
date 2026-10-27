# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
FROM docker.io/library/alpine:3.24.3 AS builder

ARG CURL_VERSION=8.23.0-r0
# https://github.com/bats-core/bats-core/releases/latest
ARG BATS_CORE_VERSION=1.14.0
# https://github.com/bats-core/bats-support/releases/latest
ARG BATS_SUPPORT_VERSION=0.3.0
# https://github.com/bats-core/bats-assert/releases/latest
ARG BATS_ASSERT_VERSION=2.2.4
# https://github.com/bats-core/bats-file/releases/latest
ARG BATS_FILE_VERSION=0.4.0
# https://github.com/mh182/bats-mock/releases/latest
ARG BATS_MOCK_VERSION=0.2.1

RUN apk --no-cache add curl=${CURL_VERSION}

WORKDIR /tmp
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
RUN curl -fsSL https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/bats-core/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/bats-core/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/bats-core/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/mh182/bats-mock/archive/v${BATS_MOCK_VERSION}.tar.gz | tar xzv

###############################################################################
# FINAL IMAGE
###############################################################################
FROM docker.io/library/alpine:3.24.3

ARG BASH_VERSION=5.3.9-r1
ARG PARALLEL_VERSION=20260322-r0
ARG NCURSES_VERSION=6.6_p20260516-r0
ARG JQ_VERSION=1.8.2-r0

RUN apk --no-cache add bash=${BASH_VERSION} parallel=${PARALLEL_VERSION} ncurses=${NCURSES_VERSION} jq=${JQ_VERSION}

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
COPY --from=builder /tmp/bats-mock-* /opt/bats-mock

RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

RUN set -ex; \
    addgroup -g 65532 nonroot; \
    adduser -h /home/nonroot -g nonroot -s /sbin/nologin -G nonroot -D -u 65532 nonroot; \
    mkdir -p /home/nonroot/.parallel; \
    touch /home/nonroot/.parallel/will-cite; \
    chown -R nonroot:nonroot /home/nonroot/.parallel

USER 65532:65532
WORKDIR /work

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["--help"]
