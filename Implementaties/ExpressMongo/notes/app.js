const express = require('express')
const app = express()

var routes = require("./routes/routes.js")

var db = require('./db')

// DB URL
const url = 'mongodb://192.168.2.10:27017'
const dbName = 'notes'

app.use(function(req, res, next) {
  res.setHeader('Connection', 'close');
  next();
});

routes(app);

db.connect(url, dbName, function(err) {
  if (err) {
    console.log('Unable to connect to Mongo.')
    process.exit(1)
  } else {
    var server = app.listen(3000, function() {
      console.log("running on port ", server.address().port);
    });
  }
})




