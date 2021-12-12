FROM golang:1.16-alpine as build

ENV GO111MODULE=on
ENV GOFLAGS=-mod=vendor

WORKDIR /go/src/github.com/alexellis/hash-browns/

COPY go.sum   .
COPY go.mod   .
COPY main.go  .

ARG GIT_COMMIT
ARG VERSION
ARG OPTS

RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*" -not -path "./function/vendor/*"))" || { echo "Run \"gofmt -s -w\" on your Golang code"; exit 1; }

RUN CGO_ENABLED=0 go test $(go list ./... | grep -v /vendor/) -cover

# add user in this stage because it cannot be done in next stage which is built from scratch
# in next stage we'll copy user and group information from this stage
RUN env ${OPTS} CGO_ENABLED=0 go build -ldflags "-s -w -X main.GitCommit=${GIT_COMMIT} -X main.Version=${VERSION}" -a -installsuffix cgo -o /usr/bin/server

RUN addgroup -S app \
    && adduser -S -g app app

FROM scratch

COPY --from=build /etc/passwd /etc/group /etc/
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=build /usr/bin/server /usr/bin/

USER app
EXPOSE 80

ENTRYPOINT ["/usr/bin/server"]
CMD ["--help"]
