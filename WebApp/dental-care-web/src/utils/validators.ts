// Utility functions for validation

export const validateEmail = (email: string): boolean => {
  return /^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$/.test(email);
};

export const validatePassword = (password: string): boolean => {
  return password.length >= 6;
};
