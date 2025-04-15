// controllers/quotesController.js
const db = require('../config/db');

// 🔹 Crear una nueva cita
exports.createQuote = (req, res) => {
  const { user_id, barber_id, date_time, end_time, state_quotes } = req.body;

  // Log completo para depurar los datos recibidos
  console.log('🟢 Datos recibidos en createQuote:', {
    user_id,
    barber_id,
    date_time,
    end_time,
    state_quotes,
  });

  // Validación de TODOS los campos
  if (!user_id || !barber_id || !date_time || !end_time || !state_quotes) {
    console.warn('⚠️ Faltan datos requeridos:', {
      user_id,
      barber_id,
      date_time,
      end_time,
      state_quotes,
    });
    return res.status(400).json({ message: 'Faltan datos requeridos' });
  }

  const query = `
    INSERT INTO quotes (user_id, barber_id, date_time, end_time, state_quotes)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(query, [user_id, barber_id, date_time, end_time, state_quotes], (err, result) => {
    if (err) {
      console.error('🔴 Error al guardar la cita en DB:', err);
      return res.status(500).json({ message: 'Error al guardar la cita' });
    }

    console.log('✅ Cita guardada con ID:', result.insertId);
    res.status(201).json({ message: 'Cita creada correctamente', id: result.insertId });
  });
};

// 🔹 Obtener citas por barbero, año y mes
exports.getQuotesByBarberAndMonth = (req, res) => {
  const { barber_id, year, month } = req.query;

  if (!barber_id || !year || !month) {
    return res.status(400).json({ message: 'Faltan parámetros: barber_id, year o month' });
  }

  const query = `
    SELECT id_quotes, date_time, end_time
    FROM quotes
    WHERE barber_id = ?
      AND YEAR(date_time) = ?
      AND MONTH(date_time) = ?
  `;

  db.query(query, [barber_id, year, month], (err, results) => {
    if (err) {
      console.error('🔴 Error al obtener citas:', err);
      return res.status(500).json({ message: 'Error al obtener citas' });
    }

    const citas = results.map(cita => ({
      id: cita.id_quotes,
      date_time: cita.date_time,
      end_time: cita.end_time,
      duration: (new Date(cita.end_time) - new Date(cita.date_time)) / 60000 // minutos
    }));

    res.status(200).json(citas);
  });
};
