import React, { useEffect, useState } from "react";
import { Box, Typography, Paper, Button, List, ListItem, ListItemText, TextField, Dialog, DialogTitle, DialogContent, DialogActions } from "@mui/material";
import { useNavigate } from "react-router-dom";
import NavBar from "../components/Navbar";
import { getToken, clearToken } from "../services/authStorage";
import { getUserDetails, updateUserDetails, fetchClinics } from "../services/apiService";
import "../styles/Profile.css";

interface UserDetails {
  id?: string;
  email?: string;
  name?: string;
  phone?: string;
  address?: string;
  city?: string;
  age?: number;
}

const Profile: React.FC = () => {
  const navigate = useNavigate();
  const [user, setUser] = useState<UserDetails | null>(null);
  const [clinics, setClinics] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [city, setCity] = useState<string>("");
  const [cityInput, setCityInput] = useState<string>("");
  const [detectingLocation, setDetectingLocation] = useState(false);
  const [editDialogOpen, setEditDialogOpen] = useState(false);
  const [editForm, setEditForm] = useState<UserDetails>({});
  const [updating, setUpdating] = useState(false);

  useEffect(() => {
    const token = getToken();
    if (!token) {
      navigate("/login");
      return;
    }
    // Fetch user profile
    getUserDetails(token)
      .then((data) => {
        setUser(data);
        setEditForm(data);
        if (data.city) {
          setCity(data.city);
          setCityInput(data.city);
        }
      })
      .catch(() => setUser({ name: "User Name", email: "user@example.com" }));
  }, [navigate]);

  useEffect(() => {
    if (!city) return;
    setLoading(true);
    // Fetch clinics based on city
    fetchClinics(city)
      .then(setClinics)
      .catch(() => setClinics([]))
      .finally(() => setLoading(false));
  }, [city]);

  const handleCitySubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (cityInput.trim()) {
      setCity(cityInput.trim());
    }
  };

  const handleDetectLocation = () => {
    setDetectingLocation(true);
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        async (pos) => {
          const { latitude, longitude } = pos.coords;
          // Use a geocoding API to get city from lat/lng
          try {
            const res = await fetch(
              `https://nominatim.openstreetmap.org/reverse?format=json&lat=${latitude}&lon=${longitude}`
            );
            const data = await res.json();
            const detectedCity = data.address.city || data.address.town || data.address.village || "";
            setCityInput(detectedCity);
            setCity(detectedCity);
          } catch {
            setError("Could not detect city from location.");
          }
          setDetectingLocation(false);
        },
        () => {
          setError("Location access denied.");
          setDetectingLocation(false);
        }
      );
    } else {
      setError("Geolocation not supported.");
      setDetectingLocation(false);
    }
  };

  const handleEditProfile = () => {
    setEditDialogOpen(true);
  };

  const handleSaveProfile = async () => {
    const token = getToken();
    if (!token) return;
    
    setUpdating(true);
    try {
      const updatedUser = await updateUserDetails(token, editForm);
      setUser(updatedUser);
      setEditDialogOpen(false);
      if (updatedUser.city && updatedUser.city !== city) {
        setCity(updatedUser.city);
        setCityInput(updatedUser.city);
      }
    } catch (err) {
      setError("Failed to update profile");
    } finally {
      setUpdating(false);
    }
  };

  const handleLogout = () => {
    clearToken();
    navigate("/login");
  };

  return (
    <div className="profile-gradient">
      <NavBar />
      <div className="profile-container">
        <Paper className="profile-card">
          <Typography variant="h6">{user?.name || "-"}</Typography>
          <Typography color="text.secondary">{user?.email || "-"}</Typography>
          {user?.phone && <Typography color="text.secondary">📞 {user.phone}</Typography>}
          {user?.address && <Typography color="text.secondary">📍 {user.address}</Typography>}
          {user?.age && <Typography color="text.secondary">👤 {user.age} years old</Typography>}
          <Button variant="outlined" size="small" sx={{ mt: 1 }} onClick={handleEditProfile}>
            Edit Profile
          </Button>
        </Paper>
        <form onSubmit={handleCitySubmit} style={{ marginBottom: 16 }}>
          <TextField
            label="Enter your city"
            value={cityInput}
            onChange={(e) => setCityInput(e.target.value)}
            fullWidth
            variant="outlined"
            sx={{ mb: 1 }}
          />
          <Button type="submit" variant="contained" fullWidth sx={{ mb: 1 }}>
            Find Clinics
          </Button>
          <Button
            variant="outlined"
            fullWidth
            onClick={handleDetectLocation}
            disabled={detectingLocation}
          >
            {detectingLocation ? "Detecting..." : "Detect My Location"}
          </Button>
        </form>
        {city && (
          <Typography variant="subtitle1" color="primary" sx={{ mb: 1 }}>
            Showing clinics for <b>{city}</b>
          </Typography>
        )}
        <Typography variant="h6" mb={1} color="primary">
          Nearby Clinics
        </Typography>
        {loading ? (
          <div>Loading clinics...</div>
        ) : clinics.length === 0 ? (
          <div>No clinics found.</div>
        ) : (
          <List>
            {clinics.map((c: any, i: number) => {
              const contact = c.contact || {};
              const phone = contact.phone || "";
              const website = contact.website || "";
              const email = contact.email || "";
              const [modalOpen, setModalOpen] = useState(false);
              return (
                <ListItem key={i} className="clinic-tile">
                  <ListItemText
                    primary={c.name || c.clinic_name}
                    secondary={
                      <>
                        {`Rating: ${c.rating || "N/A"}`}
                        <br />
                        {c.address && <span>{c.address}<br /></span>}
                        <div style={{ marginTop: 8 }}>
                          {phone && (
                            <span style={{ display: 'inline-block', marginRight: 12 }}>
                              <b>📞 Phone:</b> <a href={`tel:${phone}`}>{phone}</a>
                            </span>
                          )}
                          {email && (
                            <span style={{ display: 'inline-block', marginRight: 12 }}>
                              <b>✉️ Email:</b> <a href={`mailto:${email}`}>{email}</a>
                            </span>
                          )}
                          {website && (
                            <span style={{ display: 'inline-block', marginRight: 12 }}>
                              <b>🌐 Website:</b> <a href={website.startsWith('http') ? website : `https://${website}`} target="_blank" rel="noopener noreferrer">{website}</a>
                            </span>
                          )}
                        </div>
                      </>
                    }
                  />
                  {(phone || email || website) && (
                    <Button variant="contained" onClick={() => setModalOpen(true)}>
                      Contact
                    </Button>
                  )}
                  {modalOpen && (
                    <Dialog open={modalOpen} onClose={() => setModalOpen(false)}>
                      <DialogTitle>Contact Options</DialogTitle>
                      <DialogContent>
                        {phone && (
                          <Button fullWidth sx={{ mb: 1 }} variant="outlined" onClick={() => { window.open(`tel:${phone}`); setModalOpen(false); }}>
                            📞 Call {phone}
                          </Button>
                        )}
                        {email && (
                          <Button fullWidth sx={{ mb: 1 }} variant="outlined" onClick={() => { window.open(`mailto:${email}`); setModalOpen(false); }}>
                            ✉️ Email {email}
                          </Button>
                        )}
                        {website && (
                          <Button fullWidth sx={{ mb: 1 }} variant="outlined" onClick={() => { window.open(website.startsWith('http') ? website : `https://${website}`); setModalOpen(false); }}>
                            🌐 Visit Website
                          </Button>
                        )}
                      </DialogContent>
                      <DialogActions>
                        <Button onClick={() => setModalOpen(false)}>Close</Button>
                      </DialogActions>
                    </Dialog>
                  )}
                </ListItem>
              );
            })}
          </List>
        )}
        <Button variant="outlined" fullWidth sx={{ mt: 2 }}>
          Connect with a Doctor
        </Button>
        <Button
          variant="contained"
          color="error"
          fullWidth
          sx={{ mt: 2 }}
          onClick={handleLogout}
        >
          Logout
        </Button>
        {error && <Typography color="error" sx={{ mt: 2 }}>{error}</Typography>}
      </div>

      {/* Edit Profile Dialog */}
      <Dialog open={editDialogOpen} onClose={() => setEditDialogOpen(false)} maxWidth="sm" fullWidth>
        <DialogTitle>Edit Profile</DialogTitle>
        <DialogContent>
          <TextField
            label="Name"
            value={editForm.name || ""}
            onChange={(e) => setEditForm({ ...editForm, name: e.target.value })}
            fullWidth
            margin="normal"
          />
          <TextField
            label="Phone"
            value={editForm.phone || ""}
            onChange={(e) => setEditForm({ ...editForm, phone: e.target.value })}
            fullWidth
            margin="normal"
          />
          <TextField
            label="Address"
            value={editForm.address || ""}
            onChange={(e) => setEditForm({ ...editForm, address: e.target.value })}
            fullWidth
            margin="normal"
            multiline
            rows={2}
          />
          <TextField
            label="City"
            value={editForm.city || ""}
            onChange={(e) => setEditForm({ ...editForm, city: e.target.value })}
            fullWidth
            margin="normal"
          />
          <TextField
            label="Age"
            type="number"
            value={editForm.age || ""}
            onChange={(e) => setEditForm({ ...editForm, age: parseInt(e.target.value) || undefined })}
            fullWidth
            margin="normal"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setEditDialogOpen(false)}>Cancel</Button>
          <Button onClick={handleSaveProfile} disabled={updating} variant="contained">
            {updating ? "Saving..." : "Save"}
          </Button>
        </DialogActions>
      </Dialog>
    </div>
  );
};

export default Profile;
