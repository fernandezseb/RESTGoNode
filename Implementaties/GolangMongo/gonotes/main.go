package main

import (
	"encoding/json"
	"fmt"
	"log"
	"math/rand"
	"net/http"
	"os"
	"strconv"
	"time"

	"gopkg.in/mgo.v2"
	"gopkg.in/mgo.v2/bson"

	"github.com/gorilla/mux"
)

type Note struct {
	Id           int
	Title        string
	Content      string
	CreateDate   time.Time
	ModifiedDate time.Time
	UserId       int
}

var db *mgo.Database

var r1 *rand.Rand

func main() {
	s1 := rand.NewSource(time.Now().UnixNano())
	r1 = rand.New(s1)
	router := mux.NewRouter()

	session, err := mgo.Dial("mongodb://192.168.2.10:27017")
	if err != nil {
		log.Fatal(err)
	}
	db = session.DB("notes")

	router.HandleFunc("/notes", GetNotes).Methods("GET")
	router.HandleFunc("/note/{id}", GetNote).Methods("GET")
	server := &http.Server{Addr: ":8000", Handler: router}
	server.SetKeepAlivesEnabled(false)
	log.Fatal(server.ListenAndServe())
}

func GetNotes(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var notes []Note
	err := db.C("notes").Find(bson.M{"userId": r1.Intn(100)}).All(&notes)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(notes)
}

func GetNote(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	var note Note
	params := mux.Vars(r)
	id, err := strconv.Atoi(params["id"])
	if err != nil {
		fmt.Println(err.Error())
		os.Exit(1)
	}
	err = db.C("notes").Find(bson.M{"id": id}).One(&note)
	if err != nil {
		log.Fatal(err)
	}
	json.NewEncoder(w).Encode(note)
}
