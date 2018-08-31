#!/bin/bash
echo $1
docker build -t testnpmmodule6 -f Dockerfile --build-arg VERSION=$1 .
