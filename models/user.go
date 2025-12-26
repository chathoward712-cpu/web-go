package models

import (
	"gorm.io/gorm"
	"time"
)

// User 用户模型
type User struct {
	ID        uint           `gorm:"primarykey" json:"id"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `gorm:"index" json:"deleted_at,omitempty"`
	Name      string         `gorm:"size:100;not null" json:"name"`
	Email     string         `gorm:"size:100;uniqueIndex;not null" json:"email"`
	Age       int            `json:"age"`
}

// TableName 指定表名
func (User) TableName() string {
	return "users"
}
