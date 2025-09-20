import requests
from bs4 import BeautifulSoup
from fastapi import APIRouter

router = APIRouter()

@router.get("/articles")
def get_articles():
    base_url = "https://www.ada.org"
    topics_url = f"{base_url}/resources/research/science-and-research-institute/oral-health-topics"
    response = requests.get(topics_url)
    soup = BeautifulSoup(response.text, 'html.parser')
    articles = []

    # Find all article/topic links in the main topics list
    for link in soup.find_all('a'):
        href = link.get('href')
        title = link.get_text(strip=True)
        if (
            href
            and href.startswith('/resources/research/science-and-research-institute/oral-health-topics/')
            and not href.endswith(('.pdf', '.jpg', '.png'))
            and title
            and len(href) > len('/resources/research/science-and-research-institute/oral-health-topics/')
        ):
            articles.append({
                "title": title,
                "url": f"{base_url}{href}"
            })

    return {"articles": articles}
