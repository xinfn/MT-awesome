package main

import "server/api"
import "github.com/gin-gonic/gin"

func initRoute(group *gin.RouterGroup) {
	group.POST("/account", api.CreateAccount)
	group.GET("/account", api.GetAccount)
}

func main() {
	r := gin.Default()

	// Normal routing
	initRoute(r.Group("/"))

	// Route for CICD path start with /bxx/
	initRoute(r.Group("/b:id"))

	// run HTTP server
	r.Run("0.0.0.0:8080")
}
