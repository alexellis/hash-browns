FROM golang:1.10.4 as build

WORKDIR /go/src/github.com/alexellis/hash-browns/

COPY vendor     vendor
COPY server.go  .

RUN CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags "-s -w" -o /usr/bin/server

FROM alpine:3.9

COPY --from=build /usr/bin/server /root/

EXPOSE 8080
WORKDIR /root/

CMD ["./server"]
