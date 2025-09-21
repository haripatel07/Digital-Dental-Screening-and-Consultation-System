import React from "react";
import { useNavigate } from "react-router-dom";
import "../styles/Home.css";

const items = [
  { label: "Upload Normal Image", icon: "📷", route: "/upload-normal" },
  { label: "Upload X-ray Image", icon: "🩻", route: "/upload-xray" },
  { label: "Chatbot", icon: "💬", route: "/chatbot" },
  { label: "Articles", icon: "📄", route: "/articles" },
  { label: "Profile", icon: "👤", route: "/profile" },
];

const Home: React.FC = () => {
  const navigate = useNavigate();
  return (
    <div className="home-gradient">
      <header className="home-header">
        <h1>Dental Care</h1>
        <button className="logout-btn" onClick={() => navigate("/login")}>
          Logout
        </button>
      </header>
      <div className="home-grid">
        {items.map((item) => (
          <div
            key={item.route}
            className="home-card"
            onClick={() => navigate(item.route)}
          >
            <span className="home-icon">{item.icon}</span>
            <div>{item.label}</div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default Home;
