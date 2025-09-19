import requests

BASE_URL = "http://127.0.0.1:8001"


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

if __name__ == "__main__":
    #test_normal("sample_data/normal1.jpg")
    #test_xray("sample_data/xray1.jpg")
    #test_scrapper("Ahmedabad")
    test_chatbot("How can I prevent cavities?")
