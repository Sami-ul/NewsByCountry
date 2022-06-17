// Sami-ul
// Get news endpoint

const news = require("./func-getNews")
const express = require('express');
const router = express.Router();

router.get('/news', (req, res) => {
    /*
    4 Arguments, enter in url as spelled below
    You must provide len and at least one of the optional arguments
    outlet (optional): which news outlet to select from
    time (optional): how far back in time the articles may be from, #d to look # days back, #h for hours, #m for months, #y for years
    searchTerm (optional): which term it should search for
    len (required): how many articles to return
    */
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS, PUT, PATCH, DELETE'); // If needed
    res.setHeader('Access-Control-Allow-Headers', 'X-Requested-With,content-type'); // If needed
    res.setHeader('Access-Control-Allow-Credentials', true); // If needed
    var outlet, time, searchTerm, len; // user input
    try {
        outlet = req.query['outlet'];
    } catch {
        outlet = '';
    }
    try {
        time = req.query['time'];
    } catch {
        time = '';
    }
    try {
        searchTerm = req.query['searchTerm'];
    } catch {
        searchTerm = '';
    }
    try {
        len = req.query['len'];
    } catch {
        res.send('Error: must provide len argument');
    }
    if (searchTerm == undefined && time == undefined && outlet == undefined) {
        res.send('Error: not enough arguments');
        return;
    } else {
        news.getNews(time, outlet, searchTerm, len).then((value) => {
            res.json(value);
        });
    }
});

module.exports = router;