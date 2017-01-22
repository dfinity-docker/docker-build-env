# docker-build-env
Dfinity specific build environment C, Go, Python

## Run

Example (Go):
```docker run --rm -it -v `pwd`/go:/go dfinity/build-env go run <go-file>```

Run selected linters:
```gometalinter --disable-all --enable=vet```
