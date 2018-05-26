var fs = require('fs');

var notes = [];

var db = require('../db')

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

var appRouter = function(app) {

    app.get("/notes", function(req, res){
        var collection = db.get().collection('notes')
        collection.find({userId: getRandomInt(100)}).toArray(function(err, docs) {
            res.status(200).json(docs);
        })
    });

    app.get("/note/:id", function(req, res) {
        var id = parseInt(req.params.id);
        var collection = db.get().collection('notes')
        collection.findOne({id: id}, function(err, doc) {
            res.status(200).json(doc);
        });
    })

    /*
    app.post("/note/new", function(req,res) {
        //console.log(req.body.title, req.body.content);
        res.status(200).json({title: req.body.title, content: req.body.content});
    })
    */

}

module.exports = appRouter;
