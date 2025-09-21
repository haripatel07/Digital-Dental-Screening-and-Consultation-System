import io
import os
from typing import Optional

import torch
from torch import nn
from torchvision.models import resnet18
import torchvision.transforms as transforms
from PIL import Image
from fastapi import UploadFile


# ----------------------------
# Classes / labels
# ----------------------------
CLASSES = [
    "Calculus",
    "Caries",
    "Gingivitis",
    "Ulcers",
    "Tooth Discoloration",
    "Hypodontia",
]


# ----------------------------
# Classifier wrapper
# ----------------------------
class DentalClassifier:
    def __init__(self, model_path: str, class_names=CLASSES, device: Optional[torch.device] = None):
        self.device = device or (torch.device("cuda") if torch.cuda.is_available() else torch.device("cpu"))
        self.class_names = class_names
        self.num_classes = len(class_names)

        # build model
        self.model = resnet18(weights=None)
        self.model.fc = nn.Linear(self.model.fc.in_features, self.num_classes)

        # load checkpoint robustly
        checkpoint = torch.load(model_path, map_location=self.device)
        # possible containers: {'state_dict': {...}}, {'model': {...}}, or a raw state_dict
        if isinstance(checkpoint, dict):
            if "state_dict" in checkpoint:
                state = checkpoint["state_dict"]
            elif "model" in checkpoint:
                state = checkpoint["model"]
            else:
                state = checkpoint
        else:
            state = checkpoint

        # helper to strip common prefixes like 'model.' or 'module.' (from DataParallel)
        def _clean_state_dict(sd: dict):
            new_sd = {}
            for k, v in sd.items():
                new_k = k
                if new_k.startswith("model."):
                    new_k = new_k[len("model."):]
                if new_k.startswith("module."):
                    new_k = new_k[len("module."):]
                new_sd[new_k] = v
            return new_sd

        if isinstance(state, dict):
            # detect and clean prefixes if present
            first_key = next(iter(state.keys()))
            if first_key.startswith("model.") or first_key.startswith("module."):
                state = _clean_state_dict(state)

        # Strict loading; let exceptions propagate if mismatch so user sees clear errors
        self.model.load_state_dict(state)

        self.model.to(self.device)
        self.model.eval()

        # use standard resnet transform (224)
        self.transform = transforms.Compose([
            transforms.Resize((224, 224)),
            transforms.ToTensor(),
            transforms.Normalize([0.485, 0.456, 0.406], [0.229, 0.224, 0.225]),
        ])

    def predict_bytes(self, image_bytes: bytes):
        image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        tensor = self.transform(image).unsqueeze(0).to(self.device)
        with torch.no_grad():
            outputs = self.model(tensor)
            probs = torch.softmax(outputs, dim=1)
            conf, pred = torch.max(probs, 1)
        label = self.class_names[pred.item()]
        confidence = float(conf.item() * 100)
        return label, round(confidence, 2), probs.squeeze(0).cpu().tolist()


# ----------------------------
# Module-level helper: initialize classifier once
# ----------------------------
# Default path: repo_root/Models/normal_dental_model.pth
MODEL_PATH = "../Models/normal_dental_model.pth"

_classifier: Optional[DentalClassifier] = None


def load_classifier():
    global _classifier
    if _classifier is None:
        if not os.path.exists(MODEL_PATH):
            raise FileNotFoundError(f"Model file not found at {MODEL_PATH}")
        _classifier = DentalClassifier(MODEL_PATH)
    return _classifier


async def predict(file: UploadFile):
    # ensure classifier is loaded
    try:
        classifier = load_classifier()
    except Exception as e:
        return {"type": "normal_image", "error": f"Model load error: {str(e)}"}

    try:
        image_bytes = await file.read()
        if not image_bytes:
            return {"type": "normal_image", "error": "Empty file"}
        label, confidence, probabilities = classifier.predict_bytes(image_bytes)
        # return `prediction` and `confidence` (remove redundant `disease` field)
        return {
            "type": "normal_image",
            "prediction": label,
            "confidence": confidence,
            "recommendation": "Maintain oral hygiene. Visit dentist for further checkup.",
        }
    except Exception as e:
        return {"type": "normal_image", "error": f"Prediction error: {str(e)}"}