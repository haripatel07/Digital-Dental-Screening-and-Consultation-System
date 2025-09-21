import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { predictXray } from "../services/apiService";
import type { ResultModel } from "../models/ResultModel";
import "../styles/Upload.css";

const UploadXray: React.FC = () => {
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const navigate = useNavigate();

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0] || null;
    setFile(selectedFile);
    if (selectedFile) {
      const reader = new FileReader();
      reader.onloadend = () => setPreview(reader.result as string);
      reader.readAsDataURL(selectedFile);
    } else {
      setPreview(null);
    }
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    if (!file) return;
    setLoading(true);
    setError(null);
    try {
      const result: ResultModel = await predictXray(file);
      // Pass preview as imagePath if backend does not return it
      if (!result.imagePath && preview) result.imagePath = preview;
      navigate("/result", { state: result });
    } catch (err: any) {
      setError(err.message || "Prediction failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="upload-gradient">
      <form className="upload-form" onSubmit={handleSubmit}>
        <h2>Upload X-ray Image</h2>
        <input
          type="file"
          accept="image/*"
          onChange={handleFileChange}
          required
        />
        {preview && (
          <img
            src={preview}
            alt="Preview"
            style={{
              maxWidth: "100%",
              borderRadius: 12,
              marginBottom: 16,
              boxShadow: "0 2px 8px rgba(0,0,0,0.04)",
            }}
          />
        )}
        <button type="submit" disabled={loading || !file}>
          {loading ? "Uploading..." : "Upload & Predict"}
        </button>
        {error && <div className="error">{error}</div>}
      </form>
    </div>
  );
};

export default UploadXray;
