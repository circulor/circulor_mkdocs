.DEFAULT_GOAL := help

# General Variables
date=$(shell date +'%y.%m.%d.%H.%M')
project := Circulor mkdocs
container := circulor-mkdocs
docker-filecheck := /.dockerenv
docker-warning := ""
RED=\033[0;31m
GREEN=\033[0;32m
NC=\033[0m # No Color
versionPrefix := 0.1
version := $(versionPrefix).$(shell git rev-list HEAD --count)
shorthash := $(shell git rev-parse --short=8 HEAD)
version-suffix := ''
registry := public.ecr.aws/n3x3n4v5/circulor_mkdocs

ifdef GITHUB_BASE_REF
	current-branch :=  $(patsubst refs/heads/%,%,${GITHUB_HEAD_REF})
else ifdef GITHUB_REF
	current-branch :=  $(patsubst refs/heads/%,%,${GITHUB_REF})
else
	current-branch :=  $(shell git rev-parse --abbrev-ref HEAD)
endif

ifeq ($(current-branch), main)
	docker-tags := -t $(registry):alpha -t $(registry):latest -t $(registry):v$(version) -t $(registry):$(shorthash)
else
	version := $(versionPrefix).$(shell git rev-list main --count).$(shell git rev-list main..HEAD --count)
	version-suffix := alpha
	docker-tags := -t $(registry):$(version-suffix) -t $(registry):$(shorthash) -t $(registry):v$(version)-$(version-suffix)
endif

# Docker Warning
ifeq ("$(wildcard $(docker-filecheck))","")
	docker-warning = "⚠️  WARNING: Can't find /.dockerenv - it's strongly recommended that you run this from within the docker container."
endif

# Targets
help:
	@echo "The following commands can be used for building & running & deploying the the $(project) container"
	@echo "---------------------------------------------------------------------------------------------"
	@echo ""
	@echo "Service Targets (should only be run inside the docker container)"
	@echo "   - ${GREEN}docker-login${NC} : Authenticate docker with ecr"
	@echo "   - ${GREEN}docker-build${NC} : Build the container"
	@echo "   - ${GREEN}docker-push${NC}  : Push containers to registry"
	@echo ""
	@echo ""
	@echo "Examples:"
	@echo " - Just build containers    : make docker-build"
	@echo " - Everything               : make docker-login docker-build docker-push"


docker-login: 
	@echo "Login to AWS ecr ${GREEN}$(registry)${NC}"
	@aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(registry)

docker-build:
	@echo "Building branch ${RED}$(current-branch)${NC} to ${GREEN}$(docker-tags)${NC} with ${GREEN}$(version)-$(version-suffix)${NC}"
	@docker build --build-arg VERSION=$(version) --build-arg VERSION_SUFFIX=$(version-suffix) ${docker-tags} .

docker-push:
	@echo -e "Pusing to ${GREEN}$(docker-tags)${NC}"
	@docker push --all-tags $(registry)
	@docker images | grep "$(registry)" | awk '{system("docker rmi " "'"$(registry):"'" $$2)}'