# Sami-ul
# Main flask managing file
# To run enter: poetry run python main.py

from flask import Flask, request
from flask_cors import CORS, cross_origin
from newspaper import Article # could look into newspaper3k noimage
import summarizer

app = Flask('app')
CORS(app, supports_credentials=True)

@app.route('/')
def online():
    """Checks if the api is online."""
    return 'online'


@app.route('/summary', methods=['GET'])
@cross_origin(supports_credentials=True)
def getNewsSummary() -> str:
    link = request.args.get('link')
    try:
        article = Article(link)
        article.download()
        article.parse()
        result = summarizer.summarizer(article.text, 3, link)
        return {"summary": result}
    except:
        return {"summary": "Could not summarize this article"}

app.run(host='localhost', port=8080)
