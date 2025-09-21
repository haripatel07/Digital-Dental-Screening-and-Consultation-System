import React from 'react';

interface PrimaryButtonProps {
  label: string;
  onClick: () => void;
  disabled?: boolean;
}

const PrimaryButton: React.FC<PrimaryButtonProps> = ({ label, onClick, disabled }) => (
  <button className="primary-btn" onClick={onClick} disabled={disabled}>
    {label}
  </button>
);

export default PrimaryButton;
