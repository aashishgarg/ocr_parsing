const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const session = require('express-session');
const cors = require('cors');
const mongoose = require('mongoose');
const errorHandler = require('errorhandler');
const config = require('./config');

// Configure mongoose's promise to global promise
mongoose.promise = global.Promise;

// Configure isProduction variable
const isProduction = (process.env.NODE_ENV === 'production');

// Initiate our app
const app = express();
const appConf = config.app;

// Configure our app
app.use(cors());
app.use(require('morgan')('dev')); // HTTP request logger
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());
app.use(express.static(path.join(__dirname, 'public')));
app.use(session({
  secret: 'pittohiosecrettrantorpetuum',
  cookie: { maxAge: 60000 },
  resave: false,
  saveUninitialized: false
}));

if(!isProduction) {
  app.use(errorHandler());
}

// Configure Mongoose
mongoose.connect('mongodb://localhost/pittohio', { useNewUrlParser: true });
mongoose.set('debug', true);

// Models and routes
require('./models/Users');
require('./config/passport');
app.use(require('./routes/index'));

// Error handlers & middlewares
if(!isProduction) {
  app.use((req, res, err) =>{
    res.status(err.status || 500);

    res.json({
      errors: {
        message: err.message,
        error: err,
      },
    });
  });
}

app.use((req, res, err) => {
  res.status(err.status || 500);

  res.json({
    errors: {
      message: err.message,
      error: {},
    },
  });
});

// Mount the server
app.listen(appConf.port, appConf.host, () => {
  console.log(`Server running at http://${appConf.host}:${appConf.port}`);
});
