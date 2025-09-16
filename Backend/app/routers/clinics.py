from fastapi import APIRouter, Query
from app.services import clinic_scraper

router = APIRouter(prefix="/clinics", tags=["Clinics"])

@router.get("/")
async def get_clinics(location: str = Query(..., description="City name or 'lat,lng'"),
                      radius: int = 5000):
    return clinic_scraper.get_nearby_clinics(location, radius)
