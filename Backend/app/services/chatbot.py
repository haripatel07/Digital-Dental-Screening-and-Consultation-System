from fastapi import FastAPI
from pydantic import BaseModel
from sentence_transformers import SentenceTransformer, util

# ------------------------------
# Load Model
# ------------------------------
# Global model variable - will be loaded lazily
model = None

def load_model():
    global model
    if model is None:
        model = SentenceTransformer("all-MiniLM-L6-v2")
    return model

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
    "Can dental problems affect overall health?": "Yes, poor oral health is linked to heart disease, diabetes, and other systemic issues.",
    "What is plaque?": "Plaque is a sticky film of bacteria that forms on teeth and can lead to cavities and gum disease.",
    "How do I care for my child's teeth?": "Start brushing as soon as the first tooth appears, use a small amount of fluoride toothpaste, and schedule regular dental visits.",
    "What is tartar?": "Tartar is hardened plaque that can only be removed by a dental professional.",
    "Can I reverse tooth decay?": "Early decay can sometimes be reversed with fluoride, but advanced decay requires professional treatment.",
    "What is a dental crown?": "A dental crown is a cap placed over a damaged tooth to restore its shape, size, and function.",
    "How do I handle a knocked-out tooth?": "Keep the tooth moist, try to place it back in the socket, and see a dentist immediately.",
    "Are dental X-rays safe?": "Dental X-rays use low levels of radiation and are considered safe for most patients.",
    "What is orthodontics?": "Orthodontics is a dental specialty focused on correcting teeth and jaw alignment, often using braces or aligners.",
    "How do I choose a toothbrush?": "Use a soft-bristled toothbrush that fits comfortably in your mouth and replace it every 3-4 months.",
    "Can stress affect my teeth?": "Yes, stress can lead to teeth grinding, jaw pain, and other oral health issues.",
    "What is dental erosion?": "Dental erosion is the loss of tooth enamel caused by acid attack from foods, drinks, or stomach acid.",
    "How do I treat dry mouth?": "Stay hydrated, chew sugar-free gum, and consult your dentist for possible treatments.",
    "What is a dental implant?": "A dental implant is an artificial tooth root placed in the jaw to support a replacement tooth or bridge.",
    "Can I brush too hard?": "Brushing too hard can damage gums and enamel. Use gentle, circular motions.",
    "What is halitosis?": "Halitosis is persistent bad breath, often caused by bacteria, dry mouth, or certain foods.",
    "How do I prevent oral cancer?": "Avoid tobacco, limit alcohol, eat a healthy diet, and get regular dental checkups.",
    "What is a dental abscess?": "A dental abscess is a painful infection at the root of a tooth or between the gum and tooth.",
    "Can I use home remedies for tooth pain?": "Home remedies may provide temporary relief, but you should see a dentist for persistent pain.",
    "How do I care for dentures?": "Clean dentures daily, soak them overnight, and visit your dentist for regular adjustments.",
    "What is a cavity filling?": "A filling restores a tooth damaged by decay back to its normal function and shape.",
    "Can wisdom teeth cause problems?": "Yes, wisdom teeth can become impacted, infected, or cause crowding and may need removal.",
    "How do I know if I need braces?": "If you have crooked teeth, bite issues, or jaw misalignment, consult an orthodontist for evaluation.",
    "What is gum recession?": "Gum recession is when the gum tissue pulls away from the tooth, exposing the root and increasing sensitivity.",
    "How do I treat bleeding gums?": "Improve oral hygiene, use a soft toothbrush, and visit your dentist for a checkup.",
    "Can I use whitening products at home?": "Many whitening products are safe if used as directed, but consult your dentist for best results.",
}

faq_questions = list(faq_data.keys())
faq_answers = list(faq_data.values())

# Global embeddings variable - will be computed lazily
faq_embeddings = None

def get_faq_embeddings():
    global faq_embeddings
    if faq_embeddings is None:
        model = load_model()
        faq_embeddings = model.encode(faq_questions, convert_to_tensor=True)
    return faq_embeddings

# ------------------------------
# Request/Response Models
# ------------------------------
class ChatRequest(BaseModel):
    message: str

class ChatResponse(BaseModel):
    reply: str


def chatbot_endpoint(req: ChatRequest):
    user_msg = req.message
    
    # Load model and embeddings lazily
    model = load_model()
    embeddings = get_faq_embeddings()
    
    user_embedding = model.encode(user_msg, convert_to_tensor=True)

    scores = util.cos_sim(user_embedding, embeddings)[0]
    best_match_idx = int(scores.argmax())
    best_score = float(scores[best_match_idx])
    threshold = 0.55
    if best_score < threshold:
        fallback = (
            "I'm sorry, I couldn't find an exact answer to your question. "
            "Could you please rephrase or ask something else about dental health?"
        )
        return ChatResponse(reply=fallback)

    best_answer = faq_answers[best_match_idx]
    reply = f"{best_answer} If you have more questions, feel free to ask!"
    return ChatResponse(reply=reply)
