import { Box, Button, TextField, Typography, Paper } from "@mui/material";
import { useNavigate } from "react-router-dom";

export default function Signup() {
  const navigate = useNavigate();

  return (
    <Box display="flex" justifyContent="center" alignItems="center" height="100vh" bgcolor="grey.100">
      <Paper sx={{ p: 5, width: 380, borderRadius: 3, boxShadow: 3 }}>
        <Typography variant="h5" mb={3} fontWeight="bold" color="primary" textAlign="center">
          Create Account
        </Typography>

        <TextField label="Name" fullWidth margin="normal" />
        <TextField label="Email" type="email" fullWidth margin="normal" />
        <TextField label="Password" type="password" fullWidth margin="normal" />

        <Button variant="contained" fullWidth sx={{ mt: 3 }} onClick={() => navigate("/home")}>
          Sign Up
        </Button>

        <Button variant="text" fullWidth sx={{ mt: 2 }} onClick={() => navigate("/")}>
          Already have an account? Login
        </Button>
      </Paper>
    </Box>
  );
}
