FROM alpine:3.18 as builder

# Install dependencies
RUN apk add --no-cache curl alpine-sdk

ARG VERSION=3.57

WORKDIR /root
RUN curl -L https://download.inlab.net/Balance/$VERSION/balance-$VERSION.tar | tar -xv --strip-components=2
RUN make CFLAGS="-static -Os -s"
RUN mkdir -p /var/run/balance

FROM scratch
COPY --from=builder /root/balance /balance
COPY --from=builder /var/run/balance /var/run/balance

ENTRYPOINT ["/balance"]
