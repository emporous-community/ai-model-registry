cat <<EOF > Dockerfile && docker build -t registry . && docker run -d -p 5000:5000 --name registry registry
FROM --platform=x86_64 cgr.dev/chainguard/go:latest as build
RUN GOBIN=/home/nonroot go install github.com/google/go-containerregistry/cmd/registry@latest

FROM --platform=x86_64 cgr.dev/chainguard/go:latest

COPY --from=build /home/nonroot/registry /registry
EXPOSE 1338
ENTRYPOINT ["/registry", "-port", "5000"]
EOF

git clone https://github.com/usrbinkat/uor-ai-model-registry ai-model-registry && cd ai-model-registry

docker run --rm -it \
          -v $(pwd)/dist/:/go/dist \
          -v $(pwd)/hack/build-client.sh:/go/build-client.sh \
          -e GOOS=$(uname | uname -s | awk '{print tolower($0)}') \
          -e GITHUB_REPOSITORY_OWNER=local \
          --entrypoint ./build-client.sh \
        goreleaser/goreleaser

./dist/client version

./dist/client build schema mr-schema-config.yaml localhost:5000/mrschema:latest

./dist/client push --plain-http=true localhost:5000/mrschema:latest

source variables 
./dist/client build collection collection/  localhost:5000/test/mrtest:latest --dsconfig ./mr-ds-out.yaml --plain-http=true

./dist/client push localhost:5000/test/mrtest:latest --plain-http=true

curl localhost:5000/v2/test/mrtest/manifests/latest | jq

./dist/client pull  localhost:5000/test/mrtest:latest -o /tmp/pull --plain-http=true --no-verify=true --attributes mr-attributes.yam

cat /tmp/pull/model.pkl