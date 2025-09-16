import requests
import os
from dotenv import load_dotenv
from geopy.geocoders import Nominatim

load_dotenv()

GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")

def get_coordinates(location_name: str):
    """Convert city/location name to latitude & longitude."""
    geolocator = Nominatim(user_agent="clinic_scraper")
    location = geolocator.geocode(location_name)
    if location:
        return location.latitude, location.longitude
    return None, None

def get_nearby_clinics(location: str, radius: int = 5000):
    """Fetch nearby dental clinics given location name or lat/lon."""
    if "," in location:  # user passed lat,lng
        lat, lon = map(float, location.split(","))
    else:  # convert city name to lat/lon
        lat, lon = get_coordinates(location)

    if not lat or not lon:
        return {"error": "Invalid location"}

    url = (
        f"https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        f"?location={lat},{lon}&radius={radius}&keyword=dental+clinic"
        f"&key={GOOGLE_MAPS_API_KEY}"
    )

    response = requests.get(url)
    data = response.json()

    results = []
    for place in data.get("results", []):
        results.append({
            "name": place.get("name"),
            "address": place.get("vicinity"),
            "rating": place.get("rating"),
            "user_ratings_total": place.get("user_ratings_total"),
            "location": place["geometry"]["location"],
        })

    return {"clinics": results}
