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

### a. Create a local registry for testing

```bash
docker run --rm -d --name registry registry
```

### b. Build binary from main branch (temporary)

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
mv dist/client .
./client version
```

### d. Build collection schema

```bash
./client build schema mr-schema-config.yaml localhost:5000/mrschema:latest
```

### e. Publish Schema

```bash
./client push --plain-http=true localhost:5000/mrschema:latest
```

### c. 

```bash
```

### c. 

```bash
```

### c. 

```bash
```

### c. 

```bash
```
