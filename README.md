# docker-build-env
Dfinity specific build environment C, Go, Python

## Run

### Go

Example:
```docker run --rm -it -v `pwd`/go:/go dfinity/build-env go run <go-file>```

#### Linters

Run `go install` first.

Run selected linters:
```gometalinter --disable-all --enable=vet```

Increase deadline
```gometalinter --deadline=10s```
