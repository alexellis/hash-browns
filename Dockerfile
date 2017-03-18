FROM golang:1.7.4
RUN mkdir -p /go/src/github.com/alexellis/hash-browns/
WORKDIR /go/src/github.com/alexellis/hash-browns/
COPY server.go .
RUN go get
RUN go build -o server

EXPOSE 8080

CMD ["./server"]