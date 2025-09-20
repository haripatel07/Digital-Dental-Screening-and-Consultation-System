from fastapi import APIRouter
import requests
from bs4 import BeautifulSoup

router = APIRouter()

@router.get("/articles")
def get_articles():
    base_url = "https://dentistrybook.net"
    category_url = f"{base_url}/category/dental-problems"
    articles = []

    try:
        page = 1
        while True:
            url = category_url if page == 1 else f"{category_url}/page/{page}/"
            r = requests.get(url, headers={"User-Agent": "Mozilla/5.0"}, timeout=10)
            if r.status_code != 200:
                break

            soup = BeautifulSoup(r.text, "html.parser")
            article_tags = soup.select("h2.title > a.post-title.post-url")

            if not article_tags:  # No more articles
                break

            for a in article_tags:
                title = a.get_text(strip=True)
                href = a.get("href")
                articles.append({
                    "title": title,
                    "url": href if href.startswith("http") else f"{base_url}{href}"
                })

            page += 1

    except Exception as e:
        return {"error": f"Failed to fetch articles: {str(e)}", "articles": []}

    if not articles:
        return {"error": "No articles found. The site structure may have changed.", "articles": []}

    return {"articles": articles}
