package main

import "server/api"
import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()

	// Register endpoint and handler
	r.POST("/account", api.CreateAccount)
	r.GET("/account", api.GetAccount)

	// run HTTP server
	r.Run("0.0.0.0:8080")
}
