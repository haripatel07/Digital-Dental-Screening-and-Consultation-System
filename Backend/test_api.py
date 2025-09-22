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
        if response.status_code == 200:
            return response.json().get('token')
        return None
    except Exception as e:
        print(f"Login Error: {e}")
        return None

# Test Get User Details
def test_get_user_details(token):
    url = f"{BASE_URL}/auth/user-details"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.get(url, headers=headers)
        print("Get User Details Response:", response.status_code, response.json())
        return response.json() if response.status_code == 200 else None
    except Exception as e:
        print(f"Get User Details Error: {e}")
        return None

# Test Update User Details
def test_update_user_details(token, updates):
    url = f"{BASE_URL}/auth/user-details"
    headers = {"Authorization": f"Bearer {token}"}
    try:
        response = requests.put(url, json=updates, headers=headers)
        print("Update User Details Response:", response.status_code, response.json())
        return response.json() if response.status_code == 200 else None
    except Exception as e:
        print(f"Update User Details Error: {e}")
        return None

# Test Complete User Flow
def test_user_flow():
    print("=== Testing Complete User Flow ===")
    
    # 1. Signup
    email = "flowtest@example.com"
    password = "testpass123"
    name = "Flow Test User"
    
    print("\n1. Testing Signup...")
    test_signup(email, password, name)
    
    # 2. Login
    print("\n2. Testing Login...")
    token = test_login(email, password)
    
    if not token:
        print("Login failed, cannot continue with user details tests")
        return
    
    # 3. Get initial user details
    print("\n3. Testing Get User Details...")
    user_details = test_get_user_details(token)
    
    # 4. Update user details
    print("\n4. Testing Update User Details...")
    updates = {
        "name": "Updated Flow Test User",
        "phone": "+1234567890",
        "address": "123 Test Street, Test City",
        "city": "Ahmedabad",
        "age": 25
    }
    updated_details = test_update_user_details(token, updates)
    
    # 5. Get updated user details to verify
    print("\n5. Testing Get Updated User Details...")
    final_details = test_get_user_details(token)
    
    print("\n=== User Flow Test Complete ===")

if __name__ == "__main__":
    # Basic endpoint tests
    test_normal("sample_data/normal1.jpg")
    test_xray("sample_data/xray1.jpg")
    test_scrapper("Ahmedabad")
    test_chatbot("How can I prevent cavities?")
    test_articles()
    
    # Auth and user details tests
    #test_signup("testuser@example.com", "testpass123", name="Test User")
    #token = test_login("testuser@example.com", "testpass123")
    #if token:
    #    test_get_user_details(token)
    #    test_update_user_details(token, {"name": "Updated Test User", "phone": "1234567890", "city": "Mumbai"})
    #    test_get_user_details(token)
    
    # Complete user flow test
    test_user_flow()
