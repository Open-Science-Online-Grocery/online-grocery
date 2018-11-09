var express = require('express');
var path = require('path');
var api = require('./api/index')
var db = require('./db/index')
var bodyParser = require('body-parser');
var app = express();
var cors = require('cors');
app.use(cors());

app.use(express.static('build'));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

app.use('/', api);

app.get('*', function (request, response){
    response.sendFile(path.resolve(__dirname, 'public', 'index.html'))
});

app.use(function(err, req, res, next) {
  console.log('there was a problem', err);
  res
    .status(err.status || 500)
    .send(err.message || 'uh-oh.');
});

app.listen(process.env.PORT || 80, function() {
		  console.log('listening on port 80');
});

module.exports = app
