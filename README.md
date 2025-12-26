# Web 项目 - Gin + GORM + MySQL

使用 Gin 框架和 GORM 构建的 RESTful API，支持 Docker 部署。

## 📁 项目结构

```
web/
├── docker-compose.yml          # Docker Compose 配置
├── Dockerfile                  # Docker 镜像构建
├── Makefile                    # 便捷命令
├── .env.example                # 环境变量示例
├── .env.development            # 开发环境配置（不提交）
├── init.sql                    # MySQL 初始化脚本
├── main.go                     # 主程序入口
├── config/
│   └── database.go            # 数据库配置
├── models/
│   └── user.go                # 用户数据模型
├── controllers/
│   └── user_controller.go     # 用户控制器 (CRUD)
└── docs/
    └── go_naming_conventions.md # Go 命名规范文档
```

## 🚀 快速开始

### 使用 Docker Compose（推荐）

```bash
# 启动所有服务
make up

# 或者使用 docker-compose 命令
docker-compose up -d
```

这将启动：
- **MySQL 8.0**: `localhost:3306`
  - 用户: `root` / `rootpassword`
  - 数据库: `testdb`
- **Web API**: `http://localhost:8080`

### 本地开发

#### 1. 配置环境变量

```bash
# 复制示例配置文件
cp .env.example .env.development

# 根据实际情况编辑 .env.development
vim .env.development
```

#### 2. 安装依赖并运行

```bash
# 安装依赖
go mod tidy

# 运行应用
go run main.go
```

## 📦 Makefile 命令

```bash
make help          # 显示所有可用命令
make up            # 启动所有服务
make down          # 停止所有服务
make restart       # 重启所有服务
make logs          # 查看所有服务日志
make logs-app      # 查看应用日志
make logs-mysql    # 查看 MySQL 日志
make db-connect    # 连接到 MySQL 容器
make db-reset      # 重置数据库
make clean         # 清理所有容器和数据
make status        # 查看服务状态
```

## 📡 API 端点

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/health` | 健康检查 |
| POST | `/api/users` | 创建用户 |
| GET | `/api/users` | 获取所有用户 |
| GET | `/api/users/:id` | 根据 ID 获取用户 |
| PUT | `/api/users/:id` | 更新用户 |
| DELETE | `/api/users/:id` | 删除用户 |

## 📝 请求示例

### 创建用户
```bash
curl -X POST http://localhost:8080/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "name": "张三",
    "email": "zhangsan@example.com",
    "age": 25
  }'
```

### 获取所有用户
```bash
curl http://localhost:8080/api/users
```

### 获取单个用户
```bash
curl http://localhost:8080/api/users/1
```

### 更新用户
```bash
curl -X PUT http://localhost:8080/api/users/1 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "李四",
    "email": "lisi@example.com",
    "age": 30
  }'
```

### 删除用户
```bash
curl -X DELETE http://localhost:8080/api/users/1
```

## 🔧 环境变量配置

### 环境变量文件说明

项目使用多个环境配置文件：

| 文件 | 说明 | Git 状态 |
|------|------|---------|
| `.env.example` | 示例配置文件 | ✅ 提交（不包含敏感信息） |
| `.env.development` | 开发环境配置 | ❌ 不提交（包含本地配置） |
| `.env.production` | 生产环境配置 | ❌ 不提交（包含敏感信息） |
| `.env.test` | 测试环境配置 | ❌ 不提交（包含测试配置） |

### 配置步骤

1. **复制示例配置**：
   ```bash
   cp .env.example .env.development
   ```

2. **编辑配置文件**：
   ```env
   # MySQL 数据库配置
   DB_HOST=localhost
   DB_PORT=3306
   DB_USER=root
   DB_PASSWORD=your_password_here
   DB_NAME=your_database_name

   # 应用配置
   APP_PORT=8080
   GIN_MODE=debug
   ```

3. **加载环境变量**（需要工具）：
   ```bash
   # 安装 direnv（推荐）
   brew install direnv  # macOS
   apt install direnv   # Ubuntu

   # 或使用其他工具：
   # - godotenv: go get github.com/joho/godotenv
   # - export 在 shell 中手动导出
   ```

### 环境变量列表

| 变量名 | 说明 | 默认值 | 示例 |
|--------|------|--------|------|
| `DB_HOST` | 数据库主机 | `localhost` | `localhost`, `mysql` |
| `DB_PORT` | 数据库端口 | `3306` | `3306` |
| `DB_USER` | 数据库用户 | `root` | `root`, `webuser` |
| `DB_PASSWORD` | 数据库密码 | `rootpassword` | `your_password` |
| `DB_NAME` | 数据库名称 | `testdb` | `myapp_db` |
| `APP_PORT` | 应用端口 | `8080` | `8080`, `3000` |
| `GIN_MODE` | Gin 运行模式 | `debug` | `debug`, `release` |

## 🗄️ 数据库

### 连接到 MySQL 容器
```bash
make db-connect

# 或者
docker exec -it web_mysql mysql -uroot -prootpassword
```

### 重置数据库
```bash
make db-reset
```

## 🛠️ 技术栈

- **Gin**: 高性能 Go Web 框架
- **GORM**: Go ORM 库
- **MySQL 8.0**: 关系型数据库
- **Docker**: 容器化部署

## 📄 许可证

MIT License
