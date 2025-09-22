import requests
import os
from geopy.geocoders import Nominatim

# Get your Geoapify API key from environment variables (Hugging Face Spaces secrets)
GEOAPIFY_API_KEY = os.getenv("GEOAPIFY_API_KEY")

def get_clinics_in_bbox(lon1, lat1, lon2, lat2, limit=20):
    """
    Fetch dental clinics in a bounding box using Geoapify Places API.
    Args:
        lon1, lat1: One corner of the rectangle (longitude, latitude)
        lon2, lat2: Opposite corner of the rectangle (longitude, latitude)
        limit: Max number of results (default = 20)
    Returns:
        dict with list of clinics.
    """
    url = (
        f"https://api.geoapify.com/v2/places"
        f"?categories=healthcare.dentist"
        f"&filter=rect:{lon1},{lat1},{lon2},{lat2}"
        f"&limit={limit}"
        f"&apiKey={GEOAPIFY_API_KEY}"
    )
    response = requests.get(url)
    if response.status_code != 200:
        return {"error": f"Geoapify API error {response.status_code}"}
    data = response.json()
    results = []
    for feature in data.get("features", []):
        props = feature.get("properties", {})
        coords = feature.get("geometry", {}).get("coordinates", [None, None])
        results.append({
            "name": props.get("name", "Unknown Clinic"),
            "address": props.get("formatted", ""),
            "contact": {
                "phone": props.get("phone"),
                "website": props.get("website"),
                "email": props.get("email"),
            },
            "location": {
                "lat": coords[1],
                "lon": coords[0],
            },
        })
    return {"clinics": results}


def get_coordinates(location_name: str):
    """
    Convert city/location name to latitude & longitude using Nominatim (free).
    """
    geolocator = Nominatim(user_agent="clinic_scraper")
    location = geolocator.geocode(location_name)
    if location:
        return location.latitude, location.longitude
    return None, None

def get_nearby_clinics(location: str, radius: int = 5000, limit: int = 20):
    """
    Fetch nearby dental clinics given location name or lat/lon.
    Uses:
      - Nominatim for geocoding (if user passes location name).
      - Geoapify Places API for nearby clinic search.
    Args:
        location: "City name" OR "lat,lon" (e.g., "Ahmedabad" or "23.02,72.57").
        radius: Search radius in meters (default = 5000m).
        limit: Max number of results (default = 20).
    Returns:
        dict with list of clinics.
    """
    # Always geocode city name, ignore lat,lon input
    lat, lon = get_coordinates(location)

    if lat is None or lon is None:
        return {"error": "Invalid location. Could not fetch coordinates."}

    # Build Geoapify API request (Geoapify expects lon,lat order)
    url = (
        f"https://api.geoapify.com/v2/places"
        f"?categories=healthcare.dentist"
        f"&filter=circle:{lon},{lat},{radius}"
        f"&bias=proximity:{lon},{lat}"
        f"&limit={limit}"
        f"&apiKey={GEOAPIFY_API_KEY}"
    )

    response = requests.get(url)
    if response.status_code != 200:
        return {"error": f"Geoapify API error {response.status_code}"}

    data = response.json()

    results = []
    for feature in data.get("features", []):
        props = feature.get("properties", {})
        coords = feature.get("geometry", {}).get("coordinates", [None, None])
        results.append({
            "name": props.get("name", "Unknown Clinic"),
            "address": props.get("formatted", ""),
            "rating": props.get("rating"),
            "contact": {
                "phone": props.get("phone"),
                "website": props.get("website"),
                "email": props.get("email"),
            },
            "location": {
                "lat": coords[1],
                "lon": coords[0],
            },
        })

    return {"clinics": results}
