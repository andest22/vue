import axios from 'axios';

const TYPE_QUOTES_API_URL = 'http://localhost:5000/api/type-quotes';

const getAuthHeaders = () => {
  const token = localStorage.getItem('token');
  return {
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`
    }
  };
};

// Crear relación entre cita, servicios y barbero
export const insertTypeOfQuotes = async (typeQuoteData) => {
  try {
    const response = await axios.post(TYPE_QUOTES_API_URL, typeQuoteData, getAuthHeaders());
    return response.data;
  } catch (error) {
    console.error('Error en insertTypeOfQuotes:', error.response?.data || error.message);
    throw error;
  }
};
