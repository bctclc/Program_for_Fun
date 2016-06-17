# see which years were the top 250 movies made in

import urllib
from BeautifulSoup import *
import re

urls = ["https://movie.douban.com/top250", "https://movie.douban.com/top250?start=25&filter="]
urls.append("https://movie.douban.com/top250?start=50&filter=")
urls.append("https://movie.douban.com/top250?start=75&filter=")
urls.append("https://movie.douban.com/top250?start=100&filter=")
urls.append("https://movie.douban.com/top250?start=125&filter=")
urls.append("https://movie.douban.com/top250?start=150&filter=")
urls.append("https://movie.douban.com/top250?start=175&filter=")
urls.append("https://movie.douban.com/top250?start=200&filter=")
urls.append("https://movie.douban.com/top250?start=225&filter=")

year_count = dict()

for url in urls:
    webpage = urllib.urlopen(url).read()
    soup = BeautifulSoup(webpage)
    tags = soup("p")
    for tag in tags:
        tag = str(tag)
        temp = re.findall("[1-2][0-9][0-9][0-9]", tag)
        if temp == []: continue
        else:
            temp = str(temp)
            if temp not in year_count:
                year_count[temp] = 1
            else: 
                year_count[temp] = year_count[temp] + 1

print year_count

