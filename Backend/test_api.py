import requests

BASE_URL = "http://127.0.0.1:8001"
# Test Articles Endpoint
def test_articles():
    url = f"{BASE_URL}/content/articles"
    try:
        response = requests.get(url)
        response.raise_for_status()
        articles = response.json().get('articles', [])
        print(f"Articles ({len(articles)}):")
        for i, article in enumerate(articles[:5], 1):
            print(f"{i}. {article.get('title')} - {article.get('url')}")
    except Exception as e:
        print(f"Articles Endpoint Error: {e}")
import requests


# Test Normal Image
def test_normal(image_path):
    url = f"{BASE_URL}/predict/normal"
    with open(image_path, "rb") as f:
        files = {"file": f}
        try:
            response = requests.post(url, files=files)
            response.raise_for_status()
            print("Normal Image Prediction:", response.json())
        except Exception as e:
            print(f"Normal Image Prediction Error: {e}")


# Test X-ray Image
def test_xray(image_path):
    url = f"{BASE_URL}/predict/xray"
    with open(image_path, "rb") as f:
        files = {"file": f}
        try:
            response = requests.post(url, files=files)
            response.raise_for_status()
            print("X-ray Image Prediction:", response.json())
        except Exception as e:
            print(f"X-ray Image Prediction Error: {e}")

# Test Clinic Scrapper
def test_scrapper(city_name):
    url = f"{BASE_URL}/clinics"
    params = {"location": city_name}
    try:
        response = requests.get(url, params=params)
        response.raise_for_status()
        print("Scrapper Response:", response.json())
    except Exception as e:
        print(f"Scrapper Error: {e}")

# Test Chatbot
def test_chatbot(message):
    url = f"{BASE_URL}/chatbot/"
    payload = {"message": message}
    try:
        response = requests.post(url, json=payload)
        response.raise_for_status()
        print("Chatbot Response:", response.json())
    except Exception as e:
        print(f"Chatbot Error: {e}")

# Test Auth Signup
def test_signup(email, password, name=None):
    url = f"{BASE_URL}/auth/signup"
    payload = {"email": email, "password": password}
    if name:
        payload["name"] = name
    try:
        response = requests.post(url, json=payload)
        print("Signup Response:", response.status_code, response.json())
    except Exception as e:
        print(f"Signup Error: {e}")

# Test Auth Login
def test_login(email, password):
    url = f"{BASE_URL}/auth/login"
    payload = {"email": email, "password": password}
    try:
        response = requests.post(url, json=payload)
        print("Login Response:", response.status_code, response.json())
    except Exception as e:
        print(f"Login Error: {e}")

if __name__ == "__main__":
    #test_normal("sample_data/normal1.jpg")
    #test_xray("sample_data/xray1.jpg")
    #test_scrapper("Ahmedabad")
    #test_chatbot("How can I prevent cavities?")
    #test_signup("testuser@example.com", "testpass123", name="Test User")
    #test_login("testuser@example.com", "testpass123")
    test_articles()
