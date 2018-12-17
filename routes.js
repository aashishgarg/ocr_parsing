// require('./routes/auth');

const app    = module.exports = require('express')();
const config = require('./config');

var appConf = config.app;

app.get('/', function(req, res) {
  res.send({ msg: 'Server is up and running!' });
});

app.use('/auth', require('./routes/auth'));

app.all('*', function(req, res) {
  res.status(404).send({ msg: 'Not found' });
});

// Mount the server
var server = app.listen(appConf.port, appConf.host, () => {
  console.log(`Server running at http://${appConf.host}:${appConf.port}`);
  // printIp();
});

