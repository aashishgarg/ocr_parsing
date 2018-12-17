const env = process.env.NODE_ENV;

const dev = {
  app: {
    baseUrl: 'localhost',
    host: '127.0.0.1',
    port: 8081
  },

  // db: {
  //   host: 'localhost',
  //   port: 27017,
  //   name: 'db'
  // }
};

const test = {
  app: {
    baseUrl: 'localhost',
    host: '127.0.0.1',
    port: 8081
  },
  // db: {
  //   host: 'localhost',
  //   port: 27017,
  //   name: 'test'
  // }
};

const config = {
  dev,
  test
};

module.exports = config[env];
