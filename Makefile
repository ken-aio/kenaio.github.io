# from https://github.com/uqichi/blog/blob/master/Makefile
POSTS      := $(wildcard content/post/*.md)
POST_FILE  := `date +'%y%m%d%H%M%S'`
GITHUB_DIR := "tmp/ken-aio.github.io"

.DEFAULT_GOAL := help

list: ## List all posts
	@$(foreach val, $(POSTS), echo $(notdir $(val));)

new: ## Add new post
	@read -p "Enter post name: " f; \
	if [ -z $${f} ]; then FILE="post/$(POST_FILE).md"; \
	else FILE="post/$${f}.md"; \
	fi; \
	hugo new $${FILE}

edit: ## Edit specific post
	@vim `ls -d $(POSTS) | peco`

deploy: ## Deploy posts
	hugo
	cd tmp && git clone https://github.com/ken-aio/ken-aio.github.io.git
	rm -fr $(GITHUB_DIR)/*
	cp -fr public/* $(GITHUB_DIR)/
	cd $(GITHUB_DIR)/ && git config --local user.name ken-aio && git config --local user.email suguru.akiho@gmail.com
	cd $(GITHUB_DIR)/ && git add . && git commit -m "publish" && git push origin master
	rm -fr $(GITHUB_DIR)

server: ## Run local server
	@hugo server -wD

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# Aliases
ls: list
n:  new
e:  edit
s:  server
