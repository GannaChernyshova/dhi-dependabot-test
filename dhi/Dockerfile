# syntax=docker/dockerfile:1
#
# Option 1: stock DHI dev image. curl and wget are installed with apk in the
# build stage.

# ---- build stage --------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24-dev@sha256:b1968ad63fbbcbbea96cf552a1ccd13f60034d42606e06122513f4fd3f971737 AS build

RUN apk add --no-cache curl wget

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM demonstrationorg/dhi-node-anna:26-alpine3.24@sha256:732b7f53f1a10df0c4e8ded0af55fadb6c0c778c987d2c855755b72a1cc85a86 AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="DHI base image"

EXPOSE 3000
CMD ["node", "server.js"]
