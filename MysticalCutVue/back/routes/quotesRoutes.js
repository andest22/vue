const express = require('express');
const router = express.Router();
const quotesController = require('../controllers/quotesController');
const authenticateToken = require('../middlewares/authMiddleware');

// 🔒 Crear una nueva cita (requiere token)
router.post('/', authenticateToken, quotesController.createQuote);

// 🔓 Obtener citas por barbero, año y mes (NO requiere token)
router.get('/mes', quotesController.getQuotesByBarberAndMonth);

module.exports = router;
