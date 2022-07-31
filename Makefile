all: build

build:
	@docker build --tag=datoma/bind .
