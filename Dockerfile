# syntax=docker/dockerfile:1

# Dependabot keeps the tag and the pinned digest below up to date.
FROM demonstrationorg/dhi-node:26-debian13@sha256:29d425d096403cca2750ee83fa31e4a6f25a73ea78089382578053d1682afaff

WORKDIR /app
COPY package.json server.js ./

EXPOSE 3000
CMD ["node", "server.js"]
