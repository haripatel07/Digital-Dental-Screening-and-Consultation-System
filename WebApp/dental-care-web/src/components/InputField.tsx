import React from 'react';

interface InputFieldProps {
  label: string;
  value: string;
  onChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  type?: string;
  required?: boolean;
}

const InputField: React.FC<InputFieldProps> = ({ label, value, onChange, type = 'text', required = false }) => (
  <div className="input-field">
    <label>{label}</label>
    <input
      type={type}
      value={value}
      onChange={onChange}
      required={required}
      className="input"
    />
  </div>
);

export default InputField;
