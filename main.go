package main

import (
	"log"
	"os"
	"web/config"
	"web/controllers"

	"github.com/gin-gonic/gin"
)

func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}

func main() {
	// 初始化数据库连接（从环境变量读取配置）
	dbConfig := config.Config{
		Host:     getEnv("DB_HOST", "localhost"),
		Port:     getEnv("DB_PORT", "3306"),
		User:     getEnv("DB_USER", "root"),
		Password: getEnv("DB_PASSWORD", "rootpassword"),
		DBName:   getEnv("DB_NAME", "testdb"),
	}

	if err := config.InitDB(dbConfig); err != nil {
		log.Fatalf("Failed to initialize database: %v", err)
	}

	// 创建 Gin 路由
	r := gin.Default()

	// 健康检查
	r.GET("/health", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"status": "ok",
		})
	})

	// 用户路由组
	userRoutes := r.Group("/api/users")
	{
		userRoutes.POST("", controllers.CreateUser)       // 创建用户
		userRoutes.GET("", controllers.GetUsers)          // 获取所有用户
		userRoutes.GET("/:id", controllers.GetUserByID)   // 根据 ID 获取用户
		userRoutes.PUT("/:id", controllers.UpdateUser)    // 更新用户
		userRoutes.DELETE("/:id", controllers.DeleteUser) // 删除用户
	}

	// 启动服务器
	log.Println("Server starting on :8080")
	if err := r.Run(":8080"); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
