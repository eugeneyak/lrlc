## LRLC

### Build

    docker login ghcr.io
    docker buildx build --platform linux/amd64 --tag ghcr.io/eugeneyak/lrlc --push .

### Upgrade ruby version

    mise use ruby@3.4.1