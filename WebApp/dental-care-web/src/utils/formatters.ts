// Utility functions for formatting

export const formatConfidence = (confidence: number): string => {
  return `${(confidence).toFixed(2)}%`;
};

export const formatDate = (dateStr: string): string => {
  const date = new Date(dateStr);
  return date.toLocaleDateString();
};
