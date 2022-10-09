#!/usr/bin/env bash

./uor-client-go-linux-amd64 push localhost:5001/test/mrtest:latest --plain-http=true
curl localhost:5001/v2/test/mrtest/manifests/latest | jq