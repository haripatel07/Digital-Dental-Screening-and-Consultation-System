from fastapi import APIRouter, UploadFile, File
from app.services import predictor_xray

router = APIRouter()

@router.post("/xray")
async def predict_xray(file: UploadFile = File(...)):
    result = await predictor_xray.predict(file)
    return result
