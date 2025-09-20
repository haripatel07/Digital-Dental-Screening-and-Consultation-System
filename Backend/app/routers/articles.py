from fastapi import APIRouter
from app.services.article_scraper import get_articles

router = APIRouter()

@router.get("/articles", tags=["Articles"])
def articles():
    return get_articles()
