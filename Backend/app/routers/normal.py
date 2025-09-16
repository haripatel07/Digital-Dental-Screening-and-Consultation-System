from fastapi import APIRouter, UploadFile, File
from app.services import predictor_normal

router = APIRouter()

@router.post("/normal")
async def predict_normal(file: UploadFile = File(...)):
    result = await predictor_normal.predict(file)
    return result
