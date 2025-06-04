PROJECT_REL_DIR=../
include ${PROJECT_REL_DIR}common.mk

BUILD_IMAGE_PROJECT_DIR=/go/src/${PROJECT_PATH}
BUILD_WORKDIR=${BUILD_IMAGE_PROJECT_DIR}/outer

MODULE_DIRS := . submodules/*
PROTO_SOURCE_FILES := $(foreach dir,$(MODULE_DIRS),$(shell find $(dir) -name '*.proto'))
PROTO_SOURCE_FILES := $(foreach f,${PROTO_SOURCE_FILES},$(patsubst ./%,%,$(f)))

GW_FILES=$(patsubst %.proto,%.pb.gw.go,$(wildcard pb/**/*.proto))
GRPC_FILES=$(patsubst %.proto,%_grpc.pb.go,$(wildcard pb/**/*.proto))
PROTO_FILES=$(patsubst %.proto,%.pb.go,$(PROTO_SOURCE_FILES))
ARTIFACTS=${PROTO_FILES} ${GW_FILES} ${GRPC_FILES}

${ARTIFACTS}: ${PROTO_SOURCE_FILES}
	@echo "Building proto artifacts inside Docker"
	${DOCKER_RUN} \
		-u ${DOCKER_USER} \
		-v ${DOCKER_PROJECT_DIR}:${BUILD_IMAGE_PROJECT_DIR} \
		--mount type=tmpfs,destination=/.cache \
		-e PROJECT_PATH="${PROJECT_PATH}" \
		-e VERSION="${VERSION}" \
		-w ${BUILD_WORKDIR} \
		${BUILD_IMAGE}
