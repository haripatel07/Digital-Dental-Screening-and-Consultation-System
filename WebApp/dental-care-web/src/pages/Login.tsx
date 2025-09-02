import { Box, Button, TextField, Typography, Paper } from "@mui/material";
import { useNavigate } from "react-router-dom";

export default function Login() {
  const navigate = useNavigate();

  return (
    <Box display="flex" justifyContent="center" alignItems="center" height="100vh" bgcolor="grey.100">
      <Paper sx={{ p: 4, width: 350, borderRadius: 3, textAlign: "center" }}>
        <Typography variant="h5" mb={2} color="primary">
          Dental Care Login
        </Typography>

        <TextField label="Email" type="email" fullWidth margin="normal" />
        <TextField label="Password" type="password" fullWidth margin="normal" />

        <Button variant="contained" fullWidth sx={{ mt: 2 }} onClick={() => navigate("/home")}>
          Login
        </Button>

        <Button variant="text" fullWidth sx={{ mt: 1 }} onClick={() => navigate("/signup")}>
          Don’t have an account? Sign up
        </Button>
      </Paper>
    </Box>
  );
}
