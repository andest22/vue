// routes/typeOfQuotesRoutes.js
const express = require('express');
const router = express.Router();
const typeOfQuotesController = require('../controllers/typeOfQuotesController');

// 🔒 Insertar relación entre cita, servicio y barbero (requiere token si quieres)
router.post('/', typeOfQuotesController.insertTypeOfQuotes);

module.exports = router;
