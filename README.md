# dhi-dependabot-test

Minimal Node app for testing Dependabot digest updates against a Docker Hardened Image (DHI) base.

The `Dockerfile` pins `demonstrationorg/dhi-node` by tag and digest. Dependabot, configured in
`.github/dependabot.yml`, checks Docker Hub daily and opens a PR whenever a newer digest is published.
