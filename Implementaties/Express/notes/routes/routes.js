var fs = require('fs');

var notes = [];

function getRandomInt(max) {
  return Math.floor(Math.random() * Math.floor(max));
}

for (var i = 0; i < 100; i++) {
    notes.push(JSON.parse(fs.readFileSync('data/users/user_'+i+'.json', 'utf8')));
}

var allnotes= JSON.parse(fs.readFileSync('data/output.json', 'utf8'))

var appRouter = function(app) {

    app.get("/notes", function(req, res){
        res.status(200).json(notes[getRandomInt(100)]);
    });

    app.get("/note/:id", function(req, res) {
        var id = req.params.id;
        //console.log("sending request with id: ", id)
        res.status(200).json(allnotes[id]);
    })

    app.post("/note/new", function(req,res) {
        //console.log(req.body.title, req.body.content);
        res.status(200).json({title: req.body.title, content: req.body.content});
    })

}

module.exports = appRouter;
