import React, { useState } from "react";
import { Box, Button, TextField, Typography, Paper } from "@mui/material";
import { useNavigate } from "react-router-dom";
import axios from "axios";

export default function Signup() {
  const [name, setName] = useState("");
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
      await axios.post("http://127.0.0.1:8001/auth/signup", { name, email, password });
      navigate("/login");
    } catch (err: any) {
      setError(err.response?.data?.message || "Signup failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <Box display="flex" justifyContent="center" alignItems="center" height="100vh" bgcolor="grey.100">
      <Paper sx={{ p: 5, width: 380, borderRadius: 3, boxShadow: 3 }}>
        <Typography variant="h5" mb={3} fontWeight="bold" color="primary" textAlign="center">
          Create Account
        </Typography>

        <form onSubmit={handleSubmit}>
          <TextField
            label="Name"
            fullWidth
            margin="normal"
            value={name}
            onChange={(e) => setName(e.target.value)}
            required
          />
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

          <Button variant="contained" fullWidth sx={{ mt: 3 }} type="submit" disabled={loading}>
            {loading ? "Signing up..." : "Sign Up"}
          </Button>

          {error && <div className="error">{error}</div>}

          <Button variant="text" fullWidth sx={{ mt: 2 }} onClick={() => navigate("/login")}>
            Already have an account? Login
          </Button>
        </form>
      </Paper>
    </Box>
  );
}
