help: ## Show Help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

tools: ## Install golang tools
	go get golang.org/x/tools/cmd/goimports
	go install mvdan.cc/gofumpt@latest

imports: ## Organize imports
	rm -rf vendor
	goimports -l -w .

fmt: ## Format code
	gofumpt -l -w .

test: ## Run unit tests
	touch count.out
	go test -covermode=count -coverprofile=count.out -v ./...
	$(MAKE) coverage

coverage: ## Unit tests coverage
	go tool cover -func=count.out

lint: ## Run linter
	go mod vendor
	docker run --rm -v $(PWD):/app -w /app golangci/golangci-lint:v1.46.0 golangci-lint run -v

.PHONY: test
