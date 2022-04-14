#!/bin/bash


for p in "$@"; do
    target="${p#hydra-}"
    version=$(node -p "require('./lerna.json').version")
    major=$(echo $version | cut -d '.' -f1)

    docker buildx build . --platform "linux/amd64,linux/arm64" \
        --push \
        --target "$target" \
        -t subsquid/${p}:${version} \
        -t subsquid/${p}:${major} \
        -t subsquid/${p}:${release:-next} || exit 1
done
