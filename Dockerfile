FROM cgr.dev/chainguard/go:latest
RUN GOBIN=/home/nonroot go install github.com/google/go-containerregistry/cmd/registry@latest
ENTRYPOINT ["/home/nonroot/registry", "-port", "5000"]
