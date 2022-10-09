#!/usr/bin/env bash

./uor-client-go-linux-amd64 pull  localhost:5001/test/mrtest:latest -o output --plain-http=true --no-verify=true --attributes mr-attributes.yaml