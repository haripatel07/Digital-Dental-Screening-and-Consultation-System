import { validateEmail, validatePassword } from '../utils/validators';

describe('validateEmail', () => {
  it('should validate correct email', () => {
    expect(validateEmail('test@example.com')).toBe(true);
  });
  it('should invalidate incorrect email', () => {
    expect(validateEmail('test@com')).toBe(false);
  });
});

describe('validatePassword', () => {
  it('should validate password length >= 6', () => {
    expect(validatePassword('123456')).toBe(true);
  });
  it('should invalidate short password', () => {
    expect(validatePassword('123')).toBe(false);
  });
});
