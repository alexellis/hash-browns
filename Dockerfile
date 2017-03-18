FROM golang:1.7.4
RUN mkdir -p /go/src/github.com/alexellis/hash-browns/
WORKDIR /go/src/github.com/alexellis/hash-browns/

RUN go get -d -v github.com/gorilla/mux && \
    go get -d -v github.com/prometheus/client_golang/prometheus

COPY server.go .
RUN go build -o server

EXPOSE 8080

CMD ["./server"]