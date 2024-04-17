

[![ECR release](https://img.shields.io/badge/ECR-circulor_mkdocs-green)](https://gallery.ecr.aws/circulor/circulor_mkdocs)
[![Github release](https://img.shields.io/github/v/release/circulor/circulor_mkdocs)](https://github.com/circulor/circulor_mkdocs/releases)
[![GitHub](https://img.shields.io/github/license/circulor/circulor_mkdocs)](https://github.com/circulor/circulor_mkdocs?tab=MIT-1-ov-file#readme)

# Circulor mk docs

Contains a version of squidfunk/mkdocs-material docker container with additional plugins.

## Getting started

To test the wrapper please supply the required environment variables

```bash
export ENV=local
docker-compose build && docker-compose up
```

## How to use the image

To test the wrapper please supply the required environment variables

```bash
# Serve the document on http://localhost:8000/
docker run --rm -it -p 8000:8000 -v ${PWD}/src:/docs public.ecr.aws/n3x3n4v5/circulor_mkdocs:v0.1.1.0-alpha
# Build the document
docker run --rm -it -p 8000:8000 -v ${PWD}/src:/docs public.ecr.aws/n3x3n4v5/circulor_mkdocs:v0.1.1.0-alpha build
```

## Available make commands

### Commands outside the container

- `make docker-login` : Authenticate docker with ecr
- `make docker-build` : Build the container
- `make docker-push`  : Push containers to registry
