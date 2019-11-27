from bs4 import BeautifulSoup
import urllib.request
import re
import threading

def crawl(start_page, distance, action):
    visited = set()
    queue = [[start_page, distance]]
    result_list = list()
    thread_list = list()
    yield_list = list()
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
        while queue or thread_list:
            page = queue.pop(0)
            if page[0] not in visited:
                z = threading.Thread(target=lambda l, arg1: l.append((arg1, action(arg1))), args=(yield_list, page[0]))
                z.start()
                z.join()
                yield yield_list.pop(0)
                t = threading.Thread(target=lambda l, arg1: l.append(getLinks(arg1)), args=(result_list, page[0]))
                t.start()
                thread_list.append(t)
                visited.add(page[0])
                if not result_list:
                    thread_list[0].join()
                    thread_list.pop(0)
                links = result_list.pop(0)
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

