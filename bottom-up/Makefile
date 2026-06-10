TF ?= terraform
AUTO_APPROVE ?= -auto-approve

.PHONY: up down

up:
	$(TF) init -upgrade
	$(TF) apply -target module.net $(AUTO_APPROVE)
	$(TF) apply -target module.management $(AUTO_APPROVE)
	$(TF) apply -target module.fw $(AUTO_APPROVE)
	$(TF) apply -target module.instances $(AUTO_APPROVE)
	$(TF) apply $(AUTO_APPROVE)

down:
	$(TF) destroy $(AUTO_APPROVE)