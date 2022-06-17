# News API
An API to get news from various outlets, to be used in the main application

Note: Port number may need changing for deployment
## Online Endpoint
- http://localhost:3535/
- Returns "online" if online
## News Endpoint
- Example URLs
  - http://localhost:3535/news?len=3&time=1d
  - http://localhost:3535/news?len=5&time=2y&outlet=BBC&searchTerm=afghanistan
- 4 Arguments, enter in url as spelled below
  - You must provide len and at least one of the optional arguments
  - outlet (optional): which news outlet to select from
  - time (optional): how far back in time the articles may be from
    - #d to look # days back, #h for hours, #m for months, #y for years
  - searchTerm (optional): which term it should search for
  - len (required): how many articles to return
