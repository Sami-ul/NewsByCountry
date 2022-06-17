// Sami-ul
// Get summary from python endpoint

const express = require('express');
const router = express.Router();
const request = require('request');

// Shows if the app is online
router.get('/summary', (req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'); 
  res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type');
  res.setHeader('Access-Control-Allow-Credentials', true); 
  var link = req.query["link"];
  request(`http://localhost:8080/summary?link=${link}`, {json: true}, (err, response, body) => {
    // Get summary from python api
    if (err) {
        res.send(err);
    } else {
        res.json(body);
    }
  });
});

module.exports = router;