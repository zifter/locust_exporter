VERSION="local"
GIT_BRANCH=$(shell git branch --show-current)
GIT_COMMIT=$(shell git log -1 --pretty=format:'%h')
BUILD_TIMESTAMP=$(shell date +"%Y/%m/%d-%T")

build:
	@echo $(VERSION), $(GIT_BRANCH), $(GIT_COMMIT), $(BUILD_TIMESTAMP)
	podman build \
		--env=VERSION=$(VERSION) \
		--env=GIT_BRANCH=$(GIT_BRANCH) \
		--env=GIT_COMMIT=$(GIT_COMMIT) \
		--env=BUILD_TIMESTAMP=$(BUILD_TIMESTAMP) \
		--arch amd64 \
		-t zifter/locust_exporter:$(VERSION) \
		-f Containerfile \
		.

run:
	podman run zifter/locust_exporter:$(VERSION)

push:
	podman push zifter/locust_exporter:$(VERSION)