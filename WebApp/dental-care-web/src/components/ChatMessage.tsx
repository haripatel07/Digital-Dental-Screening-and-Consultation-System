import { Box, Typography } from "@mui/material";

interface ChatMessageProps {
  sender: "user" | "bot";
  text: string;
}

export default function ChatMessage({ sender, text }: ChatMessageProps) {
  const isUser = sender === "user";

  return (
    <Box
      display="flex"
      justifyContent={isUser ? "flex-end" : "flex-start"}
      mb={1}
    >
      <Box
        sx={{
          bgcolor: isUser ? "teal.main" : "grey.200",
          color: isUser ? "white" : "black",
          px: 2,
          py: 1,
          borderRadius: 2,
          maxWidth: "70%",
        }}
      >
        <Typography variant="body2">{text}</Typography>
      </Box>
    </Box>
  );
}
