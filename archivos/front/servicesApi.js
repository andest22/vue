import axios from 'axios';

const SERVICE_API_URL = 'http://localhost:5000/api/services';

// Si tu API requiere autenticación, asegúrate de estar enviando el token
const getAuthHeaders = () => ({
  headers: {
    Authorization: `Bearer ${localStorage.getItem('token')}`
  }
});

// Obtener todos los servicios
export const getAllServices = async () => {
  try {
    const response = await axios.get(SERVICE_API_URL, getAuthHeaders());
    return response.data;
  } catch (error) {
    console.error("Error obteniendo servicios:", error);
    throw error;
  }
};

// Obtener servicios por categoría
export const getServicesByCategory = async (categoryId) => {
  try {
    const response = await axios.get(`${SERVICE_API_URL}/category/${categoryId}`, getAuthHeaders());
    return response.data;
  } catch (error) {
    console.error("Error obteniendo servicios por categoría:", error);
    throw error;
  }
};

// Crear un servicio
export const createService = async (serviceData) => {
  const response = await axios.post(SERVICE_API_URL, serviceData, getAuthHeaders());
  return response.data;
};

// Actualizar un servicio
export const updateService = async (id, updatedData) => {
  const response = await axios.put(`${SERVICE_API_URL}/${id}`, updatedData, getAuthHeaders());
  return response.data;
};

// Eliminar un servicio
export const deleteService = async (id) => {
  const response = await axios.delete(`${SERVICE_API_URL}/${id}`, getAuthHeaders());
  return response.data;
};
