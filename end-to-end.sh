#!/usr/bin/env bash

./start-registry.sh
./build-schema.sh
./push-schema.sh
./build-collection.sh
./push-collection.sh
./pull.sh
ls output