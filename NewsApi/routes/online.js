// Sami-ul
// Base url return

const express = require('express');
const router = express.Router();

// Shows if the app is online
router.get('/', (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'); // If needed
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type'); // If needed
  res.setHeader('Access-Control-Allow-Credentials', true); // If needed
  res.send("online");
});

module.exports = router;