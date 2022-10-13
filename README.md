# AI/ML Model Secure Publishing

This demonstration uses the [UOR Framework reference cli](https://github.com/uor-framework/uor-client-go) to publish a machine learning (ML) model and associated artifacts directly to a container registry.

> NOTICE: demo currently written for Linux x86_64

### Publish Artifacts

Publish the following ML artifacts to a container registry as a UOR "collection". We will also sign the artifacts and publish signature certificates to establish provenance of the model's origin.

### Retrieve Artifacts

Download the ML model and verify the pulled contents.

### Collection Contents:
1. [model.pkl](./collection/model.pkl) ([Pickle file](https://docs.python.org/3/library/pickle.html#module-pickle))
1. [notebook.ipynb](./collection/notebook.ipynb) ([Jupyter Notebook](https://jupyter-notebook.readthedocs.io/en/stable/notebook.html#notebook-documents))
1. [random.file](./collection/random.file) (example related artifact)

## Prep

<details><summary>CLICK FOR PREREQUISITES</summary>
<p>

### 1. Create a local registry for testing (example: [go-containerregistry](https://github.com/google/go-containerregistry))

```bash
cat <<EOF > Dockerfile
FROM cgr.dev/chainguard/go:latest
RUN GOBIN=/home/nonroot go install github.com/google/go-containerregistry/cmd/registry@latest
ENTRYPOINT ["/home/nonroot/registry", "-port", "5000"]
EOF
docker build -t registry .
```
```bash
docker run -d -p 5000:5000 --name registry registry
```

### 2. Build binary from main branch (temporary)

```bash
git clone https://github.com/uor-community/ai-model-registry ai-model-registry && cd ai-model-registry
```

```bash
docker run --rm -it --privileged \
          -v $(pwd)/dist/:/go/dist \
          -v $(pwd)/hack/build-client.sh:/go/build-client.sh \
          -e GOOS=$(uname | uname -s | awk '{print tolower($0)}') \
          -e GITHUB_REPOSITORY_OWNER=local \
          --entrypoint ./build-client.sh \
        goreleaser/goreleaser
```

### 3. Verify client binary

```bash
./dist/client version
```

</p>
</details>

## Demo
### 1. Build collection schema

```bash
./dist/client build schema mr-schema-config.yaml localhost:5000/mrschema:latest
```

### 2. Publish Schema

- (optional) use the `--sign` flag as well to sign collection with sigstore

```bash
./dist/client push --plain-http=true localhost:5000/mrschema:latest
```

### 3. Build collection

```bash
source variables 
./dist/client build collection collection/  localhost:5000/test/mrtest:latest --dsconfig ./mr-ds-out.yaml --plain-http=true
```

### 4. Publish collection

- (optional) use the `--sign` flag as well to sign collection with sigstore

```bash
./dist/client push localhost:5000/test/mrtest:latest --plain-http=true
```

### 5. Check manifest

```bash
curl localhost:5000/v2/test/mrtest/manifests/latest | jq
```

<details><summary>CLICK FOR EXAMPLE</summary>
<e>

```bash
{
  "schemaVersion": 2,
  "mediaType": "application/vnd.oci.image.manifest.v1+json",
  "config": {
    "mediaType": "application/vnd.uor.config.v1+json",
    "digest": "sha256:478a694317a07753db2de5c74c9838390bcaee24dff20ffe2f88e3ce90495828",
    "size": 883
  },
  "layers": [
    {
      "mediaType": "text/plain; charset=utf-8",
      "digest": "sha256:10d77b9b5a4322cf38bb238f3a02c6410f539fd11dc9545fac2ade20ab39368f",
      "size": 18,
      "annotations": {
        "org.opencontainers.image.title": "random.file"
      }
    },
    {
      "mediaType": "text/plain; charset=utf-8",
      "digest": "sha256:214ebd05c7f7e74f53a630a8a020c88061ea776b650a5f64dc8997ef9a71ab75",
      "size": 5,
      "annotations": {
        "org.opencontainers.image.title": "model.pkl",
        "uor.attributes": "{\"model\":true,\"model_bstch_size\":37,\"model_epochs\":44,\"model_load_weights\":\"done\",\"model_loss\":\"bar\",\"model_name\":\"test\",\"model_optimizer\":\"baz\",\"model_precision\":\"3.2\",\"model_return_sequences\":\"another\",\"model_save_weights\":\"idk\",\"model_shuffle\":\"other\",\"model_type\":\"foo\",\"model_verbose\":3,\"model_version\":\"3.2.1\",\"notebook\":false}"
      }
    },
    {
      "mediaType": "application/json",
      "digest": "sha256:23be9aed68166a1997b4396a6549f028d946b33fc2b68d56b8c297b84e973ebc",
      "size": 270,
      "annotations": {
        "org.opencontainers.image.title": "notebook.ipynb",
        "uor.attributes": "{\"model\":false,\"model_bstch_size\":37,\"model_epochs\":44,\"model_load_weights\":\"done\",\"model_loss\":\"bar\",\"model_name\":\"test\",\"model_optimizer\":\"baz\",\"model_precision\":\"3.2\",\"model_return_sequences\":\"another\",\"model_save_weights\":\"idk\",\"model_shuffle\":\"other\",\"model_type\":\"foo\",\"model_verbose\":3,\"model_version\":\"3.2.1\",\"notebook\":true}"
      }
    }
  ],
  "annotations": {
    "uor.schema": "localhost:5000/mrschema:latest"
  }
}
```

</e>
</details>

### 6. Pull specific object by it's `name` attribute

```bash
./dist/client pull  localhost:5000/test/mrtest:latest -o /tmp/pull --plain-http=true --no-verify=true --attributes mr-attributes.yaml

cat /tmp/pull/model.pkl
```
