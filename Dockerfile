FROM golang:1.9.6 as build
RUN mkdir -p /go/src/github.com/alexellis/hash-browns/
WORKDIR /go/src/github.com/alexellis/hash-browns/

RUN go get -d -v github.com/gorilla/mux && \
    go get -d -v github.com/prometheus/client_golang/prometheus

COPY server.go .

RUN CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags "-s -w" -o /usr/bin/server

FROM alpine:3.7

COPY --from=build /usr/bin/server /root/

EXPOSE 8080
WORKDIR /root/

CMD ["./server"]
