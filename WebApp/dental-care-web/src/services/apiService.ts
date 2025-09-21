import axios from 'axios';

const baseUrl = 'http://127.0.0.1:8001';

export const fetchArticles = async () => {
  const response = await axios.get(`${baseUrl}/content/articles`);
  if (response.status === 200) {
    return response.data.articles || [];
  }
  throw new Error('Failed to fetch articles');
};

export const predictNormal = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  const response = await axios.post(`${baseUrl}/predict/normal`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  if (response.status === 200) {
    // Ensure the result matches the mobile app's expected structure
    if (response.data && typeof response.data === 'object') {
      return {
        disease: response.data.disease || response.data.prediction || '',
        confidence: response.data.confidence || response.data.score || 0,
        recommendation: response.data.recommendation || '',
        imagePath: response.data.imagePath || response.data.image || '',
      };
    }
    return response.data;
  }
  throw new Error('Failed to predict normal image');
};

export const predictXray = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  const response = await axios.post(`${baseUrl}/predict/xray`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' },
  });
  if (response.status === 200) {
    // Ensure the result matches the mobile app's expected structure
    if (response.data && typeof response.data === 'object') {
      return {
        disease: response.data.disease || response.data.prediction || '',
        confidence: response.data.confidence || response.data.score || 0,
        recommendation: response.data.recommendation || '',
        imagePath: response.data.imagePath || response.data.image || '',
      };
    }
    return response.data;
  }
  throw new Error('Failed to predict xray image');
};

export const login = async (email: string, password: string) => {
  const response = await axios.post(`${baseUrl}/auth/login`, { email, password });
  if (response.status === 200) {
    return response.data;
  }
  throw new Error('Login failed');
};

export const signup = async (name: string, email: string, password: string) => {
  const response = await axios.post(`${baseUrl}/auth/signup`, { name, email, password });
  if (response.status === 200) {
    return response.data;
  }
  throw new Error('Signup failed');
};

export const fetchProfile = async (token: string) => {
  const response = await axios.get(`${baseUrl}/auth/user-details`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  if (response.status === 200) {
    return response.data;
  }
  throw new Error('Failed to fetch profile');
};

export const getUserDetails = async (token: string) => {
  const response = await axios.get(`${baseUrl}/auth/user-details`, {
    headers: { Authorization: `Bearer ${token}` }
  });
  if (response.status === 200) {
    return response.data;
  }
  throw new Error('Failed to fetch user details');
};

export const updateUserDetails = async (token: string, details: {
  name?: string;
  phone?: string;
  address?: string;
  city?: string;
  age?: number;
}) => {
  const response = await axios.put(`${baseUrl}/auth/user-details`, details, {
    headers: { Authorization: `Bearer ${token}` }
  });
  if (response.status === 200) {
    return response.data;
  }
  throw new Error('Failed to update user details');
};

export const fetchClinics = async (city?: string) => {
  const url = city ? `${baseUrl}/clinics?location=${encodeURIComponent(city)}` : `${baseUrl}/clinics`;
  const response = await axios.get(url);
  if (response.status === 200) {
    const clinics = response.data.clinics || [];
    // Ensure contact details are always present
    return clinics.map((c: any) => ({
      ...c,
      contact: c.contact || {},
    }));
  }
  throw new Error('Failed to fetch clinics');
};

export const sendChatbotMessage = async (message: string) => {
  const response = await axios.post(`${baseUrl}/chatbot`, { message });
  if (response.status === 200) {
    return response.data.reply;
  }
  throw new Error('Chatbot error');
};
