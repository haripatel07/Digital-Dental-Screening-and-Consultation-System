const TOKEN_KEY = 'auth_token';


// Accepts the login response and stores user_id as token
export const saveToken = (loginResponse: any) => {
  // If loginResponse is an object, extract user_id
  let token = loginResponse;
  if (loginResponse && typeof loginResponse === 'object') {
    token = loginResponse.token || loginResponse.user?.id || '';
  }
  localStorage.setItem(TOKEN_KEY, token);
};

export const getToken = (): string | null => {
  return localStorage.getItem(TOKEN_KEY);
};

export const clearToken = () => {
  localStorage.removeItem(TOKEN_KEY);
};
