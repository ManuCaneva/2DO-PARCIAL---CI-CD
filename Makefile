.PHONY: build test run stop all

build:
	docker compose build

test:
	./ci/run_spec_kit.sh

run:
	docker compose up -d

stop:
	docker compose down

all: build test
