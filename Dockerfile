# syntax=docker/dockerfile:1

# Dependabot keeps the tag and the pinned digest below up to date.
FROM demonstrationorg/dhi-node:26-debian13-sfw-ent-dev@sha256:f70a23e74f3d2900a6a3dd789186f2c2e0212bce4f643c4ab90c048f872450d7

# Verifies the package manager works on this base image.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json server.js ./

EXPOSE 3000
CMD ["node", "server.js"]
