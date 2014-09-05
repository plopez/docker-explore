var express = require('express');

// Constants
var PORT = process.env.PORT0 || 3000;

var request = require('request');
var util = require('util');

// App
var app = express();
app.get('/', function (req, res) {
  res.send('Hello world\n');
});

app.get('/exploreSystem', function (req, res) {
  request('http://localhost:8500/v1/kv/config?recurse', function (error, response, body) {
    if (!error && response.statusCode == 200) {
      var pairs = JSON.parse(body);
      var result ="";
      for(var pair in pairs){
        result+=pairs[pair].Key;
	result+="=";
	result+=new Buffer(pairs[pair].Value, 'base64').toString('ascii');
	result+="\n";
      }
      res.send(result);
    }
  })
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
