#!/bin/bash

docker run -it --rm \
    -p 127.0.0.1:8080:4567 \
    -e MONGODB_HOST=db \
    -e MONGODB_PORT=27017 \
    --name c_ipam \
    lpfi/c_ipam
