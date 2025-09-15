import requests

BASE_URL = "http://127.0.0.1:8001/predict"

# Test Normal Image
def test_normal(image_path):
    url = f"{BASE_URL}/normal"
    files = {"file": open(image_path, "rb")}
    response = requests.post(url, files=files)
    print("Normal Image Prediction:", response.json())

# Test X-ray Image
def test_xray(image_path):
    url = f"{BASE_URL}/xray"
    files = {"file": open(image_path, "rb")}
    response = requests.post(url, files=files)
    print("X-ray Image Prediction:", response.json())

if __name__ == "__main__":
    # ✅ Replace with your test image paths
    test_normal("sample_data/normal1.jpg")
    test_xray("sample_data/xray1.jpg")
