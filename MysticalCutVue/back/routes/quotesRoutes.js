const express = require('express');
const router = express.Router();
const quotesController = require('../controllers/quotesController');
const authenticateToken = require('../middlewares/authMiddleware');

// 🔒 Crear una nueva cita (requiere token)
router.post('/', authenticateToken, quotesController.createQuote);

// 🔓 Obtener citas por barbero, año y mes (NO requiere token)
router.get('/mes', quotesController.getQuotesByBarberAndMonth);

// 🔒 Obtener citas con detalle de servicios por usuario (requiere token)
router.get('/detalles', authenticateToken, quotesController.getQuotesWithServiceDetails);

// Ruta para cancelar cita
router.put('/cancel/:id', quotesController.cancelQuote);

// Ruta para finalizar una cita
router.put('/finish/:id', quotesController.finishQuote);

module.exports = router;
