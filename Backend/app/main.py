from fastapi import FastAPI
from app.routers import normal, xray
from fastapi.middleware.cors import CORSMiddleware



app = FastAPI(
    title="Dental Screening API",
    description="API for dental disease detection (Normal Images + X-rays)",
    version="1.0.0"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # later restrict to your app domains
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Routers
app.include_router(normal.router, prefix="/predict", tags=["Normal Image"])
app.include_router(xray.router, prefix="/predict", tags=["X-ray Image"])

@app.get("/")
def root():
    return {"message": "Dental Screening API is running!"}
