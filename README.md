# dhi-dependabot-test

Minimal Node app for testing Dependabot digest updates against a Docker Hardened Image (DHI) base.

The `Dockerfile` pins `demonstrationorg/dhi-node` by tag and digest. Dependabot, configured in
`.github/dependabot.yml`, checks Docker Hub daily and opens a PR whenever a newer digest is published.

## Setup

The main thing is to ensure you point Dependabot to a Hub registry with credentials that have access to
your mirrored DHI repos: see `registries` in `.github/dependabot.yml`.

### Required GitHub secrets

Create both secrets with the same names and values in **two** places, because Dependabot and Actions
read from separate stores (Settings > Secrets and variables):

| Secret | Value |
| --- | --- |
| `DHI_DOCKERHUB_USERNAME` | Docker Hub username with entitlement to pull your DHI images |
| `DHI_DOCKERHUB_TOKEN` | Docker Hub access token for that user |

- **Dependabot** store: used by `.github/dependabot.yml` to check for new base image versions.
- **Actions** store: used by `.github/workflows/build.yml` to log in and build the image. Dependabot PRs read
  the Dependabot store, so both are needed.
