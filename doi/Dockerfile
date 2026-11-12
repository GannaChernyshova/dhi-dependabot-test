# syntax=docker/dockerfile:1
#
# Option 0: Docker Official Image (DOI) node on both stages, for comparison
# with the DHI variants. curl and wget are installed with apt-get in the build stage.

# ---- build stage --------------------------------------------------------
FROM node:26-trixie AS build

RUN apt-get update && apt-get install -y --no-install-recommends curl wget && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --chmod=644 app/package.json ./
RUN npm install --omit=dev
COPY --chmod=644 app/server.js ./

# ---- runtime stage ------------------------------------------------------
FROM build AS runtime

WORKDIR /app
COPY --from=build /app ./

ENV BASE_IMAGE="DOI base image"

EXPOSE 3000
CMD ["node", "server.js"]
