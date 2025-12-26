.PHONY: help build up down restart logs clean db-connect db-reset
.PHONY: run-dev run-test run-prod dev test prod

# 环境变量（默认开发环境）
ENV ?= development
ENV_FILE := .env.$(ENV)

help: ## 显示帮助信息
	@echo "可用命令:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

build: ## 构建 Docker 镜像
	docker-compose build

up: ## 启动所有服务（使用默认环境）
	docker-compose --env-file $(ENV_FILE) up -d
	@echo "等待服务启动..."
	@sleep 5
	@echo "✅ 服务已启动（环境: $(ENV)）"
	@echo "📊 MySQL: localhost:3306"
	@echo "🌐 Web API: http://localhost:8080"

down: ## 停止所有服务
	docker-compose down

# ========== 环境切换命令 ==========

dev: ## 使用开发环境启动
	$(MAKE) up ENV=development

test: ## 使用测试环境启动
	$(MAKE) up ENV=test

prod: ## 使用生产环境启动
	$(MAKE) up ENV=production

# ========== 本地开发命令 ==========

run-dev: ## 本地运行开发环境
	@echo "🚀 启动开发环境..."
	@if [ -f .env.development ]; then \
		export $$(cat .env.development | xargs) && go run main.go; \
	else \
		echo "❌ .env.development 文件不存在，请先创建："; \
		echo "   cp .env.example .env.development"; \
		exit 1; \
	fi

run-test: ## 本地运行测试环境
	@echo "🧪 启动测试环境..."
	@if [ -f .env.test ]; then \
		export $$(cat .env.test | xargs) && go test -v ./...; \
	else \
		echo "❌ .env.test 文件不存在"; \
		exit 1; \
	fi

restart: ## 重启所有服务
	docker-compose restart

logs: ## 查看所有服务日志
	docker-compose logs -f

logs-app: ## 查看应用日志
	docker-compose logs -f app

logs-mysql: ## 查看 MySQL 日志
	docker-compose logs -f mysql

clean: ## 停止并删除所有容器、网络和 volumes
	docker-compose down -v
	@echo "✅ 清理完成"

db-connect: ## 连接到 MySQL 容器
	docker exec -it web_mysql mysql -uroot -prootpassword

db-reset: ## 重置数据库（删除所有数据）
	docker-compose down -v
	docker-compose up -d
	@echo "✅ 数据库已重置"

status: ## 查看服务状态
	docker-compose ps
