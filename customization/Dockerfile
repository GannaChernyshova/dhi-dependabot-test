# syntax=docker/dockerfile:1
#
# Option 2: customized DHI dev image (see customization.yaml). curl and wget are
# already installed, so there is no apt-get step.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-debian13-dev_tools AS build

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-debian13 AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="Customized DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
