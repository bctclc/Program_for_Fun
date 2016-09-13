import urllib
from BeautifulSoup import *
import re
import sqlite3

## get the url of the homepage
url = "http://www.databaseolympics.com/"

## fetch homepage
homepg = urllib.urlopen(url).read()
homesoup = BeautifulSoup(homepg)

## get the urls of pages for all the years
yearpages = homesoup("a")
all_url = []
for yearpage in yearpages:
    link = str(yearpage).split('"')[1]
    if link.startswith("/games/gamesyear"):
        link = "http://www.databaseolympics.com" + link
        all_url.append(link)

## keep only summer games
all_url = all_url[0:28]

## get country*year links
country_url = []
for game_url in all_url:
    gamepg = urllib.urlopen(game_url).read()
    gamesoup = BeautifulSoup(gamepg)
    countrypg = gamesoup("a")
    for country in countrypg:
        if country.parent.name == "td":
            link = str(country).split('"')[1]
            if link.startswith("/country/countryyear"):
                link = str(link)
                link = link[0:-11] + link [-7:]
                link = "http://www.databaseolympics.com" + link
                country_url.append(link)

## establish sql database for mother database
conn = sqlite3.connect('medaldb.sqlite')
cur = conn.cursor()

cur.executescript('''
DROP TABLE IF EXISTS medal;

CREATE TABLE medal (
    year     INTEGER NOT NULL ,
    team   TEXT NOT NULL,
    category TEXT NOT NULL,
    medal TEXT NOT NULL
)
''')

## input data to mother database
for each_url in country_url:
    eachpg = urllib.urlopen(each_url).read()
    eachsoup = BeautifulSoup(eachpg)

    ## get country & year   
    country = eachsoup("b")[0]
    country = str(country).split('>')[1].split('<')[0]
    year = eachsoup("b")[1]
    year = str(year).split('>')[1].split(' ')[0]
    ## get categories
    cates = []
    categories = eachsoup("a")
    for cate in categories:
        if cate.parent.name == "td":
            if str(cate).split('"')[1].startswith("/games/gamessport"):
                cate = str(cate).split(">")[1].split("<")[0]
                cates.append(cate)
    categories = []
    for cate in cates:
        if cates.index(cate)%2 == 0:
            categories.append(cate)

    ## get medals
    meds = []
    medals = eachsoup("td")
    for medal in medals:
        medal = str(medal).split(">")[1].split("<")[0]
        if medal in ("GOLD", "SILVER", "BRONZE"):
            meds.append(medal)

    length = len(meds)
    i = 0

    while i <= length-1:
        cur.execute('''
        INSERT INTO medal
        VALUES (?, ?, ?, ?)''', (year, country, categories[i], meds[i]))
        conn.commit()
        i = i+1
    