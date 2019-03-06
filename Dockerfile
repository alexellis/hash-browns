FROM golang:1.11 as build

WORKDIR /go/src/github.com/alexellis/hash-browns/

COPY vendor     vendor
COPY server.go  .

RUN CGO_ENABLED=0 go build -a -installsuffix cgo --ldflags "-s -w" -o /usr/bin/server

FROM alpine:3.9
RUN addgroup -S app && adduser -S -g app app

COPY --from=build /usr/bin/server /usr/bin/server
RUN chown -R app /home/app

USER app
WORKDIR /home/app

EXPOSE 8080
CMD ["server"]
