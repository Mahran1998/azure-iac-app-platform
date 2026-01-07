SHELL := /bin/bash

.PHONY: demo validate fmt

demo:
	./scripts/demo.sh

validate:
	terraform fmt -check -recursive
	terraform -chdir=infra init -backend=false
	terraform -chdir=infra validate

fmt:
	terraform fmt -recursive
