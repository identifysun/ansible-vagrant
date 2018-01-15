SHELL=/bin/bash
KUBERNETES_VERSION := "1.17.5"
ETCD_VERSION := "3.3.20"

.PHONY: playbook
playbook:
	ansible-playbook kubernetes-cluster.yml

check:
	find . -maxdepth 1 -name '*.yml' | xargs -n1 \
	ansible-playbook --syntax-check --list-tasks -i tests/ansible_hosts

lint:


download:
	@echo -n 'Download the binaries package to ./tests/binaries directory...'
	export ROLE_PATH
	@scripts/download.sh

clean:

