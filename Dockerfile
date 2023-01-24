FROM --platform=x86_64 cgr.dev/chainguard/go:latest as build
RUN GOBIN=/home/nonroot go install github.com/google/go-containerregistry/cmd/registry@latest

FROM --platform=x86_64 cgr.dev/chainguard/go:latest

COPY --from=build /home/nonroot/registry /registry
EXPOSE 1338
ENTRYPOINT ["/registry", "-port", "5000"]
