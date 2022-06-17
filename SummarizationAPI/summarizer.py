# Sami-ul
# NLP summarizer function

import spacy
from string import punctuation
from collections import Counter
from heapq import nlargest
import consts

nlp = spacy.load('en_core_web_sm') # English model

def summarizer(text, numSents, link):
    """
    Summarizes text using SPACY
    """
    processedArticle = nlp(text) # Tokenization
    keywords = []
    for token in processedArticle:
        if (token.text in consts.STOP_WORDS or token.text in punctuation): # Will not detect these types of words
            continue
        if (token.pos_ in consts.PARTSOFSPEECH):
            keywords.append(token.text) #
    word_freq = Counter(keywords) # Creates a list of sets with word frequencies
    try:
        max_freq = Counter(keywords).most_common(1)[0][1] # the frequency of the first most popular word in article
    except:
        return "FAULTY URL: " + link
    for word in word_freq.keys(): # normalizes list to less than 1
        word_freq[word] = (word_freq[word]/max_freq)
    
    sent_strength = {}
    for sent in processedArticle.sents: # sentences
        for word in sent: # word per sentence
            if word.text in word_freq.keys(): 
                if sent in sent_strength.keys(): # adds word score which we normalized to the sentence strength
                    sent_strength[sent] += word_freq[word.text]
                else:
                    sent_strength[sent] = word_freq[word.text]
    summarized = nlargest(numSents, sent_strength, key=sent_strength.get) # gets numSents number of largest score from the sentences
    sents = []
    for w in summarized:
        if (w.text not in sents and w.text[0] not in punctuation):
            sents.append(w.text)
    result = ' '.join(sents).replace("\n", " ") # makes it into text
    return result