import { Box, Typography, Button, Paper } from "@mui/material";
import NavBar from "../components/Navbar";

export default function UploadNormal() {
  return (
    <Box>
      <NavBar />
      <Box p={3} display="flex" justifyContent="center">
        <Paper sx={{ p: 4, width: 500, borderRadius: 3, boxShadow: 2 }}>
          <Typography variant="h6" mb={3} color="primary" fontWeight="bold">
            Upload Normal Dental Image
          </Typography>

          <Button variant="contained" component="label" sx={{ mr: 2 }}>
            Choose File
            <input type="file" hidden />
          </Button>

          <Button variant="outlined">Submit</Button>
        </Paper>
      </Box>
    </Box>
  );
}
