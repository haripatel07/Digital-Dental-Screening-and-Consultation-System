from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer, util

# ------------------------------
# Initialize FastAPI
# ------------------------------
app = FastAPI(title="Dental Chatbot API")

# Allow Flutter/Web App to access API
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # restrict in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ------------------------------
# Load Model
# ------------------------------
model = SentenceTransformer("all-MiniLM-L6-v2")

# ------------------------------
# Expanded Dental FAQ Knowledge Base
# ------------------------------
faq_data = {
    "What causes cavities?": "Cavities are caused by bacteria producing acids that erode the tooth enamel.",
    "How can I prevent cavities?": "Brush twice daily with fluoride toothpaste, floss regularly, and reduce sugary foods.",
    "What are symptoms of gum disease?": "Red, swollen, or bleeding gums, and persistent bad breath are common symptoms.",
    "How to treat gum disease?": "Mild gum disease can be treated with professional cleaning; severe cases may need scaling and antibiotics.",
    "What should I do for a toothache?": "Rinse with warm salt water, take over-the-counter pain relief, and visit a dentist if it persists.",
    "How often should I visit the dentist?": "You should visit your dentist every 6 months for routine checkups and cleaning.",
    "How to whiten yellow teeth?": "Professional cleaning, whitening toothpaste, or safe whitening treatments can help.",
    "Give me some dental tips": "Brush twice a day, floss daily, drink water after meals, and avoid smoking for good oral health.",
    "Why do gums bleed while brushing?": "Bleeding gums can be a sign of gingivitis or improper brushing technique.",
    "Is mouthwash necessary?": "Mouthwash helps reduce bacteria but should not replace brushing and flossing.",
    "What foods are bad for teeth?": "Sugary drinks, sticky candies, and acidic foods increase the risk of tooth decay.",
    "What foods are good for teeth?": "Dairy products, leafy greens, crunchy fruits, and nuts support dental health.",
    "Why does my breath smell bad?": "Bad breath can result from poor oral hygiene, gum disease, or dry mouth.",
    "How can I fix bad breath?": "Brush twice daily, floss, stay hydrated, and use antibacterial mouthwash.",
    "Are electric toothbrushes better?": "Electric toothbrushes remove more plaque and are often easier to use effectively.",
    "What is root canal treatment?": "A root canal treats infection inside the tooth by cleaning and sealing the canals.",
    "Is tooth extraction painful?": "Extractions are done under anesthesia, so pain is minimal; some soreness afterward is normal.",
    "What is fluoride and why is it important?": "Fluoride strengthens tooth enamel and helps prevent cavities.",
    "Do I need dental sealants?": "Sealants protect the chewing surfaces of back teeth, especially in children and teens.",
    "What causes sensitive teeth?": "Sensitivity may result from worn enamel, cavities, or gum recession.",
    "How can I treat sensitive teeth?": "Use desensitizing toothpaste, avoid acidic foods, and consult your dentist.",
    "Is teeth grinding harmful?": "Yes, grinding (bruxism) can wear down teeth and cause jaw pain.",
    "How can I stop teeth grinding?": "A dentist may recommend a night guard and stress reduction techniques.",
    "Why are my teeth shifting?": "Shifting can occur due to gum disease, tooth loss, or natural changes with age.",
    "Do braces hurt?": "Braces may cause mild discomfort initially, but the pain subsides as you adjust.",
}

faq_questions = list(faq_data.keys())
faq_answers = list(faq_data.values())
faq_embeddings = model.encode(faq_questions, convert_to_tensor=True)

# ------------------------------
# Request/Response Models
# ------------------------------
class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    reply: str

# ------------------------------
# Chatbot Endpoint
# ------------------------------
@app.post("/chatbot", response_model=ChatResponse)
def chatbot_endpoint(req: ChatRequest):
    user_msg = req.message
    user_embedding = model.encode(user_msg, convert_to_tensor=True)

    scores = util.cos_sim(user_embedding, faq_embeddings)[0]
    best_match_idx = int(scores.argmax())
    best_answer = faq_answers[best_match_idx]

    return ChatResponse(reply=best_answer)
