import React, { useState } from "react";
import { Box, Button, TextField, Typography, Paper } from "@mui/material";
import { useNavigate } from "react-router-dom";
import { saveToken } from "../services/authStorage";
import axios from "axios";

export default function Login() {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const response = await axios.post(
        "http://127.0.0.1:8001/auth/login",
        { email, password }
      );
      saveToken(response.data); // Pass full response to saveToken
      navigate("/");
    } catch (err: any) {
      setError(err.response?.data?.message || "Login failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box
      display="flex"
      justifyContent="center"
      alignItems="center"
      height="100vh"
      bgcolor="grey.100"
    >
      <Paper sx={{ p: 5, width: 380, borderRadius: 3, boxShadow: 3 }}>
        <Typography
          variant="h5"
          mb={3}
          fontWeight="bold"
          color="primary"
          textAlign="center"
        >
          Dental Care Login
        </Typography>

        <form className="login-form" onSubmit={handleSubmit}>
          <TextField
            label="Email"
            type="email"
            fullWidth
            margin="normal"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
          <TextField
            label="Password"
            type="password"
            fullWidth
            margin="normal"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />

          <Button
            variant="contained"
            fullWidth
            sx={{ mt: 3 }}
            onClick={handleSubmit}
            disabled={loading}
          >
            {loading ? "Logging in..." : "Login"}
          </Button>

          {error && (
            <div className="error" style={{ color: "red", marginTop: "10px" }}>
              {error}
            </div>
          )}

          <Button
            variant="text"
            fullWidth
            sx={{ mt: 2 }}
            onClick={() => navigate("/signup")}
          >
            Don’t have an account? Sign up
          </Button>
        </form>
      </Paper>
    </Box>
  );
}
