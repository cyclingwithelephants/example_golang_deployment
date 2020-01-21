package main

import (
	"fmt"
	"net/http"
	"os"
)

type miniHTTPServer struct{}

// Fit the `http.Handler` interface by implementing the standard ServeHTTP method
func (s miniHTTPServer) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// Send a string back to the requester
	w.Write([]byte("Mini HTTP server in Go!"))
}

func main() {

	port := os.getenv("PORT")

	// The http.ListenAndServe function will listen on the port and route all HTTP requests to our http.Handler implementation: miniHTTPServer
	fmt.Println("Listening on port 8080 ...")
	if err := http.ListenAndServe(":8080", miniHTTPServer{}); err != nil {
		fmt.Println("An error occurred listening on port 8080:", err)
		os.Exit(1) // Exit with an error code
	}
	fmt.Println("Exited gracefully") // This won't happen, because either the program will exit or there will be an error
}
