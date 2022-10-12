# Build
FROM goreleaser/goreleaser as build

ENV GITHUB_REPOSITORY_OWNER=local

RUN git clone https://github.com/uor-framework/uor-client-go /client

WORKDIR /client

RUN goreleaser build --skip-validate --skip-before --single-target


# Demo
FROM fedora AS demo

WORKDIR /mrdemo

COPY --from=build /client/dist/uor-client-go-linux-amd64 .

RUN dnf install -y go gettext jq 

RUN GOBIN=$PWD go install github.com/google/go-containerregistry/cmd/registry@latest

COPY ./ .

ENTRYPOINT [ "./end-to-end.sh" ]

