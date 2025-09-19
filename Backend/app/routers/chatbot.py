from fastapi import APIRouter
from app.services.chatbot import ChatRequest, ChatResponse, chatbot_endpoint

router = APIRouter()

@router.post("/", response_model=ChatResponse)
def chat(req: ChatRequest):
    return chatbot_endpoint(req)
