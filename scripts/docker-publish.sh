#!/bin/bash


for p in "$@"; do
    target="${p#hydra-}"
    version=$(node -p "require('./lerna.json').version")
    major=$(echo $version | cut -d '.' -f1)

    docker buildx use $BUILDER_NAME
    docker buildx build . --platform "linux/amd64,linux/arm64" \
        --push \
        --target "$target" \
        -t mashulgin/${p}:${version} \
        -t mashulgin/${p}:${major} \
        -t mashulgin/${p}:${release:-next} || exit 1
done
