# dhi-dependabot-test

A small Node app built three ways, to compare Docker Hardened Images (DHI) with Docker Official Images (DOI).

## Before you start

- **DHI** are minimal, low-CVE images maintained by Docker. Each comes in two variants:
  - **`-dev`**: has a shell and a package manager (`apk`). Use it to build.
  - **runtime**: no shell or package manager. Use it to run.
- **Mirror**: your org's copy of DHI images on Docker Hub, here `demonstrationorg/dhi-node-anna`.
- **Customization**: DHI builds a copy of an image with extra packages, published as a new tag in the mirror.
- **Tools**: Docker Desktop (includes `docker scout`) and
  [`dhictl`](https://github.com/docker-hardened-images/dhictl/releases) v0.0.13 or later.

```bash
docker login    # Docker Hub account with DHI access
```

```
app/                               Node app (server.js, package.json)
doi/Dockerfile                     DOI build
dhi/Dockerfile                     DHI build
customization/Dockerfile           DHI build on the customized image
customization/customization.yaml   DHI customization definition
```

Each Dockerfile has a `build` stage, which runs `npm install`, and a `runtime` stage, which runs `server.js` on
port 3000. The server reports which base image it runs on. Build from the repo root.


## 1. Dependabot

`.github/dependabot.yml` checks `dhi/` and `customization/` daily. When Docker Hub has a newer tag or digest for a
`FROM` line, it opens a PR. `.github/workflows/build.yml` builds all three Dockerfiles on every push and PR.

Add both secrets under **Actions** and **Dependabot** (Settings > Secrets and variables). Dependabot PRs only read
the Dependabot store.

| Secret | Value |
| --- | --- |
| `DHI_DOCKERHUB_USERNAME` | Docker Hub user with access to `your_DHI_org` |
| `DHI_DOCKERHUB_TOKEN` | Access token for that user, also used as `DHI_API_TOKEN` |

## 2. Compare DOI and DHI

| Dockerfile | Build stage | Runtime stage |
| --- | --- | --- |
| `doi/Dockerfile` | `node:26-alpine3.24` + `apk add curl wget` | same as build stage |
| `dhi/Dockerfile` | `dhi-node-anna:26-alpine3.24-dev` + `apk add curl wget` | `dhi-node-anna:26-alpine3.24` |

```bash
docker buildx build --provenance=true --sbom=true -f doi/Dockerfile -t demo-node:doi .
docker buildx build --provenance=true --sbom=true -f dhi/Dockerfile -t demo-node:dhi .
docker scout compare local://demo-node:dhi --to local://demo-node:doi

docker run --rm -p 3000:3000 demo-node:dhi    # curl localhost:3000
```

A local build doesn't carry DHI's VEX statements, so Scout may list CVEs that DHI marks as not affecting the image.
To see DHI's own assessment, scan the base image from the registry:
`docker scout cves demonstrationorg/dhi-node-anna:26-alpine3.24`.

## 3. Customize a DHI image

`customization/customization.yaml` adds `curl` and `wget` to `26-alpine3.24-dev` and publishes the result as
`dhi-node-anna:26-alpine-dev_tools`. `customization/Dockerfile` builds on it, with no `apk` step.

```bash
docker buildx build --provenance=true --sbom=true -f customization/Dockerfile -t demo-node:customized .
```

To change the customization, edit the yaml and keep the `id:` line, which `dhictl` uses to find it. Then either
merge to `main` or run:

```bash
export DHI_API_TOKEN=<Docker Hub access token>
dhictl customization edit --org demonstrationorg customization/customization.yaml
dhictl customization build list --org demonstrationorg cz_08j7wqirdnx2k
```

| Workflow | Trigger | Action |
| --- | --- | --- |
| DHI Customization Edit | push to `main` changing the yaml, or manual | `dhictl customization edit` |
| DHI Customization Recreate | manual | deletes the customization, creates it again, commits the new `id` |
