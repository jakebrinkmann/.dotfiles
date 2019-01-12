.DEFAULT_GOAL := build
# Docker image name and tag (e.g. reg/image)
REGISTRY := $(or $(DOCKER_USER), jbrinkmann)/
IMAGE := dotfiles
# The git branch name (e.g. primary, develop, ...)
BRANCH := $(or $(TRAVIS_BRANCH),`git rev-parse --abbrev-ref HEAD | tr / -`)
# Latest git tag (e.g. 0.0.0-1)
VERSION := $(shell git describe --tags |sed 's/-g[a-z0-9]\{7\}//')
# Include the branch name when not on primary (e.g. reg/image:0.0.0-1-develop)
TAG := $(shell if [ "$(BRANCH)" = "primary" ]; \
			then echo "$(REGISTRY)$(IMAGE):$(VERSION)"; \
			else echo "$(REGISTRY)$(IMAGE):$(VERSION)-$(BRANCH)"; \
		fi)
# Additionally, include the git commit hash
COMMIT := $(or $(TRAVIS_COMMIT),`git rev-parse --short HEAD`)

.PHONY: image
image: ## Build the Dockerfile as an image.
	# TODO: use `--squash` when it is no longer experimental
	docker build --rm=true --compress --force-rm \
		-t $(TAG) $(CURDIR)

.PHONY: tag
tag: ## Tagging with the commit hash allows immutable deploys.
	docker tag $(TAG) $(TAG)-$(COMMIT)
ifeq ($(BRANCH),primary)
	docker tag $(TAG) $(REGISTRY)$(IMAGE):latest
endif

.PHONY: login
login: ## Login to Docker registry.
	@$(if $(and $(DOCKER_USER), $(DOCKER_PASS)), docker login -u $(DOCKER_USER) -p $(DOCKER_PASS), docker login)

.PHONY: push
push: login ## Publish image to Docker registry.
	docker push $(REGISTRY)$(IMAGE)

.PHONY: debug
debug: ## Echo resolved variables.
	@echo "REGISTRY:   $(REGISTRY)"
	@echo "IMAGE:      $(IMAGE)"
	@echo "BRANCH:     $(BRANCH)"
	@echo "VERSION:    $(VERSION)"
	@echo "TAG:        $(TAG)"
	@echo "COMMIT:     $(COMMIT)"

# if this session isn't interactive, then we don't want to allocate a
# TTY, which would fail, but if it is interactive, we do want to attach
# so that the user can send e.g. ^C through.
# https://github.com/jessfraz/dockerfiles/blob/master/Makefile#L35
INTERACTIVE := $(shell [ -t 0 ] && echo 1 || echo 0)
ifeq ($(INTERACTIVE), 1)
	DOCKER_FLAGS += -t
endif

# if we're running inside Docker Toolbox (Windows/Mac) then we need
# to change the socket (named pipe) to communicate with the host system
# docker daemon (otherwise, we cannot develop docker inside this dev-env)
NIXHOST := $(shell [ -e /var/run/docker.sock ] && echo 1 || echo 0)
ifeq ($(NIXHOST), 1)
	SOCKETLOC += /var/run/docker.sock:/var/run/docker.sock:ro
else
	SOCKETLOC += \\.\pipe\docker_engine:\\.\pipe\docker_engine:ro
endif

.PHONY: run
run: ## Run the Dockerfile in a container.
	docker run --rm -i $(DOCKER_FLAGS) \
		--name $(IMAGE) \
		-v $(SOCKETLOC) \
		$(TAG) || exit 0

.PHONY: format
format: ## Check the source code formatting.
	black $(CURDIR)/subimage
	pydocstyle $(CURDIR)/subimage

.PHONY: clean
clean: clean-docker ## Clean up everything.

.PHONY: clean-docker
clean-docker:
	@docker rmi -f $(shell docker images |grep $(REGISTRY)$(IMAGE) |awk '{print $$3}')
	@docker rmi -f $(shell docker images --filter dangling=true -q)

.PHONY: all
all: debug image tag push

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
