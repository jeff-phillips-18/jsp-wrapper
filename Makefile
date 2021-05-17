DEFAULT_ENV_FILE := .env
ifneq ("$(wildcard $(DEFAULT_ENV_FILE))","")
include ${DEFAULT_ENV_FILE}
export $(shell sed 's/=.*//' ${DEFAULT_ENV_FILE})
endif

ENV_FILE := .env.local
ifneq ("$(wildcard $(ENV_FILE))","")
include ${ENV_FILE}
export $(shell sed 's/=.*//' ${ENV_FILE})
endif

IMAGE=$(IMAGE_NAME):$(IMAGE_TAG)
TARGET=quay.io/$(QUAY_REPO)/$(IMAGE_NAME):$(IMAGE_TAG)
GIT_REPO=https://github.com/$(PROFILES_GIT_USER)/jupyterhub-singleuser-profiles



all: prep-is local
remote: apply build rollout

local: build-local tag push import rollout

build-local:
	podman build . --build-arg user=$(PROFILES_GIT_USER) --build-arg branch=$(PROFILES_GIT_REF) --no-cache -t $(IMAGE)

tag:
	podman tag $(IMAGE) $(TARGET)

push:
	podman push $(TARGET)

import:
	oc import-image -n $(NAMESPACE) jupyterhub-img

rollout:
	oc rollout -n $(NAMESPACE) latest jupyterhub

prep-is:
	oc patch imagestream/jupyterhub-img -n $(NAMESPACE) -p '{"spec":{"tags":[{"name":"latest","from":{"name":"'$(TARGET)'"}}]}}'

apply:
	./scripts/apply.sh

build:
	oc start-build -n $(NAMESPACE) jupyterhub-img-wrapper -F
