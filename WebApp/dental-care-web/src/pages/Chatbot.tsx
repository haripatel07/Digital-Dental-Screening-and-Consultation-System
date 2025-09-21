import { useState } from "react";
import { Box, TextField, IconButton, CircularProgress, Typography } from "@mui/material";
import SendIcon from "@mui/icons-material/Send";
import NavBar from "../components/Navbar";
import ChatMessage from "../components/ChatMessage";
import QuickSuggestions from "../components/QuickSuggestions";
import { sendChatbotMessage } from "../services/apiService";
import "../styles/Chatbot.css";

export default function Chatbot() {
  const [messages, setMessages] = useState<{ sender: "user" | "bot"; text: string }[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  const sendMessage = async (msg: string) => {
    setMessages((prev) => [...prev, { sender: "user", text: msg }]);
    setLoading(true);
    try {
      const reply = await sendChatbotMessage(msg);
      setMessages((prev) => [...prev, { sender: "bot", text: reply }]);
    } catch (e) {
      setMessages((prev) => [
        ...prev,
        { sender: "bot", text: "Error connecting to chatbot" },
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="chatbot-gradient">
      <div className="chatbot-container">
        <div className="chatbot-header">Dental Chatbot</div>
        <div className="chatbot-messages">
          {messages.map((m, i) => (
            <ChatMessage key={i} sender={m.sender} text={m.text} />
          ))}
          {loading && <CircularProgress size={20} />}
        </div>
        <QuickSuggestions onSelect={sendMessage} />
        <div className="chatbot-input-row">
          <TextField
            fullWidth
            placeholder="Ask me about dental health..."
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => {
              if (e.key === "Enter" && input) {
                sendMessage(input);
                setInput("");
              }
            }}
          />
          <IconButton
            color="primary"
            onClick={() => {
              if (input) {
                sendMessage(input);
                setInput("");
              }
            }}
          >
            <SendIcon />
          </IconButton>
        </div>
      </div>
    </div>
  );
}
