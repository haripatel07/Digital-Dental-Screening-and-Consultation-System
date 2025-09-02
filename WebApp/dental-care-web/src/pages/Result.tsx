import { Box, Typography, Paper } from "@mui/material";
import NavBar from "../components/Navbar";

export default function Result() {
  return (
    <Box>
      <NavBar />
      <Box p={3}>
        <Typography variant="h6" mb={2} color="primary">
          Model Prediction Result
        </Typography>

        <Paper sx={{ p: 3, borderRadius: 2 }}>
          <Typography>
            🦷 Prediction: <b>Cavity Detected</b>
          </Typography>
          <Typography>
            Confidence: <b>87%</b>
          </Typography>
        </Paper>
      </Box>
    </Box>
  );
}
