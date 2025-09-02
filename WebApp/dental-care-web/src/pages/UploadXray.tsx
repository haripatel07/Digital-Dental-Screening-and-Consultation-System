import { Box, Typography, Button } from "@mui/material";

export default function UploadXray() {
  return (
    <Box p={3}>
      <Typography variant="h6" mb={2} color="primary">
        Upload Dental X-ray
      </Typography>

      <Button variant="contained" component="label">
        Choose File
        <input type="file" hidden />
      </Button>

      <Button variant="outlined" sx={{ ml: 2 }}>
        Submit
      </Button>
    </Box>
  );
}
