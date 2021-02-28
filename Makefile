
# kernel-style V=1 build verbosity
ifeq ('$(origin V)', 'command line')
	BUILD_VERBOSE = $(V)
endif
ifeq ($(BUILD_VERBOSE),1)
	Q =
else
	Q = @
endif

ifeq ($(OS),Windows_NT)
	SHELL := pwsh.exe
else
	SHELL := pwsh
endif

.SHELLFLAGS := -NoProfile -Command

REGISTRY_NAME := 
REPOSITORY_NAME := bmcclure89/
IMAGE_NAME := sqlserver_adventureworks
TAG := :latest
TARGET_TAG := :latest
PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7

all: build
.PHONEY := build
setup:

build:
	./build/build.ps1 -registry '$(registry)' -repository '$(repository)' -ImageName $(IMAGE_NAME) -TargetImageTag '$(TARGET_TAG)'

build_multiarch:
	$(Q)Docker buildx build -t $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) --platform $(PLATFORMS) .

package:
	$(Q)$PackageFileName = "$$("$(IMAGE_NAME)" -replace "/","_").tar"; docker save $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG) -o $PackageFileName

publish:
	$(Q)docker login; docker push $(REGISTRY_NAME)$(REPOSITORY_NAME)$(IMAGE_NAME)$(TAG); docker logout

test: run
	Invoke-Pester ./tests/

Install_tsqlt_to_%:
	docker exec $(IMAGE_NAME) pwsh -f /installTSQLT.ps1 -db '$*' -sa_password "$$([Environment]::GetEnvironmentVariable('SA_PASSWORD', 'User') | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText)"