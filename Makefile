.PHONY: all build
TAG?=latest

all:	build
build:
	docker build -t alexellis2/hashbrowns:${TAG} .

