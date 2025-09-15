import torch
import torchvision.transforms as transforms
from PIL import Image
from fastapi import UploadFile
import io

# Load your model
MODEL_PATH = "Models/xray_model.pth"
model = torch.load(MODEL_PATH, map_location=torch.device("cpu"))
model.eval()

# Define same transforms you used in training
transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize([0.5], [0.5])
])

# Classes must match your training labels
CLASSES = ["Healthy", "Impacted Tooth", "Bone Loss", "Cavity Detected"]

async def predict(file: UploadFile):
    image_bytes = await file.read()
    image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    img_tensor = transform(image).unsqueeze(0)  # batch of 1

    with torch.no_grad():
        outputs = model(img_tensor)
        probs = torch.softmax(outputs, dim=1)
        confidence, predicted = torch.max(probs, 1)

    prediction = CLASSES[predicted.item()]
    confidence = round(confidence.item() * 100, 2)

    return {
        "type": "xray_image",
        "prediction": prediction,
        "confidence": confidence,
        "recommendation": "Consult dentist immediately." if prediction != "Healthy" else "Maintain oral hygiene."
    }
