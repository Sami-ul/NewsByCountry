// Sami-ul
// Get news function

const RSSParser = require("rss-parser")
var parser = new RSSParser();

module.exports = {
    getNews
};
async function getNews(time, outlet, searchTerm, len) {
    var url = `https://news.google.com/rss/search?q=${searchTerm}%20site%3A${outlet}.com%20when%3A${time}&hl=en-US&gl=US&ceid=US%3Aen`.replace(/undefined/g, '');
    var result = [];
    let feed = await parser.parseURL(url);
    // parse from rss feed 
    for (var i = 0; i < len; i++) {
        try {
            result.push({
                date: feed.items[i].pubDate,
                link: feed.items[i].link,
                title: feed.items[i].title
            });
        } catch {
            
        }
    }

    return result;
}