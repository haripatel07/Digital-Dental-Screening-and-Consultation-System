import { useState } from "react";
import { Box, TextField, IconButton, CircularProgress, Chip, Typography, Paper } from "@mui/material";
import SendIcon from "@mui/icons-material/Send";
import axios from "axios";

const apiUrl = "https://web-production-cf49.up.railway.app/chatbot";

const quickSuggestions = [
  "How to prevent cavities?",
  "What causes gum disease?",
  "How do I whiten teeth?",
  "What to do for toothache?",
];

export default function Chatbot() {
  const [messages, setMessages] = useState<{ sender: "user" | "bot"; text: string }[]>([]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  const sendMessage = async (msg: string) => {
    setMessages([...messages, { sender: "user", text: msg }]);
    setLoading(true);
    try {
      const res = await axios.post(apiUrl, { message: msg });
      setMessages((prev) => [...prev, { sender: "bot", text: res.data.reply }]);
    } catch (e) {
      setMessages((prev) => [...prev, { sender: "bot", text: "⚠️ Error connecting to chatbot" }]);
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box p={2} height="100vh" display="flex" flexDirection="column">
      <Typography variant="h6" textAlign="center" mb={2}>
        Dental Chatbot
      </Typography>

      {/* Messages */}
      <Box flex={1} overflow="auto" mb={2}>
        {messages.map((m, i) => (
          <Box key={i} display="flex" justifyContent={m.sender === "user" ? "flex-end" : "flex-start"} mb={1}>
            <Paper
              sx={{
                p: 1.5,
                bgcolor: m.sender === "user" ? "primary.main" : "grey.200",
                color: m.sender === "user" ? "white" : "black",
                borderRadius: 2,
                maxWidth: "70%",
              }}
            >
              {m.text}
            </Paper>
          </Box>
        ))}
        {loading && <CircularProgress size={20} />}
      </Box>

      {/* Quick Suggestions */}
      <Box mb={1} display="flex" gap={1} flexWrap="wrap">
        {quickSuggestions.map((q, i) => (
          <Chip key={i} label={q} onClick={() => sendMessage(q)} />
        ))}
      </Box>

      {/* Input */}
      <Box display="flex">
        <TextField
          fullWidth
          placeholder="Ask me about dental health..."
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && input && sendMessage(input)}
        />
        <IconButton color="primary" onClick={() => input && sendMessage(input)}>
          <SendIcon />
        </IconButton>
      </Box>
    </Box>
  );
}
