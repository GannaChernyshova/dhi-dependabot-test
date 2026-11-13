# syntax=docker/dockerfile:1
#
# Option 1: stock DHI dev image. curl and wget are installed with apk in the
# build stage.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24-dev@sha256:16375cc385b69dbd63d19603d5ba671493294b4cd4d0e3d8132abb0562e29db5 AS build

RUN apk add --no-cache curl wget

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24@sha256:f7b40a7a5e3b75dafd68687f9f5cd4989a2ca02a5004e03147596e7bf8653acc AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
