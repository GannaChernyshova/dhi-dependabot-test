# syntax=docker/dockerfile:1

# Replace REPLACE_NAMESPACE and the digest below with your real DHI Node image
# reference — get it with:
#   docker pull REPLACE_NAMESPACE/dhi-node:22
#   docker inspect --format='{{index .RepoDigests 0}}' REPLACE_NAMESPACE/dhi-node:22
FROM REPLACE_NAMESPACE/dhi-node:22@sha256:REPLACE_WITH_REAL_DIGEST

WORKDIR /app
COPY package.json server.js ./

EXPOSE 3000
CMD ["server.js"]
