// const {
//   findByUsername,
//   findUserById,
//   getUserProjects
// } = require('./users');

// const session = require('session');

function login(data) {
  return validateLogin(data).then((error) => {
    return error ? (
      Promise.reject(error)
  ) : (
      { msg: "logged in" }
    )
  })
}

function logout(data) {
  return new Promise((resolve, _) => {
    data.authKey = null

    resolve('Logged Out!');
  })
    .catch((error) => {
      reject('Opps! Something went wrong.');
    });
}

function validateLogin(data) {
  if(data.username == 'trantoruser' && password == 'trantorpwd') {
    { authKey: 'attentionIamdummykey' }
  } else {
    throw new Error('Unauthenticated user')
  }
}

module.exports = { login, logout }
