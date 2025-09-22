import torch
import torch.nn as nn
import timm
import torchvision.transforms as transforms
from PIL import Image
from fastapi import UploadFile
import io
import os
import numpy as np
import cv2
import asyncio
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# -----------------------------
# Model Definition
# -----------------------------
class SwinDentalModel(nn.Module):
    def __init__(self, num_classes=6):
        super().__init__()
        self.backbone = timm.create_model(
            'swin_tiny_patch4_window7_224',
            pretrained=False,
            num_classes=0
        )
        self.classifier = nn.Linear(self.backbone.num_features, num_classes)

    def forward(self, x):
        feats = self.backbone(x)
        return self.classifier(feats)

# -----------------------------
# Load Model Checkpoint
# -----------------------------
MODEL_PATH = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), "models", "final_dental_xray_model.pth")
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
logger.info(f"Using device: {device}")

# Global model variable - will be loaded lazily
model = None

def load_model():
    global model
    if model is None:
        model = SwinDentalModel(num_classes=6)
        try:
            ckpt = torch.load(MODEL_PATH, map_location=device)
            if "student" in ckpt:
                state_dict = ckpt["student"]
                logger.info("Loaded 'student' encoder from DINO checkpoint")
            elif "teacher" in ckpt:
                state_dict = ckpt["teacher"]
                logger.info("Loaded 'teacher' encoder from DINO checkpoint")
            elif "state_dict" in ckpt:
                state_dict = ckpt["state_dict"]
                logger.info("Loaded 'state_dict' from checkpoint")
            else:
                state_dict = ckpt
                logger.info("Loaded direct state_dict")

            new_state = {}
            for k, v in state_dict.items():
                new_k = k.replace("module.", "").replace("backbone.", "").replace("student.", "").replace("teacher.", "")
                new_state[new_k] = v

            model.load_state_dict(new_state, strict=False)
            model.to(device)
            model.eval()
            logger.info("Model loaded successfully")
        except Exception as e:
            logger.error(f"Error loading model: {e}")
            raise
    return model

# -----------------------------
# CLAHE Transform
# -----------------------------
class CLAHETransform:
    def __init__(self, clip_limit=2.0, tile_grid_size=(8, 8)):
        self.clahe = cv2.createCLAHE(clipLimit=clip_limit, tileGridSize=tile_grid_size)

    def __call__(self, img: Image.Image) -> Image.Image:
        img_np = np.array(img.convert("L"))
        img_clahe = self.clahe.apply(img_np)
        return Image.fromarray(img_clahe).convert("RGB")

# -----------------------------
# Preprocessing
# -----------------------------
transform = transforms.Compose([
    CLAHETransform(),
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
])

# -----------------------------
# Prediction Function
# -----------------------------
async def predict(file: UploadFile) -> dict:
    try:
        # Load model lazily when first prediction is made
        model = load_model()
        
        image_bytes = await file.read()
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
    except Exception as e:
        return {
            "type": "xray_image",
            "error": f"Error processing image: {str(e)}"
        }

    input_tensor = transform(image).unsqueeze(0).to(device)

    def _infer():
        with torch.no_grad():
            outputs = model(input_tensor)
            probs = torch.softmax(outputs, dim=1)
            confidence, predicted = torch.max(probs, 1)
        return confidence, predicted

    confidence, predicted = await asyncio.get_event_loop().run_in_executor(None, _infer)

    class_names = ['BDC-BDR', 'Infection', 'Impacted teeth', 'Caries', 'Healthy Teeth', 'Fractured Teeth']
    pred_class = class_names[predicted.item()]
    confidence_pct = round(confidence.item() * 100, 2)

    return {
        "type": "xray_image",
        "prediction": pred_class,
        "confidence": confidence_pct,
        "recommendation": (
            "Maintain oral hygiene."
            if pred_class == 'Healthy Teeth'
            else "Consult dentist immediately."
        )
    }