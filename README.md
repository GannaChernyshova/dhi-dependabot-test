# dhi-dependabot-test

A small Node app built three ways, to compare Docker Hardened Images (DHI) with Docker Official Images (DOI).

## Before you start

- **DHI** are minimal, low-CVE images maintained by Docker. Each comes in two variants:
  - **`-dev`**: has a shell and a package manager (`apt-get`). Use it to build.
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

Also add these repository **variables** (same page, Variables tab):

| Variable | Value |
| --- | --- |
| `DHI_ORG` | Docker Hub org that holds the DHI mirror, e.g. `demonstrationorg` |
| `DHI_CUSTOMIZATION_ID` | Customization id, e.g. `cz_08j7wqirdnx2k` |

## 2. Compare DOI and DHI

| Dockerfile | Build stage | Runtime stage |
| --- | --- | --- |
| `doi/Dockerfile` | `node:26-trixie` + `apt-get install curl wget` | same as build stage |
| `dhi/Dockerfile` | `dhi-node-anna:26-debian13-dev` + `apt-get install curl wget` | `dhi-node-anna:26-debian13` |

```bash
docker buildx build --provenance=true --sbom=true -f doi/Dockerfile -t demo-node:doi .
docker buildx build --provenance=true --sbom=true -f dhi/Dockerfile -t demo-node:dhi .
docker scout compare local://demo-node:dhi --to local://demo-node:doi

docker run --rm -p 3000:3000 demo-node:dhi    # curl localhost:3000
```

A local build doesn't carry DHI's VEX statements, so Scout may list CVEs that DHI marks as not affecting the image.
To see DHI's own assessment, scan the base image from the registry:
`docker scout cves demonstrationorg/dhi-node-anna:26-debian13`.

## 3. Customize a DHI image

`customization/customization.yaml` adds `curl` and `wget` to `26-debian13-dev` and publishes the result as
`dhi-node-anna:26-debian13-dev_tools`. `customization/Dockerfile` builds on it, with no `apt-get` step.

```bash
docker buildx build --provenance=true --sbom=true -f customization/Dockerfile -t demo-node:customized .
```

The yaml is a template: the Hub org (`DHI_ORG`) and the customization id (`DHI_CUSTOMIZATION_ID`) come from
environment variables locally and from repository variables in CI. To change the customization, edit the yaml, then either
merge to `main` or run:

```bash
export DHI_ORG=demonstrationorg DHI_CUSTOMIZATION_ID=cz_08j7wqirdnx2k
export DHI_API_TOKEN=<Docker Hub access token>
envsubst '$DHI_ORG $DHI_CUSTOMIZATION_ID' < customization/customization.yaml > /tmp/customization.yaml
dhictl customization edit --org "$DHI_ORG" /tmp/customization.yaml
dhictl customization build list --org "$DHI_ORG" "$DHI_CUSTOMIZATION_ID"
```

| Workflow | Trigger | Action |
| --- | --- | --- |
| DHI Customization Edit | push to `main` changing the yaml, or manual | `dhictl customization edit` |
| DHI Customization Recreate | manual | deletes the customization, creates it again, prints the new id; set it as `DHI_CUSTOMIZATION_ID` |
