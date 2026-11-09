# syntax=docker/dockerfile:1
#
# Option 0: Docker Official Image (DOI) node on both stages, for comparison
# with the DHI variants. curl and wget are installed with apk in the build stage.

# ---- build stage --------------------------------------------------------
FROM node:26-alpine3.24 AS build

RUN apk add --no-cache curl wget

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM build AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="DOI base image"

USER node
EXPOSE 3000
CMD ["node", "server.js"]
