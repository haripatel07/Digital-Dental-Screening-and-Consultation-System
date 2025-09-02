import { useState } from "react";
import { Box, TextField, IconButton, CircularProgress, Typography } from "@mui/material";
import SendIcon from "@mui/icons-material/Send";
import axios from "axios";
import NavBar from "../components/Navbar";
import ChatMessage from "../components/ChatMessage";
import QuickSuggestions from "../components/QuickSuggestions";

const apiUrl = "https://web-production-cf49.up.railway.app/chatbot";

export default function Chatbot() {
  const [messages, setMessages] = useState<{ sender: "user" | "bot"; text: string }[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  const sendMessage = async (msg: string) => {
    setMessages((prev) => [...prev, { sender: "user", text: msg }]);
    setLoading(true);
    try {
      const res = await axios.post(apiUrl, { message: msg });
      setMessages((prev) => [...prev, { sender: "bot", text: res.data.reply }]);
    } catch (e) {
      setMessages((prev) => [
        ...prev,
        { sender: "bot", text: "⚠️ Error connecting to chatbot" },
      ]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box>
      <NavBar />
      <Box p={2} height="calc(100vh - 64px)" display="flex" flexDirection="column">
        <Typography variant="h6" textAlign="center" mb={2}>
          Dental Chatbot
        </Typography>

        {/* Messages */}
        <Box flex={1} overflow="auto" mb={2}>
          {messages.map((m, i) => (
            <ChatMessage key={i} sender={m.sender} text={m.text} />
          ))}
          {loading && <CircularProgress size={20} />}
        </Box>

        {/* Quick Suggestions */}
        <QuickSuggestions onSelect={sendMessage} />

        {/* Input */}
        <Box display="flex" mt={1}>
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
        </Box>
      </Box>
    </Box>
  );
}
