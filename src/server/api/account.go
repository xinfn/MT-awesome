// Package api implements a set of HTTP interfaces to access the account.
package api

import "net/http"
import "server/service"
import "github.com/gin-gonic/gin"

// Return 200 Code for aws's alb health check
func SeviceHealthCheck(c *gin.Context) {
	c.String(http.StatusOK, "")
	return
}

// Create an account with the given name and password
func CreateAccount(c *gin.Context) {
	name := c.Query("name")
	password := c.Query("password")

	// Parameter invalid
	if len(name) == 0 || len(password) < 6 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "parameter invalid"})
		return
	}

	if !service.CreateAccount(name, password) {
		c.JSON(http.StatusBadRequest, gin.H{"error": "create failed"})
		return
	}

	c.String(200, "")
	return
}

// Return account detial information
func GetAccount(c *gin.Context) {
	//c.JSON(http.StatusNotImplemented, gin.H{"error": "method not implemented"})
	c.JSON(http.StatusOK, gin.H{"account": "MT"})
	return
}
