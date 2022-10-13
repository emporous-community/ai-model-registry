# AI/ML Model Secure Publishing

This demonstration uses the [UOR Framework reference cli](https://github.com/uor-framework/uor-client-go) to publish a machine learning (ML) model and associated artifacts directly to a container registry.

## Demo

### Publish Artifacts

Publish the following ML artifacts to a container registry as a UOR "collection". We will also sign the artifacts and publish signature certificates to establish provenance of the model's origin.

### Retrieve Artifacts

Download the ML model and verify the pulled contents.

### Collection Contents:
1. [model.pkl](./collection/model.pkl) ([Pickle file](https://docs.python.org/3/library/pickle.html#module-pickle))
1. [notebook.ipynb](./collection/notebook.ipynb) ([Jupyter Notebook](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html#notebook-documents))
1. [random.file](./collection/random.file) (example related artifact)

## Step 1. Prep

### a. Create a local registry for testing (example: [go-containerregistry](https://github.com/google/go-containerregistry))

```bash
cat <<EOF > Dockerfile && docker build -t registry . && docker run -d -p 5000:5000 --name registry registry
FROM --platform=x86_64 cgr.dev/chainguard/go:latest as build
RUN GOBIN=/home/nonroot go install github.com/google/go-containerregistry/cmd/registry@latest

FROM --platform=x86_64 cgr.dev/chainguard/go:latest

COPY --from=build /home/nonroot/registry /registry
EXPOSE 1338
ENTRYPOINT ["/registry", "-port", "5000"]
EOF
```

### b. Build binary from main branch (temporary)

```bash
git clone https://github.com/usrbinkat/uor-ai-model-registry ai-model-registry && cd ai-model-registry
```

```bash
docker run --rm -it \
          -v $(pwd)/dist/:/go/dist \
          -v $(pwd)/hack/build-client.sh:/go/build-client.sh \
          -e GOOS=$(uname | uname -s | awk '{print tolower($0)}') \
          -e GITHUB_REPOSITORY_OWNER=local \
          --entrypoint ./build-client.sh \
        goreleaser/goreleaser
```

### c. Verify client binary

```bash
./dist/client version
```

### d. Build collection schema

```bash
./dist/client build schema mr-schema-config.yaml localhost:5000/mrschema:latest
```

### e. Publish Schema

```bash
./dist/client push --plain-http=true localhost:5000/mrschema:latest
```

### f. Build collection

```bash
source variables 
./dist/client build collection collection/  localhost:5000/test/mrtest:latest --dsconfig ./mr-ds-out.yaml --plain-http=true
```

### g. Push collection

```bash
./dist/client push localhost:5000/test/mrtest:latest --plain-http=true
```

### h. Check manifest

```bash
curl localhost:5000/v2/test/mrtest/manifests/latest | jq
```

### i. Pull specific object by it's `name` attribute

```bash
./dist/client pull  localhost:5000/test/mrtest:latest -o /tmp/pull --plain-http=true --no-verify=true --attributes mr-attributes.yam

cat /tmp/pull/model.pkl
```