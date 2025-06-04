# General project config for dockerized buf generation

PROJECT=proto-experiment
VERSION=0.1.0-SNAPSHOT

# Docker image version (using Luther BuildEnv)
BUILDENV_TAG=v0.0.92

# Build image full name (assuming BUILD_IMAGE_API is still configured somewhere centrally)
BUILD_IMAGE_API=luthersystems/buildenv-go-proto
BUILD_IMAGE=${BUILD_IMAGE_API}:${BUILDENV_TAG}