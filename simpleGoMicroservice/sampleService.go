package main

import (
	"fmt"
	"net/http"
	"net"
)

func getIP(w http.ResponseWriter, req *http.Request) string {
	returnValue := "window.ipaddr="
	ip, port, err := net.SplitHostPort(req.RemoteAddr)
	_ = port
	if err == nil {
		userIP := net.ParseIP(ip)
		if userIP == nil {
			return returnValue + "'';"
		}
		forward := req.Header.Get("X-Forwarded-For")
		if len(forward) > 0 {
			return returnValue + "'" + forward + "';"
		}
		if len(ip) > 0 {
			return returnValue + "'" + ip + "';"
		}
	}
	return returnValue + "'';"
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, getIP(w, r))
}

func main() {
	http.HandleFunc("/", handler)
	http.ListenAndServeTLS(":443", "SSL.cer", "measure.agilemeasure.com.key", nil)
}
