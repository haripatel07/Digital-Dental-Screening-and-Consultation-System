import { Box, Typography, Paper, Button, List, ListItem, ListItemText } from "@mui/material";
import { useNavigate } from "react-router-dom";

export default function Profile() {
  const navigate = useNavigate();

  const clinics = [
    { name: "BrightSmile Dental", rating: 4.6, distance: "1.2 km" },
    { name: "City Care Dental", rating: 4.4, distance: "2.0 km" },
    { name: "Pearl Dental Studio", rating: 4.7, distance: "3.1 km" },
  ];

  return (
    <Box p={3}>
      <Paper sx={{ p: 3, borderRadius: 3, textAlign: "center", mb: 3 }}>
        <Typography variant="h6">User Name</Typography>
        <Typography color="text.secondary">user@example.com</Typography>
      </Paper>

      <Typography variant="h6" mb={1} color="primary">
        Nearby Clinics
      </Typography>
      <List>
        {clinics.map((c, i) => (
          <ListItem
            key={i}
            sx={{ border: "1px solid #ddd", borderRadius: 2, mb: 1 }}
            secondaryAction={<Button variant="contained">Contact</Button>}
          >
            <ListItemText primary={c.name} secondary={`⭐ ${c.rating} • ${c.distance}`} />
          </ListItem>
        ))}
      </List>

      <Button variant="outlined" fullWidth sx={{ mt: 2 }}>
        Connect with a Doctor
      </Button>

      <Button
        variant="contained"
        color="error"
        fullWidth
        sx={{ mt: 2 }}
        onClick={() => navigate("/")}
      >
        Logout
      </Button>
    </Box>
  );
}
