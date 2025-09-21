import { AppBar, Toolbar, Typography, Button, Box } from "@mui/material";
import { useNavigate, useLocation } from "react-router-dom";

export default function Navbar() {
  const navigate = useNavigate();
  const location = useLocation();

  const menuItems = [
    { label: "Home", path: "/home" },
    { label: "Upload Normal", path: "/upload-normal" },
    { label: "Upload X-ray", path: "/upload-xray" },
    { label: "Chatbot", path: "/chatbot" },
    { label: "Profile", path: "/profile" },
    { label: "Articles", path: "/articles" },
  ];

  return (
    <AppBar position="static" color="primary">
      <Toolbar>
        <Typography
          variant="h6"
          sx={{ flexGrow: 1, cursor: "pointer" }}
          onClick={() => navigate("/home")}
        >
          🦷 Dental Care
        </Typography>
        <Box>
          {menuItems.map((item) => (
            <Button
              key={item.path}
              color="inherit"
              sx={{
                fontWeight: location.pathname === item.path ? "bold" : "normal",
              }}
              onClick={() => navigate(item.path)}
            >
              {item.label}
            </Button>
          ))}
        </Box>
      </Toolbar>
    </AppBar>
  );
}
