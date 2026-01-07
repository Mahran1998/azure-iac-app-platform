SHELL := /bin/bash
.RECIPEPREFIX := >

.PHONY: demo validate fmt

demo:
> ./scripts/demo.sh

validate:
> terraform fmt -check -recursive
> terraform -chdir=infra init -backend=false
> terraform -chdir=infra validate
> bash -n scripts/demo.sh

fmt:
> terraform fmt -recursive
