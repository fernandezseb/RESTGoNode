var fs = require('fs');
var faker = require('faker');

var bigSet = [];

var d = new Date("July 21, 1983 01:15:00:526");
var n = d.getMilliseconds();

faker.seed(n);
var id = 1;
for(var i = 100; i >= 0; i--) {
  var smallSet = [];
  for(var j = 10; j >= 0; j--) {
    var note = {
      id: id,
	  title: faker.random.words(10),
	  content: faker.random.words(10),
	  createDate: faker.date.past(),
	  modifiedDate: faker.date.recent(),
	  userId: i
    };
    bigSet.push(note);
    smallSet.push(note);
    id++;
  }
  fs.writeFile(__dirname + '/users/user_'+i+'.json',  JSON.stringify(smallSet), function() {
  console.log("user posts generated successfully!");
  });
};

fs.writeFile(__dirname + '/output.json',  JSON.stringify(bigSet), function() {
  console.log("bigDataSet generated successfully!");
});
