module.exports = {
    apps: [
      {
        name: "remix-app",
        script: "remix-serve",
        args: "build/server/index.js",
        instances: 'max',
        exec_mode: 'cluster',
        autorestart: true,
        restart: 'on-failure',
        env: {
          NODE_ENV: "production"
        }
      }
    ]
  };