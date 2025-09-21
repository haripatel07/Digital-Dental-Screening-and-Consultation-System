import { formatConfidence, formatDate } from '../utils/formatters';

describe('formatConfidence', () => {
  it('should format confidence as percentage', () => {
    expect(formatConfidence(0.8765)).toBe('87.65%');
  });
});

describe('formatDate', () => {
  it('should format date string', () => {
    expect(formatDate('2025-09-20')).toMatch(/\d{1,2}\/\d{1,2}\/\d{4}/);
  });
});
