from fastapi import APIRouter, Query
<<<<<<< HEAD
from app.services import clinic_scrapper
=======
from app.services import clinic_scraper
>>>>>>> 930aa55298e57dae67c034d19efee98579d61efb

router = APIRouter(prefix="/clinics", tags=["Clinics"])

@router.get("/")
async def get_clinics(location: str = Query(..., description="City name or 'lat,lng'"),
                      radius: int = 5000):
<<<<<<< HEAD
    return clinic_scrapper.get_nearby_clinics(location, radius)
=======
    return clinic_scraper.get_nearby_clinics(location, radius)
>>>>>>> 930aa55298e57dae67c034d19efee98579d61efb
