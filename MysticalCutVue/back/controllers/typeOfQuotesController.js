// controllers/typeOfQuotesController.js
const db = require('../config/db');

exports.insertTypeOfQuotes = async (req, res) => {
  const { id_quote, id_services, barber_id } = req.body;

  if (!id_quote || !id_services || !barber_id) {
    return res.status(400).json({ message: 'Faltan datos requeridos' });
  }

  try {
    // Si se pasan múltiples servicios
    if (Array.isArray(id_services)) {
      const values = id_services.map(serviceId => [id_quote, serviceId, barber_id]);
      await db.query('INSERT INTO type_of_quotes (id_quotes, id_services, barber_id) VALUES ?', [values]);
    } else {
      // Si se pasa un solo servicio
      await db.query('INSERT INTO type_of_quotes (id_quotes, id_services, barber_id) VALUES (?, ?, ?)', [id_quote, id_services, barber_id]);
    }

    res.status(201).json({ message: 'Relación creada en type_of_quotes' });
  } catch (error) {
    console.error('Error al insertar en type_of_quotes:', error);
    res.status(500).json({ message: 'Error del servidor' });
  }
};
