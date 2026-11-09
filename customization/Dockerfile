# syntax=docker/dockerfile:1
#
# Option 2: customized DHI dev image (see customization.yaml). curl and wget are
# already installed, so there is no apk step.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine-dev_tools@sha256:6163d755e4774635b266d8bb1f15e8d747f62ec141a0643729c428a60b03bccd AS build

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24@sha256:732b7f53f1a10df0c4e8ded0af55fadb6c0c778c987d2c855755b72a1cc85a86 AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="customized DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
