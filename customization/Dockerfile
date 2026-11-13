# syntax=docker/dockerfile:1
#
# Option 2: customized DHI dev image (see customization.yaml). curl and wget are
# already installed, so there is no apk step.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine-dev_tools@sha256: AS build

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24@sha256:f7b40a7a5e3b75dafd68687f9f5cd4989a2ca02a5004e03147596e7bf8653acc AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="customized DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
