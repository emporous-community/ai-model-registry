#!/usr/bin/env bash

# Clone Repo
git clone https://github.com/uor-framework/uor-client-go && cd uor-client-go

# build client
goreleaser build --skip-validate --skip-before --single-target

# Return to basedir
#cd ..

cp ./dist/uor-client-go-$GOOS-arm64 ./dist/client
