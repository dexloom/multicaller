

.PHONY: test
test:
	forge test --fork-url http://localhost:8545 --sender 0x16Df4b25e4E37A9116eb224799c1e0Fb17fd8d30

.PHONY: fmt
fmt:
	npm run fmt

.PHONY: fmt-check
fmt-check:
	npm run fmt-check

.PHONY: lint
lint:
	npm run lint

.PHONY: lint-check
lint-check:
	npm run lint-check