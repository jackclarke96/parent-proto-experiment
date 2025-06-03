# Copyright © 2021 Luther Systems, Ltd. All right reserved.

PROJECT_REL_DIR=../
include ${PROJECT_REL_DIR}common.mk
BUILD_IMAGE_PROJECT_DIR=/go/src/${PROJECT_PATH}

BUILD_IMAGE=${BUILD_IMAGE_API}:a8ebf90345ea3c6a0acc19a6fb0939f3dbe6d64c

MODULE_DIRS := . submodules/*

PROTO_SOURCE_FILES := $(foreach dir,$(MODULE_DIRS),$(shell find $(dir)/pb -name '*.proto'))

# Strip leading './' from paths so patsubst works properly
PROTO_SOURCE_FILES := $(foreach f,${PROTO_SOURCE_FILES},$(patsubst ./%,%,$(f)))

BUILD_IMAGE_PROJECT_DIR=/go/src/${PROJECT_PATH}
BUILD_WORKDIR=${BUILD_IMAGE_PROJECT_DIR}/outer

# SWAGGER_JSON=swagger/srvpb/oracle.swagger.json

# Updated paths
GW_FILES=$(patsubst %.proto,%.pb.gw.go,$(wildcard pb/**/*.proto))
GRPC_FILES=$(patsubst %.proto,%_grpc.pb.go,$(wildcard pb/**/*.proto))
PROTO_FILES=$(patsubst %.proto,%.pb.go,$(PROTO_SOURCE_FILES))
# SWAGGER_FILES=$(patsubst %.proto,%.swagger.json,$(PROTO_SOURCE_FILES))

$(info MAKEFILE_GW_FILES: ${GW_FILES})
$(info MAKEFILE_PROTO_FILES: ${PROTO_FILES})
$(info MAKEFILE_GRPC_FILES: ${GRPC_FILES})
# $(info MAKEFILE_SWAGGER_FILES: ${SWAGGER_FILES})
$(info MAKEFILE_PROTO_SOURCE_FILES: ${PROTO_SOURCE_FILES})


# ARTIFACTS=${PROTO_FILES} ${GW_FILES} ${GRPC_FILES} ${SWAGGER_FILES}
ARTIFACTS=${PROTO_FILES} ${GW_FILES} ${GRPC_FILES}
$(info MAKEFILE_ARTIFACTS: ${ARTIFACTS})

.PHONY: default
default: all

.PHONY: all
all: ${ARTIFACTS}

.PHONY: clean
clean:
	${RM} -f ${ARTIFACTS}

# ARTIFACTS is a list of all the generated files
# PROTO SOURCE FILES are the source files for proto
# i.e. if any proto file changes, all artifacts are rebuilt (because this rule has a shared dependency).
# “When I run make, I want these files (ARTIFACTS) to exist, and to produce them, run this dockerized build step.”
${ARTIFACTS}: ${PROTO_SOURCE_FILES}
	@echo "Building api"
	${DOCKER_RUN} \
		-u ${DOCKER_USER} \
		-v ${DOCKER_PROJECT_DIR}:${BUILD_IMAGE_PROJECT_DIR} \
		--mount type=tmpfs,destination=/.cache \
		-e PROJECT_PATH="${PROJECT_PATH}" \
		-e VERSION="${VERSION}" \
		-w ${BUILD_WORKDIR} \
		${BUILD_IMAGE}

.PHONY: unit
unit:
	go test ./...
	@echo "all tests passed"

# redoc can be used for viewing generated oracle swagger file locally, you need
# to install redoc-cli manually: npm i -g redoc-cli
# path of the swagger file is defined by SWAGGER_JSON in api's makefile
.PHONY: redoc
redoc:
	npx redoc-cli serve -p 57505 ./${SWAGGER_JSON}