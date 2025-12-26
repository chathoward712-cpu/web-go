# GoLand/IntelliJ IDEA 环境变量配置指南

本文档介绍如何在 GoLand 中为 Go 项目配置环境变量。

## 📋 目录

- [方法 1: Run Configuration（推荐）](#方法-1-run-configuration推荐)
- [方法 2: 使用 godotenv 库](#方法-2-使用-godotenv-库)
- [方法 3: IDE 环境变量配置](#方法-3-ide-环境变量配置)
- [方法 4: Before Launch 步骤](#方法-4-before-launch-步骤)

---

## 方法 1: Run Configuration（推荐）

### 步骤 1: 创建 Run Configuration

1. 点击右上角的运行配置下拉菜单
2. 选择 **"Edit Configurations..."**
3. 点击 **"+"** 按钮
4. 选择 **"Go Build"**

### 步骤 2: 配置环境变量

在 Run Configuration 界面：

```
Name: Development (Development)
Files: main.go
Working directory: /Users/howard/GolandProjects/web
```

#### 配置环境变量字段

找到 **"Environment"** 字段，点击右侧的 **"📝"** 图标（Browse）

在弹出的窗口中添加环境变量：

```bash
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=rootpassword
DB_NAME=testdb
APP_PORT=8080
GIN_MODE=debug
```

**或者直接输入**（一行格式）：
```bash
DB_HOST=localhost;DB_PORT=3306;DB_USER=root;DB_PASSWORD=rootpassword;DB_NAME=testdb;APP_PORT=8080;GIN_MODE=debug
```

> ⚠️ **注意**: Windows 使用 `;` 分隔，macOS/Linux 使用空格或 `:` 分隔

### 步骤 3: 创建多个环境的配置

为每个环境创建单独的 Run Configuration：

#### Development 配置
```
Name: Development
Environment:
  DB_HOST=localhost
  DB_PORT=3306
  DB_USER=root
  DB_PASSWORD=rootpassword
  DB_NAME=testdb
  GIN_MODE=debug
```

#### Test 配置
```
Name: Test
Environment:
  DB_HOST=localhost
  DB_PORT=3306
  DB_USER=root
  DB_PASSWORD=testpassword
  DB_NAME=testdb
  GIN_MODE=test
```

#### Production 配置
```
Name: Production
Environment:
  DB_HOST=production.example.com
  DB_PORT=3306
  DB_USER=produser
  DB_PASSWORD=prodpassword
  DB_NAME=proddb
  GIN_MODE=release
```

---

## 方法 2: 使用 godotenv 库（推荐用于本地开发）

### 安装 godotenv

```bash
go get github.com/joho/godotenv
```

### 更新 main.go

在 `main.go` 开头添加：

```go
package main

import (
    "log"
    "os"
    "web/config"
    "web/controllers"

    "github.com/gin-gonic/gin"
    // 添加 godotenv 导入
    _ "github.com/joho/godotenv/autoload"
)

func getEnv(key, defaultValue string) string {
    value := os.Getenv(key)
    if value == "" {
        return defaultValue
    }
    return value
}

func main() {
    // godotenv/autoload 会自动加载 .env 文件
    // 优先级：.env.local > .env.development > .env

    dbConfig := config.Config{
        Host:     getEnv("DB_HOST", "localhost"),
        Port:     getEnv("DB_PORT", "3306"),
        User:     getEnv("DB_USER", "root"),
        Password: getEnv("DB_PASSWORD", "rootpassword"),
        DBName:   getEnv("DB_NAME", "testdb"),
    }

    // ... 其余代码
}
```

### godotenv 加载优先级

`godotenv/autoload` 会按以下顺序查找并加载第一个找到的文件：

1. `.env.local` - 本地覆盖配置（最高优先级，不提交）
2. `.env.development` - 开发环境
3. `.env.test` - 测试环境
4. `.env.production` - 生产环境
5. `.env` - 默认配置

### 优点

✅ 不需要在 IDE 中配置
✅ 自动加载正确的 `.env` 文件
✅ 与生产环境行为一致
✅ 团队成员无需额外配置

---

## 方法 3: IDE 环境变量配置（全局）

### 步骤 1: 打开设置

```
macOS: GoLand → Settings → Appearance & Behavior → Path Variables
Windows: File → Settings → Appearance & Behavior → Path Variables
```

### 步骤 2: 添加环境变量

虽然 Path Variables 主要用于路径，但你可以在 Go 的设置中配置：

```
Go → Environment
```

添加全局环境变量（不推荐，因为会影响所有项目）

---

## 方法 4: Before Launch 步骤（高级）

### 使用脚本加载环境变量

#### 创建启动脚本

创建文件 `scripts/run.sh`:

```bash
#!/bin/bash

# 加载 .env.development
if [ -f .env.development ]; then
    export $(cat .env.development | xargs)
fi

# 运行 Go 程序
go run main.go
```

#### 配置 Before Launch 外部工具

1. **Run Configuration** → **Before Launch** → **"+"** → **"Run External Tool"**

2. 创建新的外部工具：
   ```
   Name: Load Dev Environment
   Program: /bin/bash
   Arguments: -c "source .env.development && echo $DB_HOST"
   Working directory: $ProjectFileDir$
   ```

⚠️ **注意**: 这种方法比较复杂，推荐使用方法 1 或方法 2

---

## 🎯 推荐配置方案

### 方案 A: 简单项目（直接在 IDE 配置）

**优点**:
- ✅ 简单直接
- ✅ 无需修改代码
- ✅ 适合快速原型开发

**缺点**:
- ❌ 每个环境需要手动配置
- ❌ 团队成员需要重复配置

**适用场景**:
- 个人项目
- 快速原型
- 不需要频繁切换环境

### 方案 B: 使用 godotenv（推荐）

**优点**:
- ✅ 一次配置，处处可用
- ✅ 支持多种环境
- ✅ 与生产环境一致
- ✅ 团队协作友好

**缺点**:
- ❌ 需要添加依赖

**适用场景**:
- 团队项目
- 多环境部署
- 生产环境项目

---

## 📝 完整示例

### 1. 使用 godotenv 的完整配置

#### go.mod
```go
module web

go 1.25

require (
    github.com/gin-gonic/gin v1.10.0
    github.com/joho/godotenv v1.5.1
    gorm.io/driver/mysql v1.5.7
    gorm.io/gorm v1.31.1
)
```

#### main.go
```go
package main

import (
    "log"
    "os"
    "web/config"
    "web/controllers"

    "github.com/gin-gonic/gin"
    _ "github.com/joho/godotenv/autoload"  // 自动加载 .env
)

func main() {
    // godotenv 会自动加载 .env.development 或 .env

    dbConfig := config.Config{
        Host:     os.Getenv("DB_HOST"),
        Port:     os.Getenv("DB_PORT"),
        User:     os.Getenv("DB_USER"),
        Password: os.Getenv("DB_PASSWORD"),
        DBName:   os.Getenv("DB_NAME"),
    }

    // 设置默认值
    if dbConfig.Host == "" {
        dbConfig.Host = "localhost"
    }
    // ... 其他默认值

    log.Printf("Connecting to %s...", dbConfig.Host)

    // ... 其余代码
}
```

#### .env.development
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=rootpassword
DB_NAME=testdb
APP_PORT=8080
GIN_MODE=debug
```

#### .env.test
```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=testpassword
DB_NAME=testdb
GIN_MODE=test
```

#### .env.production
```env
DB_HOST=prod.example.com
DB_PORT=3306
DB_USER=produser
DB_PASSWORD=prodpassword
DB_NAME=proddb
GIN_MODE=release
```

### 2. GoLand Run Configuration

#### 方式 1: 使用 godotenv（无需配置环境变量）

```
Name: Development
Files: main.go
Working directory: /Users/howard/GolandProjects/web
Environment: (留空，godotenv 会自动加载)
```

#### 方式 2: 手动配置环境变量

```
Name: Development (No godotenv)
Files: main.go
Working directory: /Users/howard/GolandProjects/web
Environment:
  DB_HOST=localhost
  DB_PORT=3306
  DB_USER=root
  DB_PASSWORD=rootpassword
  DB_NAME=testdb
  GIN_MODE=debug
```

---

## 🔄 切换环境的方法

### 方法 1: 切换 Run Configuration

1. 点击右上角的下拉菜单
2. 选择不同的配置（Development / Test / Production）
3. 点击运行按钮

### 方法 2: 使用不同的 .env 文件（godotenv）

```bash
# 开发环境
cp .env.development .env
# 点击运行

# 测试环境
cp .env.test .env
# 点击运行

# 生产环境
cp .env.production .env
# 点击运行
```

### 方法 3: 使用软链接（高级）

```bash
# 开发环境
ln -sf .env.development .env

# 测试环境
ln -sf .env.test .env

# 生产环境
ln -sf .env.production .env
```

---

## 🐛 调试技巧

### 1. 打印当前环境变量

在 `main.go` 中添加：

```go
func main() {
    // 打印所有环境变量（调试用）
    for _, env := range os.Environ() {
        if strings.HasPrefix(env, "DB_") || strings.HasPrefix(env, "APP_") {
            log.Println(env)
        }
    }

    // ... 其余代码
}
```

### 2. 检查 godotenv 是否加载成功

```go
import (
    "github.com/joho/godotenv"
    "log"
)

func main() {
    // 手动加载并检查错误
    err := godotenv.Load(".env.development")
    if err != nil {
        log.Println("Warning: .env.development not found, using system env")
    } else {
        log.Println("Loaded .env.development successfully")
    }

    // ... 其余代码
}
```

---

## 📚 总结

| 方法 | 难度 | 灵活性 | 推荐度 |
|------|------|--------|--------|
| Run Configuration | ⭐ 简单 | ⭐⭐ 中等 | ⭐⭐⭐ |
| godotenv | ⭐⭐ 中等 | ⭐⭐⭐⭐ 高 | ⭐⭐⭐⭐⭐ |
| IDE 全局配置 | ⭐ 简单 | ⭐ 低 | ⭐⭐ |
| Before Launch | ⭐⭐⭐ 复杂 | ⭐⭐⭐ 高 | ⭐⭐ |

**个人推荐**: 使用 **godotenv** + **Run Configuration** 的组合方案

---

## 🔗 相关资源

- [godotenv GitHub](https://github.com/joho/godotenv)
- [GoLand Run Configuration](https://www.jetbrains.com/help/go/create-a-run-configuration-in-go-module.html)
- [Go Environment Variables](https://pkg.go.dev/os#Getenv)
