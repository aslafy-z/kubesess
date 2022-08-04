SHELL := /bin/bash

.PHONY: run
run:
	cargo run -- -v docker-desktop context 

.PHONY: build
build:
	cargo build

.PHONY: deploy_local
deploy_local: build
	cp ./target/debug/kubesess ./src/kubesess.sh ~/.kube/kubesess/
	sudo mv ~/.kube/kubesess/kubesess /usr/local/bin/kubesess

.PHONY: benchmark
benchmark: deploy_local
	sh ./tests/benchmark.sh
	hyperfine --warmup 5 --runs 100 --shell none 'kubesess -v docker-desktop context' 'kubectx docker-desktop' --export-markdown ./tests/hyperfine/markdown.md

