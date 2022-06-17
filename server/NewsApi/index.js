// Sami-ul
// News API

// Packages
const express = require('express'); // Used for incoming API requests
const bodyParser = require('body-parser'); // middleware for express
const fs = require('fs');

// Sets up express
const app = express();
app.use(function (req, res, next) {
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:8888');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE');
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', true);
  next(); // very important that this is here, otherwise it stays stuck
});

app.use(bodyParser.urlencoded({ extended: false }));
pathWalk('./routes/');

async function pathWalk(dir) {
  // Walks the routes folder and turns on all endpoints, ignoring files marked func-
  const directory = await fs.promises.readdir(dir);
  directory.forEach((file) => {
    if (!file.startsWith("func-")) {
      console.log("./routes/" + file + " online");
      app.use(require("./routes/" + file));
    }
  });
}

// Start server
// Port # may need changing for deployment
app.listen(3535); // Listening at port 3535