# Digital Dental Screening and Consultation System

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![React](https://img.shields.io/badge/React-18+-blue.svg)](https://reactjs.org/)
[![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue.svg)](https://flutter.dev/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-green.svg)](https://fastapi.tiangolo.com/)
[![PyTorch](https://img.shields.io/badge/PyTorch-2.0+-red.svg)](https://pytorch.org/)

A comprehensive, AI-powered dental health platform that enables users to screen dental conditions through image analysis, receive AI-driven recommendations, and connect with nearby dental clinics. This full-stack application integrates machine learning models for accurate diagnosis, a responsive web interface, a cross-platform mobile app, and a robust backend API.

Developed by **Hari Patel** and **Het Patel** as a capstone project demonstrating expertise in full-stack development, AI/ML integration, and scalable system architecture.

## Features

### Core Functionality
- **AI-Powered Image Analysis**: Upload dental images (normal photos or X-rays) for automated disease detection using custom-trained PyTorch models
- **Real-Time Predictions**: Instant analysis with confidence scores and personalized dental recommendations
- **Clinic Locator**: Integrated clinic search using geolocation and external APIs for nearby dental services
- **Dental Articles**: Curated educational content on oral health and preventive care
- **User Authentication**: Secure login/signup with JWT-based authentication
- **Chatbot Assistance**: AI-powered chatbot for dental health queries and guidance

### Multi-Platform Support
- **Web Application**: Responsive React-based interface with modern UI/UX
- **Mobile Application**: Cross-platform Flutter app for iOS and Android
- **Backend API**: Scalable FastAPI server deployed on Hugging Face Spaces

### Technical Highlights
- **Machine Learning**: Custom CNN models for dental disease classification (accuracy-focused)
- **Cloud Deployment**: Backend hosted on Hugging Face for global accessibility
- **Database Integration**: User management and data persistence
- **API Integration**: Geopify for location services, external article scraping
- **Security**: CORS-enabled, secure API endpoints with authentication

## Technology Stack

### Backend
- **Framework**: FastAPI (Python)
- **Machine Learning**: PyTorch, timm (PyTorch Image Models)
- **Deployment**: Hugging Face Spaces
- **Database**: SQLite (with potential for PostgreSQL/MySQL scaling)
- **Authentication**: JWT tokens

### Frontend (Web)
- **Framework**: React 18 with TypeScript
- **Routing**: React Router
- **Styling**: CSS Modules with modern design principles
- **Build Tool**: Vite
- **State Management**: React Hooks

### Mobile
- **Framework**: Flutter (Dart)
- **State Management**: Provider pattern
- **API Integration**: HTTP package
- **Platform Support**: iOS, Android, Web

### Machine Learning
- **Models**: Custom-trained CNNs for normal dental images and X-ray analysis
- **Libraries**: PyTorch, torchvision, PIL
- **Training Data**: Dental image datasets
- **Deployment**: Model serving via FastAPI

### DevOps & Tools
- **Version Control**: Git
- **Containerization**: Docker (for backend)
- **API Testing**: Postman
- **Code Quality**: ESLint, Prettier

## Project Structure

```
Digital-Dental-Screening-and-Consultation-System/
├── Backend/                 # FastAPI server with ML models
│   ├── app/                 # Main application code
│   ├── models/              # Trained PyTorch models
│   ├── requirements.txt     # Python dependencies
│   └── Dockerfile           # Containerization
├── MobileApp/               # Flutter mobile application
│   ├── dental_care/         # Flutter project
│   └── pubspec.yaml         # Dart dependencies
├── WebApp/                  # React web application
│   ├── dental-care-web/     # Vite React project
│   └── package.json         # Node dependencies
├── Models/                  # Additional model files
├── Notebooks/               # Jupyter notebooks for ML experimentation
├── LICENSE                  # MIT License
└── README.md                # Project documentation
```

## Installation & Setup

### Prerequisites
- Python 3.8+
- Node.js 16+
- Flutter SDK
- Git

### Backend Setup
1. Navigate to the Backend directory:
   ```bash
   cd Backend
   ```

2. Install Python dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Run the FastAPI server:
   ```bash
   python run.py
   ```

4. The API will be available at `http://localhost:8001`

### Web Application Setup
1. Navigate to the WebApp directory:
   ```bash
   cd WebApp/dental-care-web
   ```

2. Install Node dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run dev
   ```

4. Open `http://localhost:5173` in your browser

### Mobile Application Setup
1. Navigate to the MobileApp directory:
   ```bash
   cd MobileApp/dental_care
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Run on connected device/emulator:
   ```bash
   flutter run
   ```

## Usage

1. **User Registration**: Sign up with email and password
2. **Image Upload**: Upload dental photos or X-rays for analysis
3. **AI Analysis**: Receive instant predictions with confidence scores
4. **Recommendations**: Get personalized dental care advice
5. **Clinic Search**: Find nearby dental clinics using location services
6. **Educational Content**: Browse articles on oral health
7. **Chatbot Support**: Ask questions about dental health via AI chatbot

## Contributing

We welcome contributions! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

### Development Guidelines
- Follow existing code style and conventions
- Write clear, concise commit messages
- Test your changes thoroughly
- Update documentation as needed

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

**Hari Patel** - [GitHub](https://github.com/haripatel07) | [LinkedIn](https://linkedin.com/in/haripatel87)

**Het Patel** - [GitHub](https://github.com/hetpatel) | [LinkedIn](https://linkedin.com/in/het-patel)

Project Repository: [https://github.com/haripatel07/Digital-Dental-Screening-and-Consultation-System](https://github.com/haripatel07/Digital-Dental-Screening-and-Consultation-System)

---

*This project showcases advanced skills in AI/ML, full-stack development, and cross-platform application design. Built with scalability and user experience in mind.*