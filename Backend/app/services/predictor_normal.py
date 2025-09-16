import torch
from torch import nn
from torchvision.models import resnet18, ResNet18_Weights
import torchvision.transforms as transforms
from PIL import Image
from fastapi import UploadFile
import io
import os

# ----------------------------
# Classes
# ----------------------------
CLASSES = ['Calculus', 'Caries', 'Gingivitis', 'Ulcers', 'Tooth Discoloration', 'Hypodontia']
num_classes = len(CLASSES)

# ----------------------------
# Model Definition
# ----------------------------
class CustomModel(nn.Module):
    def __init__(self):
        super(CustomModel, self).__init__()
        self.model = resnet18(weights=ResNet18_Weights.IMAGENET1K_V1)
        self.model.fc = nn.Linear(self.model.fc.in_features, num_classes)

    def forward(self, x):
        return self.model(x)

# ----------------------------
# Load the model
# ----------------------------
MODEL_PATH = "../Models/normal_dental_model.pth"
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

model = CustomModel()
checkpoint = torch.load(MODEL_PATH, map_location=device)
if 'model' in checkpoint:
    model.load_state_dict(checkpoint['model'])
else:
    model.load_state_dict(checkpoint)
model.to(device)
model.eval()

# ----------------------------
# Image Transform
# ----------------------------
transform = transforms.Compose([
    transforms.Resize((128, 128)),
    transforms.CenterCrop((128, 128)),
    transforms.ToTensor(),
    transforms.Normalize([0.485, 0.456, 0.406],
                         [0.229, 0.224, 0.225]),
])

# ----------------------------
# Prediction Function
# ----------------------------
async def predict(file: UploadFile):
    try:
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    except Exception:
        return {
            "type": "normal_image",
            "error": "Invalid image file."
        }

    img_tensor = transform(image).unsqueeze(0).to(device)

    with torch.no_grad():
        outputs = model(img_tensor)
        probs = torch.softmax(outputs, dim=1)
        confidence, predicted = torch.max(probs, 1)

    prediction = CLASSES[predicted.item()]
    confidence = round(confidence.item() * 100, 2)

    return {
        "type": "normal_image",
        "prediction": prediction,
        "confidence": confidence,
        "recommendation": "Maintain oral hygiene. Visit dentist for further checkup."
    }