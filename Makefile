.PHONY: build
build:
	docker build -t falco-fuzz .

.PHONY: run
run:
	docker run --security-opt apparmor=unconfined -it --rm --privileged falco-fuzz bash

