<template>
  <div class="container">
    <header class="custom-header">
      <img src="/assets/img/LOGO.png" alt="Logo" class="logo" />
      <h1>Seleccionar Fecha y Hora</h1>
    </header>

    <div class="main-content">
      <div class="left-column">
        <div class="profile">
          <div class="profile-pic"></div>
          <span>{{ barberName }}</span>
        </div>

        <div class="calendar">
          <div class="calendar-header">
            <button @click="prevMonth">←</button>
            <span>{{ monthNames[currentMonth] }} {{ currentYear }}</span>
            <button @click="nextMonth">→</button>
          </div>
          <div class="calendar-grid">
            <div class="day-label" v-for="day in daysOfWeek" :key="day">{{ day }}</div>
            <div
              class="calendar-day"
              v-for="calendarDate in calendarDays"
              :key="formatDate(calendarDate)"
              :class="{
                selected: selectedDate === formatDate(calendarDate),
                empty: calendarDate === null,
                disabled: isPastDate(calendarDate)
              }"
              @click="calendarDate && !isPastDate(calendarDate) && selectDate(calendarDate)"
            >
              {{ calendarDate ? new Date(calendarDate).getDate() : '' }}
            </div>
          </div>
        </div>

        <div class="time-list">
          <button
            v-for="time in availableTimes"
            :key="time"
            @click="selectTime(time)"
            :class="['time-button', { selected: selectedTime === formatTimeTo24H(time) }]"
          >
            {{ time }}
          </button>
        </div>
      </div>

      <div class="right-column">
        <div class="service-summary">
          <h3>MysticalCut</h3>
          <p v-if="selectedDate">Fecha: {{ selectedDate }}</p>
          <p v-if="selectedTime">Hora: {{ selectedTime }}</p>

          <div v-if="selectedServices.length">
            <p><strong>Servicio:</strong></p>
            <ul>
              <li>
                {{ selectedServices[0].name_service }} - ${{ selectedServices[0].price }}
              </li>
            </ul>
          </div>

          <button
            v-if="selectedDate && selectedTime"
            class="confirm-button"
            @click="confirmQuote"
          >
            Confirmar Cita
          </button>
          <button class="back-button1" @click="regresar">Regresar</button>
        </div>
      </div>
    </div>

    <footer>
      <p>© 2024 www.mysticalcut.com, Inc</p>
    </footer>
  </div>
</template>

<script>
import { createQuote } from '@/services/quotesApi';

export default {
  name: 'CalendarioCitas',
  data() {
    return {
      selectedDate: '',
      selectedTime: '',
      barberId: null,
      barberName: '',
      userId: null,
      selectedServices: [],
      availableTimes: [
        '8:00 a.m.', '9:00 a.m.', '10:00 a.m.', '11:00 a.m.',
        '12:00 p.m.', '1:00 p.m.', '2:00 p.m.', '3:00 p.m.',
        '4:00 p.m.', '5:00 p.m.'
      ],
      daysOfWeek: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'],
      monthNames: [
        'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
        'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
      ],
      currentYear: new Date().getFullYear(),
      currentMonth: new Date().getMonth(),
    };
  },

  computed: {
    calendarDays() {
      const days = [];
      const firstDay = new Date(this.currentYear, this.currentMonth, 1);
      const lastDay = new Date(this.currentYear, this.currentMonth + 1, 0);
      const totalDays = lastDay.getDate();
      const startWeekday = (firstDay.getDay() + 6) % 7;

      for (let i = 0; i < startWeekday; i++) days.push(null);
      for (let i = 1; i <= totalDays; i++) {
        days.push(new Date(this.currentYear, this.currentMonth, i));
      }
      return days;
    }
  },

  methods: {
    formatDate(date) {
      return date ? date.toISOString().split('T')[0] : '';
    },

    isPastDate(date) {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      return date && date < today;
    },

    formatTimeTo24H(time12h) {
      const [time, modifier] = time12h.split(' ');
      let [hours, minutes] = time.split(':');
      if (modifier === 'p.m.' && hours !== '12') hours = parseInt(hours) + 12;
      if (modifier === 'a.m.' && hours === '12') hours = '00';
      return `${hours.toString().padStart(2, '0')}:${minutes}`;
    },

    selectDate(date) {
      this.selectedDate = this.formatDate(date);
    },

    selectTime(time) {
      this.selectedTime = this.formatTimeTo24H(time);
    },

    nextMonth() {
      if (this.currentMonth === 11) {
        this.currentMonth = 0;
        this.currentYear++;
      } else {
        this.currentMonth++;
      }
    },

    prevMonth() {
      const now = new Date();
      if (
        this.currentMonth === 0 && this.currentYear === now.getFullYear() ||
        new Date(this.currentYear, this.currentMonth - 1) < new Date(now.getFullYear(), now.getMonth())
      ) return;

      if (this.currentMonth === 0) {
        this.currentMonth = 11;
        this.currentYear--;
      } else {
        this.currentMonth--;
      }
    },

    // Función para convertir el tiempo en formato hh:mm:ss a minutos
    convertTimeToMinutes(time) {
      const [hours, minutes] = time.split(':').map(Number);
      return (hours * 60) + minutes;
    },

    async confirmQuote() {
      if (!this.selectedDate || !this.selectedTime) {
        alert('Por favor selecciona fecha y hora.');
        return;
      }

      if (!this.selectedServices.length || this.selectedServices.length !== 1) {
        alert('Debes seleccionar un único servicio para la cita.');
        return;
      }

      // Aseguramos que la fecha y hora seleccionadas sean válidas
      const dateTimeStr = `${this.selectedDate}T${this.selectedTime}:00`;
      const dateTime = new Date(dateTimeStr);

      // Verificamos que la fecha seleccionada sea válida
      console.log("Fecha y hora de inicio:", dateTimeStr);
      console.log("Objeto Date de inicio:", dateTime);

      if (isNaN(dateTime.getTime())) {
        alert('La fecha y hora seleccionadas no son válidas. Por favor, verifica los datos.');
        return;
      }

      const estimatedTime = this.selectedServices[0].estimated_time || '00:30:00'; // en formato hh:mm:ss
      console.log("Tiempo estimado del servicio:", estimatedTime); // Verificación del tiempo estimado

      // Convertimos el tiempo estimado a minutos
      const estimatedTimeInMinutes = this.convertTimeToMinutes(estimatedTime);
      console.log("Tiempo estimado en minutos:", estimatedTimeInMinutes);

      // Calculamos la hora de finalización sumando los minutos al tiempo de inicio
      const endTime = new Date(dateTime);
      console.log("Fecha de inicio antes de agregar minutos:", endTime);
      endTime.setMinutes(endTime.getMinutes() + estimatedTimeInMinutes);  // Sumamos el tiempo estimado en minutos

      // Verificamos que la hora de finalización sea válida
      console.log("Hora de finalización calculada:", endTime);

      if (isNaN(endTime.getTime())) {
        alert('La hora de finalización calculada no es válida. Intenta nuevamente.');
        return;
      }

      // Validamos que la hora de finalización sea posterior a la hora de inicio
      if (endTime <= dateTime) {
        alert('La hora de finalización no puede ser antes de la hora de inicio.');
        return;
      }

      const data = {
        user_id: this.userId,
        barber_id: this.barberId,
        date_time: dateTime.toISOString(), // formato ISO
        end_time: endTime.toISOString(),   // formato ISO
        state_quotes: 'pendiente',
        id_services: this.selectedServices[0].id_services
      };

      // Verificamos los datos que se están enviando
      console.log("Datos de la cita que se van a enviar:", data);

      try {
        await createQuote(data);
        const serviciosStr = encodeURIComponent(JSON.stringify(this.selectedServices));
        this.$router.push({
          path: '/FacturaServicios',
          query: {
            user_id: this.userId,
            barber_id: this.barberId,
            barber_name: this.barberName,
            date: this.selectedDate,
            time: this.selectedTime,
            servicios: serviciosStr,
            id_services: this.selectedServices[0].id_services
          }
        });
      } catch (error) {
        console.error('Error al crear la cita:', error);
        alert('Error al crear la cita');
      }
    },

    regresar() {
      this.$router.go(-1);
    }
  },

  mounted() {
    const query = this.$route.query;
    this.userId = parseInt(query.user_id);
    this.barberId = parseInt(query.barber_id);
    this.barberName = query.barber_name || '';

    if (query.servicios) {
      try {
        const decodedServicios = decodeURIComponent(query.servicios);
        this.selectedServices = JSON.parse(decodedServicios);
      } catch (e) {
        console.error('Error al parsear servicios:', e);
      }
    }

    if (!this.userId || !this.barberId) {
      alert('Faltan datos del barbero o usuario.');
      this.$router.push('/');
    }
  }
};
</script>









<style scoped>
body, .container {
  background-color: #000;
  color: #fff;
  font-family: 'Georgia', serif;
}

.custom-header {
  display: flex;
  align-items: center;
  justify-content: center;
  border-bottom: 1px solid #666;
  padding: 10px 0;
  position: relative;
}

.logo {
  width: 90px;
  height: auto;
  position: absolute;
  left: 20px;
}

h1 {
  font-size: 28px;
  color: #fff;
}

.main-content {
  display: flex;
  flex-wrap: wrap;
  padding: 20px;
}

.left-column {
  flex: 2;
  margin-right: 20px;
  min-width: 300px;
}

.right-column {
  flex: 1;
  border: 1px solid #ccc;
  padding: 20px;
  background-color: #222;
}

.calendar-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
}

.calendar-grid {
  display: grid;
  grid-template-columns: repeat(7, 1fr);
  gap: 10px;
}

.calendar-day {
  padding: 10px;
  text-align: center;
  cursor: pointer;
  border-radius: 5px;
  transition: background-color 0.3s ease;
}

.calendar-day:hover {
  background-color: #444;
}

.selected {
  background-color: #f5c30f;
}

.empty {
  background-color: transparent;
}

.disabled {
  background-color: #666;
  pointer-events: none;
}

.time-list {
  margin-top: 20px;
}

.time-button {
  padding: 10px;
  background-color: #444;
  border: none;
  margin: 5px 0;
  cursor: pointer;
  width: 100%;
}

.time-button.selected {
  background-color: #f5c30f;
}

.confirm-button, .back-button1 {
  margin-top: 20px;
  width: 100%;
  padding: 10px;
  background-color: #f5c30f;
  color: #000;
  border: none;
  cursor: pointer;
}

.back-button1 {
  background-color: #ccc;
}
</style>
