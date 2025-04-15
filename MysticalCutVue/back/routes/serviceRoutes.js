const express = require('express');
const router = express.Router();
const serviceController = require('../controllers/serviceController');
const authenticateToken = require('../middlewares/authMiddleware');
const upload = require('../middlewares/upload');


// 🔹 Rutas específicas primero (más largas o con texto estático)

// Obtener servicios inactivos
router.get('/inactive', authenticateToken, serviceController.getInactiveServices);

// Activar un servicio
router.put('/activate/:id', authenticateToken, serviceController.activateService);

// 🔹 Luego las rutas estándar

// Obtener todos los servicios activos
router.get('/', authenticateToken, serviceController.getAllServices);

// Obtener un servicio por ID
router.get('/:id', authenticateToken, serviceController.getServiceById);

// Crear un nuevo servicio
router.post('/', authenticateToken, upload.single('image'), serviceController.createService);

// Actualizar un servicio
router.put('/:id', authenticateToken, upload.single('image'), serviceController.updateService);

// Eliminar un servicio (cambiar estado a inactivo)
router.delete('/:id', authenticateToken, serviceController.deleteService);

module.exports = router;
