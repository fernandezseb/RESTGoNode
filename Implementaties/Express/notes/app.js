const express = require('express')
const app = express()

var routes = require("./routes/routes.js")

app.use(function(req, res, next) {
    res.setHeader('Connection', 'close');
    next();
});
routes(app);

var server = app.listen(3000, function() {
  console.log("running on port ", server.address().port);
});
