import re
import urllib.request
import html.parser


class MicroGoogleHTMLParser(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.links = []

    def _is_url_valid(self, url):
        return 'https' not in url and url.startswith('http')

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            for (atr, val) in attrs:
                if atr == 'href':
                    if self._is_url_valid(val):
                        self.links.append(val)


class MicroGoogle:
    def __init__(self, startpage, depth):
        self.startpage = startpage
        self.depth = depth
        self.links = []
        self.links.append(startpage)
        with urllib.request.urlopen(startpage) as page:
            self._get_links(page, 1)
        for x in self.links:
            print(x)

    def __getitem__(self, key):
        ret = []
        for link in self.links:
            count = self._search(key, link)
            if count:
                ret.append((link, count))
        ret = sorted(ret, key=lambda x: x[1], reverse=True)
        return ret

    def _get_links(self, page, rec_depth):
        html_parser = MicroGoogleHTMLParser()
        html_parser.feed(page.read().decode('utf-8'))
        for link in html_parser.links:
            if link not in self.links:
                self.links.append(link)
                if rec_depth <= self.depth:
                    with urllib.request.urlopen(link) as next_page:
                        self._get_links(next_page, rec_depth + 1)

    def _search(self, keyword, url):
        with urllib.request.urlopen(url) as page:
            return(len(re.findall(keyword, str(page.read()))))


if __name__ == '__main__':
    mg = MicroGoogle("https://github.com/", 2)
    print(mg["work"])