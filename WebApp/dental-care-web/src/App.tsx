import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Signup from "./pages/Signup";
import Home from "./pages/Home";
import UploadNormal from "./pages/UploadNormal";
import UploadXray from "./pages/UploadXray";
import Result from "./pages/Result";
import Chatbot from "./pages/Chatbot";
import Profile from "./pages/Profile";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route path="/signup" element={<Signup />} />
        <Route path="/home" element={<Home />} />
        <Route path="/upload-normal" element={<UploadNormal />} />
        <Route path="/upload-xray" element={<UploadXray />} />
        <Route path="/result" element={<Result />} />
        <Route path="/chatbot" element={<Chatbot />} />
        <Route path="/profile" element={<Profile />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
