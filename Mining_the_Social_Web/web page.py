### Example 1. Using boilerpipe to extract the text from a web page

from boilerpipe.extract import Extractor

URL='http://radar.oreilly.com/2010/07/louvre-industrial-age-henry-ford.html'

extractor = Extractor(extractor='ArticleExtractor', url=URL)

print extractor.getText()


### Example 2. Using feedparser to extract the text (and other fields) from an RSS or Atom feed

import feedparser

FEED_URL='http://feeds.feedburner.com/oreilly/radar/atom'

fp = feedparser.parse(FEED_URL)

for e in fp.entries:
    print e.title
    print e.links[0].href
    print e.content[0].value
    
### Example 3. Pseudocode for a breadth-first search

# Naive sentence detection based on periods

txt = "Mr. Green killed Colonel Mustard in the study with the candlestick. Mr. Green is not a very nice fellow."
print txt.split(".")

# More sophisticated sentence detection

import nltk

# Downloading nltk packages used in this example
nltk.download('punkt')

sentences = nltk.tokenize.sent_tokenize(txt)
print sentences

# Tokenization of sentences

tokens = [nltk.tokenize.word_tokenize(s) for s in sentences]
print tokens

# Part of speech tagging for tokens

# Downloading nltk packages used in this example
nltk.download('maxent_treebank_pos_tagger')

pos_tagged_tokens = [nltk.pos_tag(t) for t in tokens]
print pos_tagged_tokens

# Named entity extraction/chunking for tokens

# Downloading nltk packages used in this example
nltk.download('maxent_ne_chunker')
nltk.download('words')

ne_chunks = nltk.batch_ne_chunk(pos_tagged_tokens)
print ne_chunks
print ne_chunks[0].pprint() # You can prettyprint each chunk in the tree

### Example 4. Harvesting blog data by parsing feeds

import os
import sys
import json
import feedparser
from BeautifulSoup import BeautifulStoneSoup
from nltk import clean_html

FEED_URL = 'http://feeds.feedburner.com/oreilly/radar/atom'

def cleanHtml(html):
    return BeautifulStoneSoup(clean_html(html),
                convertEntities=BeautifulStoneSoup.HTML_ENTITIES).contents[0]

fp = feedparser.parse(FEED_URL)

print "Fetched %s entries from '%s'" % (len(fp.entries[0].title), fp.feed.title)

blog_posts = []
for e in fp.entries:
    blog_posts.append({'title': e.title, 'content'
                      : cleanHtml(e.content[0].value), 'link': e.links[0].href})

out_file = os.path.join('resources', 'ch05-webpages', 'feed.json')
f = open(out_file, 'w')
f.write(json.dumps(blog_posts, indent=1))
f.close()

print 'Wrote output file to %s' % (f.name, )

### Example 5. Using NLTK’s NLP tools to process human language in blog data

import json
import nltk

# Download nltk packages used in this example
nltk.download('stopwords')

BLOG_DATA = "resources/ch05-webpages/feed.json"

blog_data = json.loads(open(BLOG_DATA).read())

# Customize your list of stopwords as needed. Here, we add common
# punctuation and contraction artifacts.

stop_words = nltk.corpus.stopwords.words('english') + [
    '.',
    ',',
    '--',
    '\'s',
    '?',
    ')',
    '(',
    ':',
    '\'',
    '\'re',
    '"',
    '-',
    '}',
    '{',
    u'—',
    ]

for post in blog_data:
    sentences = nltk.tokenize.sent_tokenize(post['content'])

    words = [w.lower() for sentence in sentences for w in
             nltk.tokenize.word_tokenize(sentence)]

    fdist = nltk.FreqDist(words)

    # Basic stats

    num_words = sum([i[1] for i in fdist.items()])
    num_unique_words = len(fdist.keys())

    # Hapaxes are words that appear only once

    num_hapaxes = len(fdist.hapaxes())

    top_10_words_sans_stop_words = [w for w in fdist.items() if w[0]
                                    not in stop_words][:10]

    print post['title']
    print '\tNum Sentences:'.ljust(25), len(sentences)
    print '\tNum Words:'.ljust(25), num_words
    print '\tNum Unique Words:'.ljust(25), num_unique_words
    print '\tNum Hapaxes:'.ljust(25), num_hapaxes
    print '\tTop 10 Most Frequent Words (sans stop words):\n\t\t', \
            '\n\t\t'.join(['%s (%s)'
            % (w[0], w[1]) for w in top_10_words_sans_stop_words])
    print
    
### Example 6. A document summarization algorithm based principally upon sentence detection and frequency analysis within sentences

import json
import nltk
import numpy

BLOG_DATA = "resources/ch05-webpages/feed.json"

N = 100  # Number of words to consider
CLUSTER_THRESHOLD = 5  # Distance between words to consider
TOP_SENTENCES = 5  # Number of sentences to return for a "top n" summary

# Approach taken from "The Automatic Creation of Literature Abstracts" by H.P. Luhn

def _score_sentences(sentences, important_words):
    scores = []
    sentence_idx = -1

    for s in [nltk.tokenize.word_tokenize(s) for s in sentences]:

        sentence_idx += 1
        word_idx = []

        # For each word in the word list...
        for w in important_words:
            try:
                # Compute an index for where any important words occur in the sentence.

                word_idx.append(s.index(w))
            except ValueError, e: # w not in this particular sentence
                pass

        word_idx.sort()

        # It is possible that some sentences may not contain any important words at all.
        if len(word_idx)== 0: continue

        # Using the word index, compute clusters by using a max distance threshold
        # for any two consecutive words.

        clusters = []
        cluster = [word_idx[0]]
        i = 1
        while i < len(word_idx):
            if word_idx[i] - word_idx[i - 1] < CLUSTER_THRESHOLD:
                cluster.append(word_idx[i])
            else:
                clusters.append(cluster[:])
                cluster = [word_idx[i]]
            i += 1
        clusters.append(cluster)

        # Score each cluster. The max score for any given cluster is the score 
        # for the sentence.

        max_cluster_score = 0
        for c in clusters:
            significant_words_in_cluster = len(c)
            total_words_in_cluster = c[-1] - c[0] + 1
            score = 1.0 * significant_words_in_cluster \
                * significant_words_in_cluster / total_words_in_cluster

            if score > max_cluster_score:
                max_cluster_score = score

        scores.append((sentence_idx, score))

    return scores

def summarize(txt):
    sentences = [s for s in nltk.tokenize.sent_tokenize(txt)]
    normalized_sentences = [s.lower() for s in sentences]

    words = [w.lower() for sentence in normalized_sentences for w in
             nltk.tokenize.word_tokenize(sentence)]

    fdist = nltk.FreqDist(words)

    top_n_words = [w[0] for w in fdist.items() 
            if w[0] not in nltk.corpus.stopwords.words('english')][:N]

    scored_sentences = _score_sentences(normalized_sentences, top_n_words)

    # Summarization Approach 1:
    # Filter out nonsignificant sentences by using the average score plus a
    # fraction of the std dev as a filter

    avg = numpy.mean([s[1] for s in scored_sentences])
    std = numpy.std([s[1] for s in scored_sentences])
    mean_scored = [(sent_idx, score) for (sent_idx, score) in scored_sentences
                   if score > avg + 0.5 * std]

    # Summarization Approach 2:
    # Another approach would be to return only the top N ranked sentences

    top_n_scored = sorted(scored_sentences, key=lambda s: s[1])[-TOP_SENTENCES:]
    top_n_scored = sorted(top_n_scored, key=lambda s: s[0])

    # Decorate the post object with summaries

    return dict(top_n_summary=[sentences[idx] for (idx, score) in top_n_scored],
                mean_scored_summary=[sentences[idx] for (idx, score) in mean_scored])

blog_data = json.loads(open(BLOG_DATA).read())

for post in blog_data:
       
    post.update(summarize(post['content']))

    print post['title']
    print '=' * len(post['title'])
    print
    print 'Top N Summary'
    print '-------------'
    print ' '.join(post['top_n_summary'])
    print
    print 'Mean Scored Summary'
    print '-------------------'
    print ' '.join(post['mean_scored_summary'])
    print

### Example 7. Visualizing document summarization results with HTML output

import os
import json
import nltk
import numpy
from IPython.display import IFrame
from IPython.core.display import display

BLOG_DATA = "resources/ch05-webpages/feed.json"

HTML_TEMPLATE = """<html>
    <head>
        <title>%s</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    </head>
    <body>%s</body>
</html>"""

blog_data = json.loads(open(BLOG_DATA).read())

for post in blog_data:
   
    # Uses previously defined summarize function.
    post.update(summarize(post['content']))

    # You could also store a version of the full post with key sentences marked up
    # for analysis with simple string replacement...

    for summary_type in ['top_n_summary', 'mean_scored_summary']:
        post[summary_type + '_marked_up'] = '<p>%s</p>' % (post['content'], )
        for s in post[summary_type]:
            post[summary_type + '_marked_up'] = \
            post[summary_type + '_marked_up'].replace(s, '<strong>%s</strong>' % (s, ))

        filename = post['title'].replace("?", "") + '.summary.' + summary_type + '.html'
        f = open(os.path.join('resources', 'ch05-webpages', filename), 'w')
        html = HTML_TEMPLATE % (post['title'] + \
          ' Summary', post[summary_type + '_marked_up'],)
              
        f.write(html.encode('utf-8'))
        f.close()

        print "Data written to", f.name

# Display any of these files with an inline frame. This displays the
# last file processed by using the last value of f.name...

print "Displaying %s:" % f.name
display(IFrame('files/%s' % f.name, '100%', '600px'))

### Example 8. Extracting entities from a text with NLTK

import nltk
import json

BLOG_DATA = "resources/ch05-webpages/feed.json"

blog_data = json.loads(open(BLOG_DATA).read())

for post in blog_data:

    sentences = nltk.tokenize.sent_tokenize(post['content'])
    tokens = [nltk.tokenize.word_tokenize(s) for s in sentences]
    pos_tagged_tokens = [nltk.pos_tag(t) for t in tokens]

    # Flatten the list since we're not using sentence structure
    # and sentences are guaranteed to be separated by a special
    # POS tuple such as ('.', '.')

    pos_tagged_tokens = [token for sent in pos_tagged_tokens for token in sent]

    all_entity_chunks = []
    previous_pos = None
    current_entity_chunk = []
    for (token, pos) in pos_tagged_tokens:

        if pos == previous_pos and pos.startswith('NN'):
            current_entity_chunk.append(token)
        elif pos.startswith('NN'):
            if current_entity_chunk != []:

                # Note that current_entity_chunk could be a duplicate when appended,
                # so frequency analysis again becomes a consideration

                all_entity_chunks.append((' '.join(current_entity_chunk), pos))
            current_entity_chunk = [token]

        previous_pos = pos

    # Store the chunks as an index for the document
    # and account for frequency while we're at it...

    post['entities'] = {}
    for c in all_entity_chunks:
        post['entities'][c] = post['entities'].get(c, 0) + 1

    # For example, we could display just the title-cased entities

    print post['title']
    print '-' * len(post['title'])
    proper_nouns = []
    for (entity, pos) in post['entities']:
        if entity.istitle():
            print '\t%s (%s)' % (entity, post['entities'][(entity, pos)])
    print

### Example 9. Discovering interactions between entities

import nltk
import json

BLOG_DATA = "resources/ch05-webpages/feed.json"

def extract_interactions(txt):
    sentences = nltk.tokenize.sent_tokenize(txt)
    tokens = [nltk.tokenize.word_tokenize(s) for s in sentences]
    pos_tagged_tokens = [nltk.pos_tag(t) for t in tokens]

    entity_interactions = []
    for sentence in pos_tagged_tokens:

        all_entity_chunks = []
        previous_pos = None
        current_entity_chunk = []

        for (token, pos) in sentence:

            if pos == previous_pos and pos.startswith('NN'):
                current_entity_chunk.append(token)
            elif pos.startswith('NN'):
                if current_entity_chunk != []:
                    all_entity_chunks.append((' '.join(current_entity_chunk),
                            pos))
                current_entity_chunk = [token]

            previous_pos = pos

        if len(all_entity_chunks) > 1:
            entity_interactions.append(all_entity_chunks)
        else:
            entity_interactions.append([])

    assert len(entity_interactions) == len(sentences)

    return dict(entity_interactions=entity_interactions,
                sentences=sentences)

blog_data = json.loads(open(BLOG_DATA).read())

# Display selected interactions on a per-sentence basis

for post in blog_data:

    post.update(extract_interactions(post['content']))

    print post['title']
    print '-' * len(post['title'])
    for interactions in post['entity_interactions']:
        print '; '.join([i[0] for i in interactions])
    print
    
### Example 10. Visualizing interactions between entities with HTML output

import os
import json
import nltk
from IPython.display import IFrame
from IPython.core.display import display

BLOG_DATA = "resources/ch05-webpages/feed.json"

HTML_TEMPLATE = """<html>
    <head>
        <title>%s</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    </head>
    <body>%s</body>
</html>"""

blog_data = json.loads(open(BLOG_DATA).read())

for post in blog_data:

    post.update(extract_interactions(post['content']))

    # Display output as markup with entities presented in bold text

    post['markup'] = []

    for sentence_idx in range(len(post['sentences'])):

        s = post['sentences'][sentence_idx]
        for (term, _) in post['entity_interactions'][sentence_idx]:
            s = s.replace(term, '<strong>%s</strong>' % (term, ))

        post['markup'] += [s] 
            
    filename = post['title'].replace("?", "") + '.entity_interactions.html'
    f = open(os.path.join('resources', 'ch05-webpages', filename), 'w')
    html = HTML_TEMPLATE % (post['title'] + ' Interactions', 
                            ' '.join(post['markup']),)
    f.write(html.encode('utf-8'))
    f.close()

    print "Data written to", f.name
    
    # Display any of these files with an inline frame. This displays the
    # last file processed by using the last value of f.name...
    
    print "Displaying %s:" % f.name
    display(IFrame('files/%s' % f.name, '100%', '600px'))