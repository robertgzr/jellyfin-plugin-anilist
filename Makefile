
.PHONY: check
check:
	@docker build -o type=tar,dest=/dev/null -t build .

.PHONY: build
build:
	@docker build -o . -t final .
