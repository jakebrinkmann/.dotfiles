.DEFAULT_GOAL := build
VERSION    := `cat version.txt`
REPO       := $(DOCKER_USER)/dotfiles
BRANCH     := $(or $(TRAVIS_BRANCH),`git rev-parse --abbrev-ref HEAD | tr / -`)
COMMIT     := $(or $(TRAVIS_COMMIT),`git rev-parse HEAD`)
COMMIT_TAG := $(REPO):$(COMMIT)
BRANCH_TAG := $(REPO):$(BRANCH)-$(VERSION)


build:
	@docker build -f Dockerfile -t $(COMMIT_TAG) --rm=true --compress $(PWD)

tag:
	@docker tag $(COMMIT_TAG) $(BRANCH_TAG)
	@$(shell [ $(BRANCH) == master ] && docker tag $(COMMIT_TAG) $(REPO):latest)

login:
	@$(if $(and $(DOCKER_USER), $(DOCKER_PASS)), docker login -u $(DOCKER_USER) -p $(DOCKER_PASS), docker login)

push: login
	docker push $(REPO)

debug:
	@echo "VERSION:    $(VERSION)"
	@echo "REPO:       $(REPO)"
	@echo "BRANCH:     $(BRANCH)"
	@echo "COMMIT_TAG: $(COMMIT_TAG)"
	@echo "BRANCH_TAG: $(BRANCH_TAG)"

all: debug build tag push

