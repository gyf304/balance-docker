FROM alpine:3.18 as builder

ARG VERSION=3.57

RUN apk add --no-cache cmake curl alpine-sdk

WORKDIR /root/balance
RUN curl -L "https://download.inlab.net/Balance/$VERSION/balance-$VERSION.tar" | tar -xv --strip-components=2
COPY *.patch ./
RUN cat *.patch | patch
RUN make CFLAGS="-static -Os -s"
RUN mkdir -p /var/run/balance

FROM scratch

COPY --from=builder /root/balance/balance /balance
COPY --from=builder /var/run/balance /var/run/balance

ENTRYPOINT ["/balance", "-f"]
