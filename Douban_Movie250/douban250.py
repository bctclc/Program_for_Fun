# see which years were the top 250 movies made in

import urllib
from BeautifulSoup import *
import re

# get the ten page urls of the top 250 movie list
urls = ["https://movie.douban.com/top250"]
url = "https://movie.douban.com/top250"
newurl = ""

listpage = urllib.urlopen(url).read()
listsoup = BeautifulSoup(listpage)
listlink = listsoup("a")
for listlin in listlink:
    listlin = str(listlin)
    link = listlin.split('"')[1]
    if link.startswith("?start"):
        newurl = url + link
        urls.append(newurl)

# find out the years and count        
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

