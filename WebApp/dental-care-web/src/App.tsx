import React from "react";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import Home from "./pages/Home";
import Login from "./pages/Login";
import Signup from "./pages/Signup";
import Profile from "./pages/Profile";
import Result from "./pages/Result";
import Chatbot from "./pages/Chatbot";
import UploadNormal from "./pages/UploadNormal";
import UploadXray from "./pages/UploadXray";
import Articles from "./pages/Articles";

const App: React.FC = () => (
  <Router>
    <Routes>
      <Route path="/" element={<Home />} />
      <Route path="/login" element={<Login />} />
      <Route path="/signup" element={<Signup />} />
      <Route path="/profile" element={<Profile />} />
      <Route path="/result" element={<Result />} />
      <Route path="/chatbot" element={<Chatbot />} />
      <Route path="/upload-normal" element={<UploadNormal />} />
      <Route path="/upload-xray" element={<UploadXray />} />
      <Route path="/articles" element={<Articles />} />
      <Route path="*" element={<Navigate to="/" />} />
    </Routes>
  </Router>
);

export default App;
