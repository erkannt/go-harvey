package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"

	"github.com/google/uuid"
	_ "github.com/mattn/go-sqlite3"
)

func main() {
	db, err := sql.Open("sqlite3", "./data/state.db")
	if err != nil {
		fmt.Printf("Error opening database: %v\n", err)
		return
	}
	defer db.Close()

	_, err = db.Exec(`
  PRAGMA journal_mode=wal;
	CREATE TABLE IF NOT EXISTS test (id INTEGER PRIMARY KEY, value INT)
	`)
	if err != nil {
		log.Fatal(err)
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		insertRow(db, w)
	})

	fmt.Println("Server running at http://localhost:8080/")
	http.ListenAndServe(":8080", nil)
}

func insertRow(db *sql.DB, w http.ResponseWriter) {
	_, err := db.Exec(`INSERT INTO test (value) VALUES (?)`, uuid.NewString())
	if err != nil {
		fmt.Println(err)
		http.Error(w, "Insert failed", http.StatusInternalServerError)
		return
	}
	fmt.Fprint(w, "inserted")
}
