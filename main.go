package main

import (
	"crypto/sha256"
	"encoding/hex"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"

	"github.com/gorilla/mux"
	"github.com/prometheus/client_golang/prometheus"
)

var (
	Version   string
	GitCommit string
)

func main() {
	var help bool
	flag.BoolVar(&help, "help", false, "Show help")

	fmt.Printf("hash-browns by Alex Ellis\nVersion: %s\tCommit: %s\n", Version, GitCommit)
	if help {
		fmt.Printf("See %s for more.\n", "https://github.com/alexellis/hash-browns")

		os.Exit(0)
	}

	histogram := prometheus.NewHistogramVec(prometheus.HistogramOpts{
		Name: "hash_seconds",
		Help: "Time taken to create hashes",
	}, []string{"code"})

	r := mux.NewRouter()
	r.Handle("/metrics", prometheusHandler())
	r.Handle("/hash", hashHandler(histogram))

	r.HandleFunc("/healthz", func(w http.ResponseWriter, rr *http.Request) {
		w.WriteHeader(http.StatusOK)
	})

	r.HandleFunc("/", func(w http.ResponseWriter, rr *http.Request) {
		w.Write([]byte(`<html>
<body>
	<h2>hash-browns</h2>
	<p>Endpoints:</p>
	<ul>
		<li>GET: <a href="/metrics">/metrics</a></li>
		<li>POST: <a href="/hash">/hash</a></li>
	</ul>
	<p>By Alex Ellis: <a href="https://github.com/alexellis/hash-browns">Fork/Star on GitHub</a></p>
</body>
</html>`))
	})

	prometheus.Register(histogram)

	port := "8080"
	if val, ok := os.LookupEnv("port"); ok && len(val) > 0 {
		port = val
	}

	s := &http.Server{
		Addr:           fmt.Sprintf(":%s", port),
		ReadTimeout:    3 * time.Second,
		WriteTimeout:   3 * time.Second,
		MaxHeaderBytes: 1 << 20,
		Handler:        r,
	}

	log.Printf("Listening on port: %s\n", port)

	log.Fatal(s.ListenAndServe())
}

func prometheusHandler() http.Handler {
	return prometheus.Handler()
}

func computeSum(body []byte) []byte {
	h := sha256.New()

	h.Write(body)
	hashed := hex.EncodeToString(h.Sum(nil))
	return []byte(hashed)
}

func hashHandler(histogram *prometheus.HistogramVec) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		start := time.Now()
		defer r.Body.Close()
		code := http.StatusInternalServerError

		defer func() { // Make sure we record a status.
			duration := time.Since(start)
			histogram.WithLabelValues(fmt.Sprintf("%d", code)).Observe(duration.Seconds())
		}()

		code = http.StatusMethodNotAllowed
		if r.Method != http.MethodPost {
			w.WriteHeader(code)
			w.Write([]byte("Method not allowed"))
			return
		}

		w.WriteHeader(http.StatusOK)
		body, _ := ioutil.ReadAll(r.Body)

		hashed := computeSum(body)

		log.Printf("Hash for: %q - %q\n", string(body), string(hashed))

		w.Write(hashed)
	}
}
