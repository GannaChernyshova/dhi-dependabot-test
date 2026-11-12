# syntax=docker/dockerfile:1
#
# Option 1: stock DHI dev image. curl and wget are installed with apt-get in the
# build stage.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-debian13-dev@sha256:c765f9fd629d5204e6f06e7d599fbc977bdfa1f14450a8c35b7e1b8690b8e68b AS build

RUN apt-get update && apt-get install -y --no-install-recommends curl wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-debian13@sha256:d505be133e87522ebee07e8e2693955817b4ad4787d65fb99946124cc1e8f0a4 AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
