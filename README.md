<p align="center">
  <a href="https://github.com/marketplace/actions/docker-stack-deploy-action">
    <img alt="GitHub Pages Deploy Action Logo" width="200px" src="https://raw.githubusercontent.com/polluxs/swarminator/main/docs/icon.png">
  </a>
</p>

<div align="center">

[![GitHub Actions Marketplace](https://img.shields.io/badge/action-marketplace-blue.svg?logo=github&color=orange)](https://github.com/marketplace/actions/swarminator)
[![Release version badge](https://img.shields.io/github/v/release/polluxs/swarminator)](https://github.com/polluxs/swarminator)

![GitHub Repo stars](https://img.shields.io/github/stars/polluxs/swarminator?style=flat-square)
[![license badge](https://img.shields.io/github/license/polluxs/swarminator)](./LICENSE)

</div>

This is a security-focused fork of the original action, with stricter security requirements:

- SSH private/public key pair authentication is mandatory (password authentication is not supported)
- SSH host key verification is enforced

These changes ensure more secure deployments in production environments.

## Configuration options

| GitHub Action Input           | Environment Variable          | Summary                                                                                   | Required | Default Value |
| ----------------------------- | ----------------------------- | ----------------------------------------------------------------------------------------- | -------- | ------------- |
| `registry`                    | `REGISTRY`                    | Specify which container registry to login to.                                             |          |
| `username`                    | `USERNAME`                    | Container registry username.                                                              |          |               |
| `password`                    | `PASSWORD`                    | Container registry password.                                                              |          |               |
| `remote_public_key`           | `REMOTE_PUBLIC_KEY`           | Public key used for ssh authentication.                                                   | ✅       |               |
| `remote_port`                 | `REMOTE_PORT`                 | SSH port to connect on the the machine running the Docker Swarm manager node.             |          | **22**        |
| `remote_user`                 | `REMOTE_USER`                 | User with SSH and Docker privileges on the machine running the Docker Swarm manager node. | ✅       |               |
| `remote_private_key`          | `REMOTE_PRIVATE_KEY`          | Private key used for ssh authentication.                                                  | ✅       |               |
| `remote_public_key`           | `REMOTE_PUBLIC_KEY`           | Public key used for ssh authentication.                                                   | ✅       |               |
| `remote_private_key_password` | `REMOTE_PRIVATE_KEY_PASSWORD` | Password for the private key (if key is password protected).                              |          |               |
| `deploy_timeout`              | `DEPLOY_TIMEOUT`              | Seconds, to wait until the deploy finishes                                                |          | **600**       |
| `stack_file`                  | `STACK_FILE`                  | Path to the stack file used in the deploy.                                                | ✅       |               |
| `stack_name`                  | `STACK_NAME`                  | Name of the stack to be deployed.                                                         | ✅       |               |
| `stack_param`                 | `STACK_PARAM`                 | Additional parameter (env var) to be passed to the stack.                                 |          |               |
| `env_file`                    | `ENV_FILE`                    | Additional environment variables to be passed to the stack.                               |          |               |
| `debug`                       | `DEBUG`                       | Verbose logging                                                                           |          | **0**         |

## Using the GitHub Action

Add, or edit an existing, `yaml` file inside `.github/actions` and use the configuration options listed above.

### Examples

#### Deploying public images

```yaml
name: Deploy Staging

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout codebase
        uses: actions/checkout@v2

      - name: Deploy
        uses: polluxs/swarminator@v1.0.0
        with:
          remote_host: ${{ secrets.REMOTE_HOST }}
          remote_user: ${{ secrets.REMOTE_USER }}
          remote_private_key: ${{ secrets.REMOTE_PRIVATE_KEY }}
          stack_file: "stacks/plone.yml"
          stack_name: "plone-staging"
```

#### Deploying private images from GitHub Container Registry

First, follow the steps to [create a Personal Access Token](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry#authenticating-to-the-container-registry).

```yaml
name: Deploy Live

on:
  push:
    tags:
      - "*.*.*"

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout codebase
        uses: actions/checkout@v2

      - name: Deploy
        uses: polluxs/swarminator@v1.0.0
        with:
          registry: "ghcr.io"
          username: ${{ secrets.GHCR_USERNAME }}
          password: ${{ secrets.GHCR_TOKEN }}
          remote_host: ${{ secrets.REMOTE_HOST }}
          remote_user: ${{ secrets.REMOTE_USER }}
          remote_private_key: ${{ secrets.REMOTE_PRIVATE_KEY }}
          stack_file: "stacks/plone.yml"
          stack_name: "plone-live"
          stack_param: "foo"
```

## Using the Docker Image

It is possible to directly use the `ghcr.io/polluxs/swarminator` Docker image, passing the configuration options as environment variables.

### Examples

#### Local machine

Considering you have a local file named `.env_deploy` with content:

```
REMOTE_HOST=192.0.0.1
REMOTE_PRIVATE_KEY_PASSWORD=MYSECRETPASSWORD
REMOTE_USER=root
STACK_FILE=stacks/hello-world.yml
STACK_NAME=hello-world
DEBUG=1
```

Run the following commands:

```bash
# build your local docker image
docker build -t docker-swarm-deploy-test .

# run from local docker image
``docker run --rm \                                                           1 ✘  14:04:57
  -v "$(pwd)":/github/workspace \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --env-file=.env_deploy \
  -e REMOTE_PRIVATE_KEY="$(cat ~/.ssh/id_rsa)" \
  -e REMOTE_PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
  docker-swarm-deploy-test`
```

## Contribute

- [Issue Tracker](https://github.com/polluxs/swarminator/issues)
- [Source Code](https://github.com/swarm/swarminator/)

Please **DO NOT** commit to version branches directly. Even for the smallest and most trivial fix.

**ALWAYS** open a pull request and ask somebody else to merge your code. **NEVER** merge it yourself.

## Credits

Forked from:
[![kitconcept GmbH](https://raw.githubusercontent.com/kitconcept/docker-stack-deploy/main/docs/kitconcept.png)](https://kitconcept.com)

This repository also uses the `docker-stack-wait` script, available at [GitHub](https://github.com/sudo-bmitch/docker-stack-wait).

## License

The project is licensed under [MIT License](./LICENSE)
