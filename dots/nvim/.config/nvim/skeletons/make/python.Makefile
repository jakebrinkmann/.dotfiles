SRC:= ./src
REGISTRY:= private.com:4443
IMAGE:= resources/test
TAG:= latest
DOCKER_IMAGE= $(REGISTRY)/$(IMAGE):$(TAG)
TEST_CMD= docker run --rm -it \
			--name $(IMAGE)\
			-v $(CURDIR):/var/task:ro \
			--tmpfs /tmp:rw \
			$(DOCKER_TAG)

.PHONY: test ## Run Test Suite
test: test-a test-b

.PHONY: test-a ## Run Test Suite A
test: test-a
	$(TEST_CMD)python -B -m py.test tests/src --cov=$(SRC)--cov-fail-under=85 --no-cov-on-fail

.PHONY: lint
lint: cfn-lint py-lint

.PHONY: py-lint ## Run Python Style Checker
py-lint:
	$(TEST_CMD)black --check --line-length=120 $(SRC)
	$(TEST_CMD)flynt --fail-on-change $(SRC)
	$(TEST_CMD)flake8 --max-line-length=120 $(SRC)
	$(TEST_CMD)pydocstyle $(SRC)
	$(TEST_CMD)isort -c -rc --line-width=120 -m 3 $(SRC)
	$(TEST_CMD)mypy --silent-imports $(SRC)

.PHONY: py-format ## Run Code Auto Formatters
py-format:
	$(TEST_CMD)black --line-length=120 $(SRC)
	$(TEST_CMD)flynt $(SRC)
	$(TEST_CMD)isort -rc -sl $(SRC)
	$(TEST_CMD)autoflake --remove-all-unused-imports -i -r $(SRC)
	$(TEST_CMD)isort -rc --line-width=120 -m 3 $(SRC)

.PHONY: cfn-lint ## Run C12N Template Checker
cfn-lint:
	$(TEST_CMD)cfn-lint template.yaml

.PHONY: image ## Build test image
image:
	docker build --compress \
		-f Dockerfile -t $(DOCKER_TAG)$(CURDIR)

.PHONY: login  ## Authenticate to Docker registry.
login:
	docker login $(REGISTRY)

.PHONY: push  ## Push image to Docker registry.
push: login
	docker push $(DOCKER_TAG)

.PHONY: all
all: lint test
