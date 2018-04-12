.ONESHELL:
SHELL := /bin/bash

install:
	@echo "==> Configure Git Hooks Directory:"
	git config core.hooksPath .githooks
	@echo "==> Initialize a Terraform working directory:"
	terraform init
