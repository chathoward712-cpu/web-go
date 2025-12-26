# Go 语言命名规范

本文档介绍 Go 语言的官方命名规范和最佳实践。

## 📚 目录

- [基本原则](#基本原则)
- [包命名](#包命名)
- [文件命名](#文件命名)
- [变量命名](#变量命名)
- [常量命名](#常量命名)
- [函数命名](#函数命名)
- [接口命名](#接口命名)
- [类型命名](#类型命名)
- [结构体命名](#结构体命名)
- [控制器命名](#控制器命名)
- [常见错误](#常见错误)

---

## 🎯 基本原则

### 1. 可见性规则

Go 通过**首字母大小写**控制访问权限：

```go
// ✅ 公开（Public）- 首字母大写
// 可以被其他包访问
func CreateUser() {}
type User struct {}
const MaxCount = 100
var GlobalVar string

// ❌ 私有（Private）- 首字母小写
// 只能在当前包内访问
func createUser() {}
type user struct {}
const maxCount = 10
var globalVar string
```

### 2. 命名核心原则

> **"Names should be as short as possible, but no shorter."**
> —— 名字应该尽可能短，但不要太短。

- ✅ **清晰优先于简洁**
- ✅ **一致性优先于个性**
- ✅ **可读性优先于便捷性**

---

## 📦 包命名

### 规则

1. **全小写**
2. **单个单词**
3. **简短、有意义**
4. **不使用下划线或驼峰**

### ✅ 正确示例

```go
package controllers  // 控制器包
package models       // 数据模型包
package config       // 配置包
package utils        // 工具包
package user         // 用户相关
package http         // HTTP 相关
```

### ❌ 错误示例

```go
package controller      // 应该用复数 controllers
package Models          // ❌ 不能大写
package user_controller // ❌ 不应该用下划线
package usr             // ❌ 过度缩写
package myPackage       // ❌ 驼峰命名
```

### 包名建议

| 场景 | 推荐包名 | 说明 |
|------|---------|------|
| 数据模型 | `models` | 存放数据结构 |
| 控制器 | `controllers` | 处理请求 |
| 配置 | `config` | 配置相关 |
| 工具函数 | `utils` 或 `util` | 通用工具 |
| 数据库 | `database` 或 `db` | 数据库操作 |
| HTTP 服务 | `http` 或 `server` | HTTP 服务 |
| 认证授权 | `auth` | 认证相关 |

---

## 📄 文件命名

### 规则

1. **全小写**
2. **使用下划线分隔**
3. **以功能命名，不以类型命名**

### ✅ 正确示例

```bash
user_controller.go       # 用户控制器
user_service.go          # 用户服务
user_repository.go       # 用户数据访问
database.go              # 数据库配置
redis.go                 # Redis 配置
middleware_auth.go       # 认证中间件
```

### ❌ 错误示例

```bash
userController.go        # ❌ 不应该用驼峰
user-controller.go       # ❌ 不应该用连字符
UserController.go        # ❌ 不应该大写
user.go                  # ⚠️ 如果包含多个类型，应该更具体
```

### 特殊文件名

```bash
go.mod                   # Go 模块文件
go.sum                   # 依赖校验和
Makefile                 # Make 文件（注意大小写）
Dockerfile               # Docker 文件（注意大小写）
```

---

## 🔤 变量命名

### 局部变量

#### 规则
- **驼峰命名法（camelCase）**
- **简短、有意义**
- **避免缩写**（除非是通用缩写）

#### ✅ 正确示例

```go
// 单个单词
func process() {
    user := getUser()
    count := 0
    index := 0
    err := nil
}

// 多个单词
func createUser() {
    userName := "John"
    userEmail := "john@example.com"
    userID := 123
    isActive := true
}
```

#### ❌ 错误示例

```go
func process() {
    var u *User           // ❌ 过度缩写
    var cnt int           // ❌ 不必要的缩写
    var idx int           // ❌ 不必要的缩写
    var user_name string  // ❌ 不应该用下划线（snake_case）
    var UserName string   // ❌ 局部变量不应大写（PascalCase）
}
```

### 全局变量

#### 规则
- **尽量减少使用**
- **必须大写开头**（如果需要跨包访问）
- **添加说明注释**

#### ✅ 正确示例

```go
var (
    // DB 数据库连接实例
    DB *gorm.DB

    // RedisClient Redis 客户端
    RedisClient *redis.Client
)
```

### 参数和返回值

#### ✅ 正确示例

```go
// 函数参数：简短、清晰
func GetUser(id int) (*User, error) {
    return nil, nil
}

func CreateUser(name string, email string) (*User, error) {
    return nil, nil
}

// 多个参数时，保持一致性
func CompareUser(user1, user2 *User) bool {
    return false
}
```

#### ❌ 错误示例

```go
func GetUser(user_id int) (*User, error) {  // ❌ 参数用下划线
    return nil, nil
}

func CreateUser(UserName string) (*User, error) {  // ❌ 参数大写
    return nil, nil
}
```

### 上下文变量（Context）

Go 社区的惯例：

```go
// ✅ 推荐：使用 ctx 作为上下文变量名
func GetUser(ctx context.Context, id int) (*User, error) {
    return nil, nil
}

// ❌ 不推荐
func GetUser(context context.Context, id int) (*User, error) {
    return nil, nil
}
```

---

## 🔢 常量命名

### 规则

- **全大写**
- **使用下划线分隔**
- **私有常量可以驼峰**

### ✅ 正确示例

```go
// 公开常量：全大写 + 下划线
const (
    MAX_CONNECTION_COUNT = 100
    DEFAULT_TIMEOUT      = 30
    API_VERSION          = "v1"
)

// 私有常量：驼峰命名
const (
    maxRetryCount = 3
    defaultPort   = 8080
)

// iota 枚举：驼峰命名
const (
    StatusActive   = 1
    StatusInactive = 0
    StatusDeleted  = -1
)
```

### ❌ 错误示例

```go
const (
    max_count = 100      // ❌ 公开常量不应小写
    MaxCount  = 100      // ⚠️ 常量通常全大写
    maxcount  = 100      // ❌ 难以阅读
)
```

---

## 🔧 函数命名

### 规则

1. **动词开头**
2. **驼峰命名法**
3. **公开函数首字母大写**
4. **私有函数首字母小写**

### ✅ 正确示例

```go
// CRUD 操作：动词 + 名词
func CreateUser(user *User) error {     // 创建
    return nil
}

func GetUser(id int) (*User, error) {  // 获取
    return nil, nil
}

func UpdateUser(user *User) error {    // 更新
    return nil
}

func DeleteUser(id int) error {        // 删除
    return nil
}

func GetUsers() ([]User, error) {      // 获取列表（复数）
    return nil, nil
}

func GetUserByID(id int) (*User, error) {  // 根据 ID 获取
    return nil, nil
}

func GetUserByEmail(email string) (*User, error) {
    return nil, nil
}

// 私有函数
func validateUser(user *User) error {
    return nil
}

func parseUserData(data string) (*User, error) {
    return nil, nil
}
```

### ❌ 错误示例

```go
func user_create() {}              // ❌ 下划线命名
func User_Create() {}              // ❌ 混合风格
func createuser() {}               // ❌ 缺少分隔
func Create_User() {}              // ❌ 下划线命名
func createUser() {}               // ⚠️ 如果需要公开，应该大写
```

### 常见动词前缀

| 动词 | 含义 | 示例 |
|------|------|------|
| `Get` | 获取 | `GetUser()`, `GetUsers()` |
| `Create` | 创建 | `CreateUser()`, `CreateOrder()` |
| `Update` | 更新 | `UpdateUser()`, `UpdateProfile()` |
| `Delete` | 删除 | `DeleteUser()`, `RemoveFile()` |
| `List` | 列表 | `ListUsers()`, `ListOrders()` |
| `Find` | 查找 | `FindUserByName()`, `FindById()` |
| `Validate` | 验证 | `ValidateEmail()`, `ValidateInput()` |
| `Parse` | 解析 | `ParseJSON()`, `ParseToken()` |
| `Format` | 格式化 | `FormatDate()`, `FormatJSON()` |
| `Check` | 检查 | `CheckPermission()`, `CheckExists()` |
| `Handle` | 处理 | `HandleRequest()`, `HandleError()` |
| `Process` | 处理 | `ProcessData()`, `ProcessPayment()` |

---

## 🎭 接口命名

### 规则

1. **单方法接口：方法名 + -er 后缀**
2. **多方法接口：描述性名称**

### ✅ 正确示例

```go
// 单方法接口：动词 + er
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Writer interface {
    Write(p []byte) (n int, err error)
}

type Stringer interface {
    String() string
}

type Handler interface {
    Handle()
}

// 多方法接口：描述性名称
type User interface {
    GetID() int
    GetName() string
    SetName(name string)
    Save() error
}

type Database interface {
    Connect() error
    Close() error
    Query(sql string, args ...interface{}) (*sql.Rows, error)
}
```

### ❌ 错误示例

```go
type IReader {}         // ❌ 不应该用 I 前缀（那是 C# 风格）
type ReaderInterface {} // ❌ 不需要 Interface 后缀
type readInterface {}   // ❌ 接口名应该大写
```

---

## 🏗️ 类型命名

### 规则

- **驼峰命名法**
- **公开类型首字母大写**
- **私有类型首字母小写**
- **避免缩写**

### ✅ 正确示例

```go
// 基本类型
type User struct {}
type UserService struct {}
type UserRepository struct {}

type Server struct {}
type Client struct {}

// 错误类型
type ValidationError struct {}
type TimeoutError struct {}

// 接口类型
type Reader interface {}
type Writer interface {}
```

### ❌ 错误示例

```go
type user struct {}          // ⚠️ 如果需要公开，应该大写
type usr struct {}           // ❌ 过度缩写
type user_srv struct {}      // ❌ 不应该用下划线
type UserSrv struct {}       // ❌ 避免缩写
type IUser struct {}         // ❌ 不应该用 I 前缀
```

---

## 📦 结构体命名

### 字段命名规则

```go
// ✅ 正确：大写开头的字段是公开的
type User struct {
    ID        uint      `json:"id"`
    Name      string    `json:"name"`
    Email     string    `json:"email"`
    Age       int       `json:"age"`
    CreatedAt time.Time `json:"created_at"`
    UpdatedAt time.Time `json:"updated_at"`
}

// ✅ 正确：小写开头的字段是私有的
type user struct {
    id       uint
    password string
}

// ❌ 错误：字段不应该用下划线
type User struct {
    user_id   uint   // ❌
    user_name string // ❌
}
```

### 结构体标签（Tags）

```go
type User struct {
    // JSON 标签：小写 + 下划线
    ID       uint   `json:"id"`
    UserName string `json:"user_name"`

    // GORM 标签
    Email    string `gorm:"size:100;uniqueIndex;not null"`
    Password string `gorm:"-"` // "-" 表示不序列化

    // 数据库标签
    CreatedAt time.Time `json:"created_at" gorm:"autoCreateTime"`
}
```

---

## 🎮 控制器命名

### 当前项目的控制器命名

```go
// ✅ 正确：文件名 user_controller.go
// ✅ 正确：包名 controllers
// ✅ 正确：函数名 CreateUser (大写开头，公开)

package controllers

// CreateUser 创建用户
func CreateUser(c *gin.Context) {}

// GetUsers 获取所有用户
func GetUsers(c *gin.Context) {}

// GetUserByID 根据 ID 获取用户
func GetUserByID(c *gin.Context) {}

// UpdateUser 更新用户
func UpdateUser(c *gin.Context) {}

// DeleteUser 删除用户
func DeleteUser(c *gin.Context) {}
```

### 控制器命名模式

#### 模式 1：简单 CRUD（当前使用）

```go
func CreateUser(c *gin.Context) {}
func GetUser(c *gin.Context) {}
func GetUsers(c *gin.Context) {}
func UpdateUser(c *gin.Context) {}
func DeleteUser(c *gin.Context) {}
```

#### 模式 2：带资源前缀（更明确）

```go
func UserCreate(c *gin.Context) {}
func UserGet(c *gin.Context) {}
func UserList(c *gin.Context) {}
func UserUpdate(c *gin.Context) {}
func UserDelete(c *gin.Context) {}
```

#### 模式 3：使用结构体（推荐大型项目）

```go
type UserController struct {
    DB *gorm.DB
}

func (ctrl *UserController) Create(c *gin.Context) {}
func (ctrl *UserController) Get(c *gin.Context) {}
func (ctrl *UserController) List(c *gin.Context) {}
func (ctrl *UserController) Update(c *gin.Context) {}
func (ctrl *UserController) Delete(c *gin.Context) {}

// 路由
userController := &UserController{DB: db}
userRoutes := r.Group("/api/users")
{
    userRoutes.POST("", userController.Create)
    userRoutes.GET("", userController.List)
    userRoutes.GET("/:id", userController.Get)
    userRoutes.PUT("/:id", userController.Update)
    userRoutes.DELETE("/:id", userController.Delete)
}
```

---

## ❌ 常见错误

### 1. 下划线命名（snake_case）

```go
// ❌ 错误
func create_user() {}
var user_name string

// ✅ 正确
func CreateUser() {}
var userName string
```

### 2. 过度缩写

```go
// ❌ 错误
func usrCrt() {}
var usrID int

// ✅ 正确
func CreateUser() {}
var userID int
```

### 3. 不必要的类型前缀

```go
// ❌ 错误（匈牙利命名法）
type strUser string
type intUserID int
var mapUserCache map[string]*User

// ✅ 正确
type UserName string
type UserID int
var userCache map[string]*User
```

### 4. 接口名带 I 前缀

```go
// ❌ 错误（C# 风格）
type IUserInterface interface {}

// ✅ 正确（Go 风格）
type User interface {}
```

### 5. 包名重复

```go
// ❌ 错误
package models

type UserModel struct {}  // 冗余：models.UserModel

// ✅ 正确
package models

type User struct {}  // 简洁：models.User
```

### 6. 全大写变量名

```go
// ❌ 错误
var USER_COUNT int

// ✅ 正确
const MaxUserCount = 100
var userCount int
```

---

## 📋 命名检查清单

在提交代码前，检查以下项目：

- [ ] 包名全小写
- [ ] 文件名全小写 + 下划线
- [ ] 公开函数/类型首字母大写
- [ ] 私有函数/类型首字母小写
- [ ] 变量使用驼峰命名
- [ ] 没有使用下划线命名（除了文件名）
- [ ] 没有过度缩写
- [ ] 接口名没有 I 前缀
- [ ] 常量全大写（公开）或驼峰（私有）
- [ ] 结构体字段大小写符合访问控制要求

---

## 🔗 参考资料

- [Go Code Review Comments](https://github.com/golang/go/wiki/CodeReviewComments)
- [Effective Go - Names](https://go.dev/doc/effective_go#names)
- [Go Proverbs](https://go-proverbs.github.io/)
- [Golang Code Convention](https://github.com/uber-go/guide/blob/master/style.md)

---

## 🎯 总结

| 类型 | 命名风格 | 示例 |
|------|---------|------|
| 包名 | 小写 | `controllers`, `models` |
| 文件名 | 小写 + 下划线 | `user_controller.go` |
| 函数名 | 驼峰 | `CreateUser`, `getUser` |
| 变量名 | 驼峰 | `userName`, `userID` |
| 常量名 | 全大写或驼峰 | `MAX_COUNT`, `maxRetry` |
| 类型名 | 驼峰 | `User`, `UserService` |
| 接口名 | 驼峰 / 动词+er | `Reader`, `Writer` |
| 结构体字段 | 驼峰 | `UserName`, `Email` |

**记住**：一致性比个人风格更重要！
