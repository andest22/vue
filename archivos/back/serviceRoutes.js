const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const authenticateToken = require('../middlewares/authMiddleware'); // Asumiendo que tienes un middleware de autenticación

// Obtener todos los servicios activos
router.get('/service', authenticateToken, serviceController.getAllServices);

// Obtener un servicio por ID
router.get('/service/:id', authenticateToken, serviceController.getServiceById);

// Crear un nuevo servicio
router.post('/create', authenticateToken, serviceController.createService);

// Actualizar un servicio
router.put('/services/:id', authenticateToken, serviceController.updateService);

// Eliminar un servicio (cambiar estado a inactivo)
router.delete('/service/:id', authenticateToken, serviceController.deleteService);

module.exports = router;


