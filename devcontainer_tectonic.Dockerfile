FROM jnnksdev/devcontainer_rust:latest

# install tectonic
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
        libfontconfig1-dev libgraphite2-dev libharfbuzz-dev libicu-dev libssl-dev zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

RUN cargo install tectonic
