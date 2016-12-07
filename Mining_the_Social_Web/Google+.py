## Example 1. Searching for a person with the Google+ API

import httplib2
import json
import apiclient.discovery # pip install google-api-python-client

# XXX: Enter any person's name
Q = "Tim O'Reilly"

# XXX: Enter in your API key from  https://code.google.com/apis/console
API_KEY = '' 

service = apiclient.discovery.build('plus', 'v1', http=httplib2.Http(), 
                                    developerKey=API_KEY)

people_feed = service.people().search(query=Q).execute()

print json.dumps(people_feed['items'], indent=1)

## Example 2. Displaying Google+ avatars in IPython Notebook provides a quick way to disambiguate the search results and discover the person you are looking for

from IPython.core.display import HTML

html = []

for p in people_feed['items']:
    html += ['<p><img src="%s" /> %s: %s</p>' % \
             (p['image']['url'], p['id'], p['displayName'])]

HTML(''.join(html))

## Example 3. Fetching recent activities for a particular Google+ user

import httplib2
import json
import apiclient.discovery

USER_ID = '107033731246200681024' # Tim O'Reilly

# XXX: Re-enter your API_KEY from  https://code.google.com/apis/console
# if not currently set
# API_KEY = ''

service = apiclient.discovery.build('plus', 'v1', http=httplib2.Http(), 
                                    developerKey=API_KEY)

activity_feed = service.activities().list(
  userId=USER_ID,
  collection='public',
  maxResults='100' # Max allowed per API
).execute()

print json.dumps(activity_feed, indent=1)

## Example 4. Cleaning HTML in Google+ content by stripping out HTML tags and converting HTML entities back to plain-text representations

from nltk import clean_html
from BeautifulSoup import BeautifulStoneSoup

# clean_html removes tags and
# BeautifulStoneSoup converts HTML entities

def cleanHtml(html):
  if html == "": return ""

  return BeautifulStoneSoup(clean_html(html),
          convertEntities=BeautifulStoneSoup.HTML_ENTITIES).contents[0]

print activity_feed['items'][0]['object']['content']
print
print cleanHtml(activity_feed['items'][0]['object']['content'])

## Example 5. Looping over multiple pages of Google+ activities and distilling clean text from notes

import os
import httplib2
import json
import apiclient.discovery
from BeautifulSoup import BeautifulStoneSoup
from nltk import clean_html

USER_ID = '107033731246200681024' # Tim O'Reilly

# XXX: Re-enter your API_KEY from  https://code.google.com/apis/console 
# if not currently set
# API_KEY = '' 

MAX_RESULTS = 200 # Will require multiple requests

def cleanHtml(html):
  if html == "": return ""

  return BeautifulStoneSoup(clean_html(html),
          convertEntities=BeautifulStoneSoup.HTML_ENTITIES).contents[0]

service = apiclient.discovery.build('plus', 'v1', http=httplib2.Http(), 
                                    developerKey=API_KEY)

activity_feed = service.activities().list(
  userId=USER_ID,
  collection='public',
  maxResults='100' # Max allowed per request
)

activity_results = []

while activity_feed != None and len(activity_results) < MAX_RESULTS:

  activities = activity_feed.execute()

  if 'items' in activities:

    for activity in activities['items']:

      if activity['object']['objectType'] == 'note' and \
         activity['object']['content'] != '':

        activity['title'] = cleanHtml(activity['title'])
        activity['object']['content'] = cleanHtml(activity['object']['content'])
        activity_results += [activity]

  # list_next requires the previous request and response objects
  activity_feed = service.activities().list_next(activity_feed, activities)

# Write the output to a file for convenience

f = open(os.path.join('resources', 'ch04-googleplus', USER_ID + '.json'), 'w')
f.write(json.dumps(activity_results, indent=1))
f.close()

print str(len(activity_results)), "activities written to", f.name

## Example 6. Sample data structures used in illustrations for the rest of this chapter

corpus = { 
 'a' : "Mr. Green killed Colonel Mustard in the study with the candlestick. \
Mr. Green is not a very nice fellow.",
 'b' : "Professor Plum has a green plant in his study.",
 'c' : "Miss Scarlett watered Professor Plum's green plant while he was away \
from his office last week."
}
terms = {
 'a' : [ i.lower() for i in corpus['a'].split() ],
 'b' : [ i.lower() for i in corpus['b'].split() ],
 'c' : [ i.lower() for i in corpus['c'].split() ]
 }
 
 ## Example 7. Running TF-IDF on sample data

from math import log

# XXX: Enter in a query term from the corpus variable
QUERY_TERMS = ['mr.', 'green']

def tf(term, doc, normalize=True):
    doc = doc.lower().split()
    if normalize:
        return doc.count(term.lower()) / float(len(doc))
    else:
        return doc.count(term.lower()) / 1.0


def idf(term, corpus):
    num_texts_with_term = len([True for text in corpus if term.lower()
                              in text.lower().split()])

    # tf-idf calc involves multiplying against a tf value less than 0, so it's
    # necessary to return a value greater than 1 for consistent scoring. 
    # (Multiplying two values less than 1 returns a value less than each of 
    # them.)

    try:
        return 1.0 + log(float(len(corpus)) / num_texts_with_term)
    except ZeroDivisionError:
        return 1.0


def tf_idf(term, doc, corpus):
    return tf(term, doc) * idf(term, corpus)


corpus = \
    {'a': 'Mr. Green killed Colonel Mustard in the study with the candlestick. \
Mr. Green is not a very nice fellow.',
     'b': 'Professor Plum has a green plant in his study.',
     'c': "Miss Scarlett watered Professor Plum's green plant while he was away \
from his office last week."}

for (k, v) in sorted(corpus.items()):
    print k, ':', v
print
    
# Score queries by calculating cumulative tf_idf score for each term in query

query_scores = {'a': 0, 'b': 0, 'c': 0}
for term in [t.lower() for t in QUERY_TERMS]:
    for doc in sorted(corpus):
        print 'TF(%s): %s' % (doc, term), tf(term, corpus[doc])
    print 'IDF: %s' % (term, ), idf(term, corpus.values())
    print

    for doc in sorted(corpus):
        score = tf_idf(term, corpus[doc], corpus.values())
        print 'TF-IDF(%s): %s' % (doc, term), score
        query_scores[doc] += score
    print

print "Overall TF-IDF scores for query '%s'" % (' '.join(QUERY_TERMS), )
for (doc, score) in sorted(query_scores.items()):
    print doc, score

## Example 8. Exploring Google+ data with NLTK

# Explore some of NLTK's functionality by exploring the data. 
# Here are some suggestions for an interactive interpreter session.

import nltk

# Download ancillary nltk packages if not already installed
nltk.download('stopwords')

all_content = " ".join([ a['object']['content'] for a in activity_results ])

# Approximate bytes of text
print len(all_content)

tokens = all_content.split()
text = nltk.Text(tokens)

# Examples of the appearance of the word "open"
text.concordance("open")

# Frequent collocations in the text (usually meaningful phrases)
text.collocations()

# Frequency analysis for words of interest
fdist = text.vocab()
fdist["open"]
fdist["source"]
fdist["web"]
fdist["2.0"]

# Number of words in the text
len(tokens)

# Number of unique words in the text

len(fdist.keys())

# Common words that aren't stopwords
[w for w in fdist.keys()[:100] \
   if w.lower() not in nltk.corpus.stopwords.words('english')]

# Long words that aren't URLs
[w for w in fdist.keys() if len(w) > 15 and not w.startswith("http")]

# Number of URLs
len([w for w in fdist.keys() if w.startswith("http")])

# Enumerate the frequency distribution
for rank, word in enumerate(fdist): 
    print rank, word, fdist[word]

## Example 9. Querying Google+ data with TF-IDF

import json
import nltk

# Load in human language data from wherever you've saved it

DATA = 'resources/ch04-googleplus/107033731246200681024.json'
data = json.loads(open(DATA).read())

# XXX: Provide your own query terms here

QUERY_TERMS = ['SOPA']

activities = [activity['object']['content'].lower().split() \
              for activity in data \
                if activity['object']['content'] != ""]

# TextCollection provides tf, idf, and tf_idf abstractions so 
# that we don't have to maintain/compute them ourselves

tc = nltk.TextCollection(activities)

relevant_activities = []

for idx in range(len(activities)):
    score = 0
    for term in [t.lower() for t in QUERY_TERMS]:
        score += tc.tf_idf(term, activities[idx])
    if score > 0:
        relevant_activities.append({'score': score, 'title': data[idx]['title'],
                              'url': data[idx]['url']})

# Sort by score and display results

relevant_activities = sorted(relevant_activities, 
                             key=lambda p: p['score'], reverse=True)
for activity in relevant_activities:
    print activity['title']
    print '\tLink: %s' % (activity['url'], )
    print '\tScore: %s' % (activity['score'], )
    print

## Example 10. Finding similar documents using cosine similarity

import json
import nltk

# Load in human language data from wherever you've saved it

DATA = 'resources/ch04-googleplus/107033731246200681024.json'
data = json.loads(open(DATA).read())

# Only consider content that's ~1000+ words.
data = [ post for post in json.loads(open(DATA).read())
         if len(post['object']['content']) > 1000 ]

all_posts = [post['object']['content'].lower().split() 
             for post in data ]


# Provides tf, idf, and tf_idf abstractions for scoring

tc = nltk.TextCollection(all_posts)

# Compute a term-document matrix such that td_matrix[doc_title][term]
# returns a tf-idf score for the term in the document

td_matrix = {}
for idx in range(len(all_posts)):
    post = all_posts[idx]
    fdist = nltk.FreqDist(post)

    doc_title = data[idx]['title']
    url = data[idx]['url']
    td_matrix[(doc_title, url)] = {}

    for term in fdist.iterkeys():
        td_matrix[(doc_title, url)][term] = tc.tf_idf(term, post)
        
# Build vectors such that term scores are in the same positions...

distances = {}
for (title1, url1) in td_matrix.keys():

    distances[(title1, url1)] = {}
    (min_dist, most_similar) = (1.0, ('', ''))

    for (title2, url2) in td_matrix.keys():

        # Take care not to mutate the original data structures
        # since we're in a loop and need the originals multiple times

        terms1 = td_matrix[(title1, url1)].copy()
        terms2 = td_matrix[(title2, url2)].copy()

        # Fill in "gaps" in each map so vectors of the same length can be computed

        for term1 in terms1:
            if term1 not in terms2:
                terms2[term1] = 0

        for term2 in terms2:
            if term2 not in terms1:
                terms1[term2] = 0

        # Create vectors from term maps

        v1 = [score for (term, score) in sorted(terms1.items())]
        v2 = [score for (term, score) in sorted(terms2.items())]

        # Compute similarity amongst documents

        distances[(title1, url1)][(title2, url2)] = \
            nltk.cluster.util.cosine_distance(v1, v2)

        if url1 == url2:
            #print distances[(title1, url1)][(title2, url2)]
            continue

        if distances[(title1, url1)][(title2, url2)] < min_dist:
            (min_dist, most_similar) = (distances[(title1, url1)][(title2,
                                         url2)], (title2, url2))
    
    print '''Most similar to %s (%s)
\t%s (%s)
\tscore %f
''' % (title1, url1,
            most_similar[0], most_similar[1], 1-min_dist)
            
# Code to create a matrix diagram displaying linkages between Google+ activities as illustrated in Figure 6.

import json
from operator import itemgetter
import nltk
from IPython.display import IFrame
from IPython.core.display import display

# Load in human language data from wherever you've saved it

DATA = 'resources/ch04-googleplus/107033731246200681024.json'

# Only consider content that's ~100+ words.
data = [post for post in json.loads(open(DATA).read())
        if len(post['object']['content']) > 1000]


all_posts = [post['object']['content'].lower().split() 
             for post in data]

# Provides tf, idf, tf_idf abstractions for scoring

tc = nltk.TextCollection(all_posts)

# Compute a term-document matrix such that td_matrix[doc_title][term]
# returns a tf-idf score for the term in the document

td_matrix = {}
for idx in range(len(all_posts)):
    post = all_posts[idx]
    fdist = nltk.FreqDist(post)

    doc_title = data[idx]['title']
    url = data[idx]['url']
    td_matrix[(doc_title, url)] = {}

    for term in fdist.iterkeys():
        td_matrix[(doc_title, url)][term] = tc.tf_idf(term, post)

# Build vectors such that term scores are in the same positions...

distances = {}

# Visualization output requires a list of nodes with values and a list of links that have
# source and destination targets. We'll pre-build the list of nodes here and create an index
# so that we can easily create links from titles after we compute the most similar items
# on each iteration of the outer loop

viz_links = []
viz_nodes = [ {'title' : title, 'url' : url} for (title, url) in td_matrix.keys() ]

foo = 0
for vn in viz_nodes:
    vn.update({'idx' : foo})
    foo += 1

idx = dict(zip([ vn['title'] for vn in viz_nodes ], range(len(viz_nodes))))


for (title1, url1) in td_matrix.keys():

    distances[(title1, url1)] = {}
    (min_dist, most_similar) = (1.0, ('', ''))

    for (title2, url2) in td_matrix.keys():

        # Take care not to mutate the original data structures
        # since we're in a loop and need the originals multiple times

        terms1 = td_matrix[(title1, url1)].copy()
        terms2 = td_matrix[(title2, url2)].copy()

        # Fill in "gaps" in each map so vectors of the same length can be computed

        for term1 in terms1:
            if term1 not in terms2:
                terms2[term1] = 0

        for term2 in terms2:
            if term2 not in terms1:
                terms1[term2] = 0

        # Create vectors from term maps

        v1 = [score for (term, score) in sorted(terms1.items())]
        v2 = [score for (term, score) in sorted(terms2.items())]

        # Compute similarity amongst documents

        distances[(title1, url1)][(title2, url2)] = \
            nltk.cluster.util.cosine_distance(v1, v2)

        if url1 == url2:
            #print distances[(title1, url1)][(title2, url2)]
            continue

        if distances[(title1, url1)][(title2, url2)] < min_dist:
            (min_dist, most_similar) = (distances[(title1, url1)][(title2,
                                         url2)], (title2, url2))
    
    viz_links.append({'source' : idx[title1], 'target' : idx[most_similar[0]], 'score' : 1 - min_dist})
    

f = open('resources/ch04-googleplus/viz/matrix.json', 'w')
f.write(json.dumps({'nodes' : viz_nodes, 'links' : viz_links}, indent=1))
f.close()

# Display the visualization below with an inline frame
display(IFrame('files/resources/ch04-googleplus/viz/matrix.html', '100%', '600px'))

# You could also serve it by running SimpleHTTPServer in the viz directory as follows:
# $ python -m SimpleHTTPServer 9000
# Now, open http://localhost:9000/matrix.html in your web browser 

## Example 11. Using NLTK to compute bigrams and collocations for a sentence

import nltk

sentence = "Mr. Green killed Colonel Mustard in the study with the " + \
           "candlestick. Mr. Green is not a very nice fellow."

print nltk.ngrams(sentence.split(), 2)
txt = nltk.Text(sentence.split())

txt.collocations()

## Example 12. Using NLTK to compute collocations in a similar manner to the nltk.Text.collocations demo functionality

import json
import nltk

# Load in human language data from wherever you've saved it

DATA = 'resources/ch04-googleplus/107033731246200681024.json'
data = json.loads(open(DATA).read())

# Number of collocations to find

N = 25

all_tokens = [token for activity in data for token in activity['object']['content'
              ].lower().split()]

finder = nltk.BigramCollocationFinder.from_words(all_tokens)
finder.apply_freq_filter(2)
finder.apply_word_filter(lambda w: w in nltk.corpus.stopwords.words('english'))
scorer = nltk.metrics.BigramAssocMeasures.jaccard
collocations = finder.nbest(scorer, N)

for collocation in collocations:
    c = ' '.join(collocation)
    print c