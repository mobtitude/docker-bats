# SPDX-License-Identifier: MIT

###############################################################################
# BUILD STAGE
###############################################################################
FROM docker.io/library/alpine:3.22.2 AS builder

ARG CURL_VERSION=8.14.1-r3
# https://github.com/bats-core/bats-core/releases/latest
ARG BATS_CORE_VERSION=1.8.1
# https://github.com/ztombol/bats-support/releases/latest
ARG BATS_SUPPORT_VERSION=0.3.0
# https://github.com/ztombol/bats-assert/releases/latest
ARG BATS_ASSERT_VERSION=0.3.0
# https://github.com/ztombol/bats-file/releases/latest
ARG BATS_FILE_VERSION=0.2.0
# https://github.com/mh182/bats-mock/releases/latest
ARG BATS_MOCK_VERSION=0.2.0

RUN apk --no-cache add curl=${CURL_VERSION}

WORKDIR /tmp
SHELL ["/bin/ash", "-euxo", "pipefail", "-c"]
RUN curl -fsSL https://github.com/bats-core/bats-core/archive/v${BATS_CORE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-support/archive/v${BATS_SUPPORT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-assert/archive/v${BATS_ASSERT_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/ztombol/bats-file/archive/v${BATS_FILE_VERSION}.tar.gz | tar xzv; \
    curl -fsSL https://github.com/mh182/bats-mock/archive/v${BATS_MOCK_VERSION}.tar.gz | tar xzv

###############################################################################
# FINAL IMAGE
###############################################################################
FROM docker.io/library/alpine:3.22.2

ARG BASH_VERSION=5.2.37-r0
ARG PARALLEL_VERSION=20250522-r0
ARG NCURSES_VERSION=6.5_p20250503-r0

RUN set -eux; \
    apk --no-cache add bash=${BASH_VERSION} parallel=${PARALLEL_VERSION} ncurses=${NCURSES_VERSION}; \
    mkdir -p ~/.parallel; \
    touch ~/.parallel/will-cite

COPY --from=builder /tmp/bats-core-* /opt/bats-core
COPY --from=builder /tmp/bats-support-* /opt/bats-support
COPY --from=builder /tmp/bats-assert-* /opt/bats-assert
COPY --from=builder /tmp/bats-file-* /opt/bats-file
COPY --from=builder /tmp/bats-mock-* /opt/bats-mock

RUN ln -s /opt/bats-core/bin/bats /usr/local/bin/bats

RUN set -ex; \
    addgroup -g 65532 nonroot; \
    adduser -h /home/nonroot -g nonroot -s /sbin/nologin -G nonroot -D -u 65532 nonroot

USER nonroot
WORKDIR /work

ENTRYPOINT ["/usr/local/bin/bats"]
CMD ["--help"]
