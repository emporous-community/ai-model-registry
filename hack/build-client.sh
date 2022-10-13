#!/usr/bin/env bash

# clone repo
git clone https://github.com/uor-framework/uor-client-go && cd uor-client-go

# build client
goreleaser build --skip-validate --skip-before --single-target

# copy binary to host
cp ./dist/uor-client-go-linux-amd64 ../dist/client
