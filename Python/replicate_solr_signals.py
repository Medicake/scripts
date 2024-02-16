from urllib.request import *
import json
import pysolr

source = pysolr.Solr('http://old-searchserver.domain.com:8983/solr/dantest_signals', timeout=10)
dest = pysolr.Solr('https://new-searchserver.domain.com:6764/api/solrAdmin/default/dantest_signals', timeout=10)

count = 0

searchString = 'timestamp_tdt:[2022-01-01T00:00:00.00Z TO *]'

# Just loop over it to access the results.
for doc in source.search(searchString,sort='timestamp_tdt asc, id asc',cursorMark='*'):
    count = count +1
    del doc['_version_']
    print(doc['timestamp_tdt'])
    dest.add(doc)
    
    if (count == 1000):
        print('Committing')
        dest.commit()
        count = 0

dest.commit()
