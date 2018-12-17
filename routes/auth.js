const app = module.exports = require('express')();
const {login, logout} = require('../app/actions/auth');

app.post('/login', (req, res) => {
  console.log(req)
  console.log(req.body)
  console.log(req.query)
  console.log(req.params)
  login(req.body)
    .then(({token, user, projects}) => res.send({
      token,
      user: omit(user, 'password'),
      projects
    }))
    .catch(() => {
      res.status(400).send({ error: 'Login failed!' });
    });
});

// ToDo: Make it DELETE
app.get('/logout', (req, res) => {
  logout(req.query).then(() => res.send({ msg: 'Logged out!' }));
});
