#!/usr/bin/env bash

# clone repo

git clone https://github.com/emporous/emporous-go && cd emporous-go

# build client
goreleaser build --skip-validate --skip-before --single-target

# copy binary to host
cp ./dist/emporous-linux-amd64 ../dist/emporous