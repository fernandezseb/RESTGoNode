package main

import (
	"encoding/json"
	"log"
	"time"
	"net/http"
	"io/ioutil"
	"os"
	"fmt"
	"strconv"
	"math/rand"
	"github.com/gorilla/mux"
)

type Note struct {
	Id int
	Title string
	Content string
	CreateDate time.Time
	ModifiedDate time.Time
	UserId int
}

var notes []Note
var userNotes [][]Note
var r1 *rand.Rand

func getNotes() []Note {
    raw, err := ioutil.ReadFile("./output.json")
    if err != nil {
        fmt.Println(err.Error())
        os.Exit(1)
    }
    
    var list []Note
    json.Unmarshal(raw,&list)
    return list
}

func getUserNotes() [][]Note {
    var userList [][]Note
    for i := 0; i < 100; i++ {
        raw, err := ioutil.ReadFile("./users/user_"+strconv.Itoa(i)+".json")
        if err != nil {
            fmt.Println(err.Error())
            os.Exit(1)
        }
        
        var list []Note
        json.Unmarshal(raw,&list)
        userList = append(userList, list)
    }
    return userList
}

func main() {
    s1 := rand.NewSource(time.Now().UnixNano())
    r1 = rand.New(s1)
	router := mux.NewRouter()
	notes = getNotes()
	userNotes = getUserNotes()

    
	router.HandleFunc("/notes", GetNotes).Methods("GET")
	router.HandleFunc("/note/{id}", GetNote).Methods("GET")
	server := &http.Server{Addr: ":8000", Handler: router}
	server.SetKeepAlivesEnabled(false)
	log.Fatal(server.ListenAndServe())
}

func GetNotes(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(userNotes[r1.Intn(100)])
}

func GetNote(w http.ResponseWriter, r *http.Request) {
    w.Header().Set("Content-Type", "application/json")
    params := mux.Vars(r)
    id, err := strconv.Atoi(params["id"])
    if err != nil {
        fmt.Println(err.Error())
        os.Exit(1)
    }
    json.NewEncoder(w).Encode(notes[id])
}
