# Building stage
# Start from a Debian image with the latest version of Go installed
# and a workspace (GOPATH) configured at /go.
FROM golang as builder

LABEL maintainer="Josh Ellithorpe <quest@mac.com>"

# Copy the local package files to the container's workspace.
#ADD . /go/src/github.com/gcash/bchd

# Instead of ADD do a clone
RUN mkdir -p /go/src/github.com/gcash
RUN curl -L https://github.com/gcash/bchd/archive/refs/tags/v0.19.0.tar.gz | tar -xzf - -C /go/src/github.com/gcash && \
    mv /go/src/github.com/gcash/bchd-0.19.0 /go/src/github.com/gcash/bchd

# Switch to the correct working directory.
WORKDIR /go/src/github.com/gcash/bchd

# Build the code and the cli client.
RUN go install .
RUN go install ./cmd/bchctl

#Build the proxy gateway
RUN cd bchrpc/proxy && make
# Symlink the config to /root/.bchd/bchd.conf
# so bchctl requires fewer flags.
RUN mkdir -p /root/.bchd
RUN ln -s /etc/bchd.conf /root/.bchd/bchd.conf
RUN ln -s /data/pki/server.crt /root/.bchd/rpc.cert

# Final stage
FROM ubuntu:latest

LABEL maintainer="Josh Ellithorpe <quest@mac.com>"

# Copy necessary files
COPY --from=builder /go/bin/bchd /usr/local/bin/bchd
COPY --from=builder /go/bin/bchctl /usr/local/bin/bchctl
COPY --from=builder /go/src/github.com/gcash/bchd/bchrpc/proxy/gw /usr/local/bin/gw
COPY --from=builder /root /root
COPY --from=builder /go/src/github.com/gcash/bchd/bchrpc/proxy/web /proxy/web
COPY bchd.conf /etc/bchd.conf
# Create the data volume.
VOLUME ["/data"]

# Set the start command. This starts bchd with
# flags to save the blockchain data and the
# config on a docker volume.
#ENTRYPOINT ["bchd", "--addrindex", "--txindex", "-b", "/data", "-C", "/data/bchd.conf"]

# Document that the service listens on port 8333.
EXPOSE 8333
