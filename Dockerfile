FROM --platform=linux/amd64 ubuntu:24.04 AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential cmake

ADD . /repo
WORKDIR /repo
RUN cmake -S . -B build && cmake --build build --parallel 8

RUN mkdir -p /deps
RUN ldd /repo/build/cmd/i-use-arch-btw | tr -s '[:blank:]' '\n' | grep '^/' | xargs -I % sh -c 'cp % /deps;'

FROM ubuntu:24.04 AS package

COPY --from=builder /deps /deps
COPY --from=builder /repo/build/cmd/i-use-arch-btw /repo/build/cmd/i-use-arch-btw
ENV LD_LIBRARY_PATH=/deps
