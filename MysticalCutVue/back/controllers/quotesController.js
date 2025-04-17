// controllers/quotesController.js
const db = require('../config/db');

// 🔹 Crear una nueva cita
exports.createQuote = (req, res) => {
  const { user_id, barber_id, date_time, end_time, state_quotes, id_services } = req.body;

  // Log completo para depurar los datos recibidos
  console.log('🟢 Datos recibidos en createQuote:', {
    user_id,
    barber_id,
    date_time,
    end_time,
    state_quotes,
    id_services,
  });

  // Validación de TODOS los campos
  if (!user_id || !barber_id || !date_time || !end_time || !state_quotes || !id_services) {
    console.warn('⚠️ Faltan datos requeridos:', {
      user_id,
      barber_id,
      date_time,
      end_time,
      state_quotes,
      id_services,
    });
    return res.status(400).json({ message: 'Faltan datos requeridos' });
  }

  const query = `
    INSERT INTO quotes (user_id, barber_id, date_time, end_time, state_quotes, id_services)
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(query, [user_id, barber_id, date_time, end_time, state_quotes, id_services], (err, result) => {
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


// 🔹 Obtener citas con detalle de servicio por usuario o barbero
exports.getQuotesWithServiceDetails = (req, res) => {
  const { user_id, barber_id } = req.query;

  if (!user_id && !barber_id) {
    return res.status(400).json({ message: 'Falta el parámetro user_id o barber_id' });
  }

  // Si se pasa el user_id, obtenemos las citas para ese usuario.
  // Si se pasa el barber_id, obtenemos las citas donde el barbero está asignado.
  const query = `
    SELECT 
      q.id_quotes,
      q.date_time,
      q.state_quotes,
      s.id_services,
      s.name_service,
      s.price,
      s.estimated_time,
      q.barber_id,
      u.full_name AS barber_name
    FROM quotes q
    JOIN services s ON q.id_services = s.id_services
    LEFT JOIN user u ON q.barber_id = u.user_id
    WHERE (q.user_id = ? OR q.barber_id = ?)
    ORDER BY q.date_time DESC
  `;

  db.query(query, [user_id || barber_id, barber_id || user_id], (err, results) => {
    if (err) {
      console.error('🔴 Error al obtener citas con detalles de servicio:', err);
      return res.status(500).json({ message: 'Error al obtener citas' });
    }

    console.log('📦 Resultados de citas con detalles:', results);
    res.status(200).json(results);
  });
};



// Función para cancelar una cita
exports.cancelQuote = (req, res) => {
  const quoteId = req.params.id;  // Asumiendo que el ID de la cita llega como parámetro en la URL

  // Query para actualizar el estado de la cita a 'cancelada'
  const query = 'UPDATE quotes SET state_quotes = ? WHERE id_quotes = ?';
  
  db.query(query, ['cancelada', quoteId], (err, result) => {
    if (err) {
      console.error("Error al cancelar cita:", err);
      return res.status(500).json({ message: 'Error al cancelar la cita.' });
    }
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: 'Cita no encontrada.' });
    }
    res.status(200).json({ message: 'Cita cancelada con éxito.' });
  });
};



