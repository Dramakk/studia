from bs4 import BeautifulSoup
import urllib.request
import re
def crawl(start_page, distance, action):
    visited = set()
    queue = [[start_page, distance]]
    def getLinks(url):
        try:
            html_page = urllib.request.urlopen(url)
        except urllib.error.HTTPError as e:
            return []
        soup = BeautifulSoup(html_page, features="lxml")
        links = []

        for link in soup.findAll('a', attrs={'href': re.compile("^http://")}):
            links.append(link.get('href'))

        return links
    def bfs():
        while queue:
            page = queue.pop(0)
            if page[0] not in visited:
                yield (page[0], action(page[0]))
                visited.add(page[0])
                links = getLinks(page[0])
                if page[1] > 0:
                    for i in links:
                        queue.append([i, page[1]-1])
    return bfs()

def findAll(page):
    try:
        html = urllib.request.urlopen(page).read()
    except urllib.error.HTTPError as e:
        return []
    soup = BeautifulSoup(html, features="lxml", from_encoding="UTF-8")

    for script in soup(["script", "style"]):
        script.extract()  # rip it out

    text = soup.get_text()
    lines = (line.strip() for line in text.splitlines())
    chunks = (phrase.strip() for line in lines for phrase in line.split("  "))
    text = '\n'.join(chunk for chunk in chunks if chunk)
    return re.findall(r"([^.]*?Python[^.]*\.)",text)

it = crawl("https://github.com/", 4, findAll)
for i in it:
    print(i)

