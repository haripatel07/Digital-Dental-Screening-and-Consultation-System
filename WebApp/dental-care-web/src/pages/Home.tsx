import { Box, Button, Typography, Paper, Grid } from "@mui/material";
import { useNavigate } from "react-router-dom";

export default function Home() {
  const navigate = useNavigate();

  return (
    <Box p={3}>
      <Typography variant="h5" mb={2} color="primary">
        Welcome to Dental Care
      </Typography>

      <Grid container spacing={2}>
        <Grid item xs={12} sm={6}>
          <Paper sx={{ p: 3, borderRadius: 2, textAlign: "center" }}>
            <Typography variant="h6">Upload Normal Image</Typography>
            <Button variant="contained" sx={{ mt: 2 }} onClick={() => navigate("/upload-normal")}>
              Upload
            </Button>
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{ p: 3, borderRadius: 2, textAlign: "center" }}>
            <Typography variant="h6">Upload X-ray</Typography>
            <Button variant="contained" sx={{ mt: 2 }} onClick={() => navigate("/upload-xray")}>
              Upload
            </Button>
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{ p: 3, borderRadius: 2, textAlign: "center" }}>
            <Typography variant="h6">Chatbot</Typography>
            <Button variant="outlined" sx={{ mt: 2 }} onClick={() => navigate("/chatbot")}>
              Open Chatbot
            </Button>
          </Paper>
        </Grid>
        <Grid item xs={12} sm={6}>
          <Paper sx={{ p: 3, borderRadius: 2, textAlign: "center" }}>
            <Typography variant="h6">Profile</Typography>
            <Button variant="outlined" sx={{ mt: 2 }} onClick={() => navigate("/profile")}>
              View Profile
            </Button>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
}
