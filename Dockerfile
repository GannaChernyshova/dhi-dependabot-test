# syntax=docker/dockerfile:1

# Dependabot keeps the tag and the pinned digest below up to date.
FROM demonstrationorg/dhi-node:26-debian13-sfw-ent-dev@sha256:598de82aa0b7e6b329fcb16d0e23b1441d472c15f591a5cabbd4f82eeb6dce79

# Verifies the package manager works on this base image.
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY package.json server.js ./

EXPOSE 3000
CMD ["node", "server.js"]
