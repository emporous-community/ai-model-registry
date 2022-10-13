#!/usr/bin/env bash

source variables 
./uor-client-go-linux-amd64 build collection collection/  localhost:5000/test/mrtest:latest --dsconfig ./mr-ds-out.yaml --plain-http=true
