import React from "react";
import { useLocation, useNavigate } from "react-router-dom";
import type { ResultModel } from "../models/ResultModel";
import "../styles/Result.css";

type ResultTileProps = {
  title: string;
  value: string;
  subtitle?: string;
  multiline?: boolean;
};

const ResultTile: React.FC<ResultTileProps> = ({ title, value, subtitle, multiline }) => (
  <div className="result-tile">
    <div className="result-tile-title">{title}</div>
    <div
      className="result-tile-value"
      style={{ whiteSpace: multiline ? "pre-wrap" : "nowrap" }}
    >
      {value}
    </div>
    {subtitle && <div className="result-tile-subtitle">{subtitle}</div>}
  </div>
);

const Result: React.FC = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const result = location.state as ResultModel | undefined;

  if (!result)
    return (
      <div className="result-gradient">
        <div className="result-header">No result data available.</div>
      </div>
    );

  // For web, always use imagePath (base64 or url)
  const imageSrc = result.imagePath || "";

  return (
    <div className="result-gradient">
      <div className="result-header">
        <div style={{ display: "flex", flexDirection: "column", alignItems: "center" }}>
          <div style={{ fontSize: 44, color: "#008080", marginBottom: 8 }}>
            {result.disease?.toLowerCase().includes("xray") ? (
              <span className="material-icons">medical_services</span>
            ) : (
              <span className="material-icons">camera_alt</span>
            )}
          </div>
          <div style={{ fontSize: 22, fontWeight: 700, color: "#008080", marginBottom: 4 }}>
            {result.disease?.toLowerCase().includes("xray")
              ? "X-ray Analysis Result"
              : "Normal Image Analysis Result"}
          </div>
        </div>
      </div>
      <div className="result-content">
        <div style={{ marginBottom: 24, textAlign: "center" }}>
          <div style={{ fontWeight: 600, fontSize: 18, color: "#008080", marginBottom: 10 }}>
            Image Preview
          </div>
          {imageSrc ? (
            <img
              src={imageSrc}
              alt="Result"
              className="result-image"
              style={{
                borderRadius: 15,
                border: "1px solid #eee",
                width: "100%",
                maxHeight: 300,
                objectFit: "cover",
                boxShadow: "0 2px 12px rgba(0,128,128,0.08)",
              }}
            />
          ) : (
            <div style={{ color: "#888", textAlign: "center", padding: 30 }}>
              No image provided
            </div>
          )}
        </div>
        <div style={{ fontWeight: 600, fontSize: 18, color: "#008080", marginBottom: 10 }}>
          Analysis Details
        </div>
        <ResultTile title="Predicted Condition" value={result.disease || "—"} />
        <div style={{ height: 12 }} />
        <ResultTile
          title="Confidence Score"
          value={
            result.confidence !== undefined
              ? `${(result.confidence).toFixed(1)} %`
              : "—"
          }
          subtitle={
            result.confidence !== undefined
              ? undefined
              : "Confidence score will be shown here."
          }
        />
        <div style={{ height: 12 }} />
        <ResultTile
          title="Dentist Recommendation"
          value={result.recommendation || "—"}
          subtitle={
            result.recommendation
              ? undefined
              : "Care instructions and dentist advice will appear here."
          }
          multiline
        />
        <div style={{ height: 30 }} />
        <button className="result-back-btn" onClick={() => navigate("/")}
        >
          <span className="material-icons" style={{ verticalAlign: "middle", marginRight: 8, color: "#fff" }}>
            home
          </span>
          Back to Home
        </button>
      </div>
    </div>
  );
};

export default Result;
