
from fastapi import APIRouter, Query, Body
from typing import Optional
from app.services import clinic_scapper


router = APIRouter(prefix="/clinics", tags=["Clinics"])


@router.get("/")
async def get_clinics(city: Optional[str] = Query(None, description="City name"),
                      location: Optional[str] = Query(None, description="City name or 'lat,lng'"),
                      radius: int = 5000):
    # Accept `city` (used by frontend) or `location` (legacy). Prefer `location` if provided.
    loc = location or city
    if not loc:
        return {"error": "Missing query parameter. Provide 'city' or 'location'."}
    return clinic_scapper.get_nearby_clinics(loc, radius)

