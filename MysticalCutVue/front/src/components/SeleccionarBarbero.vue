<template>
  <div class="container">
    <header class="d-flex flex-wrap align-items-center justify-content-between py-3 mb-4 border-bottom">
      <div class="col-md-3 mb-2 mb-md-0">
        <img src="/assets/img/LOGO.png" alt="Logo" width="125" height="125" />
      </div>
      <div>
        <h1 class="text-center">Elegir Barbero</h1>
        <p v-if="currentUser" class="text-center text-muted">
          Bienvenido, <strong>{{ currentUser.name }}</strong>
        </p>
      </div>
    </header>

    <div class="row">
      <div class="col-md-8">
        <h2>Barbero</h2>
        <div class="row">
          <div
            class="col-md-4 mb-3"
            v-for="barber in barbers"
            :key="barber.id"
          >
            <div
              class="barber-card"
              :class="{ selected: selectedBarber && selectedBarber.id === barber.id }"
              @click="selectBarber(barber)"
            >
              <img
                :src="getImageUrl(barber.image)"
                :alt="barber.full_name"
                class="barber-img"
              />
              <h4>{{ barber.full_name }}</h4>
              <button class="select-barber">+</button>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-4">
        <div class="custom-card">
          <h3>Resumen</h3>
          <div v-if="selectedBarber">
            <h5 class="text-success">{{ selectedBarber.full_name }}</h5>
          </div>
          <div v-else>
            <h5 class="text-muted">Selecciona un barbero</h5>
          </div>

          <div v-if="selectedServices.length">
            <p><strong>Servicios:</strong></p>
            <ul>
              <li v-for="(servicio, index) in selectedServices" :key="index">
                {{ servicio.name_service }} - ${{ servicio.price }}
              </li>
            </ul>
          </div>

          <button class="btn btn-danger mt-2" @click="clearSelection">Eliminar selección</button>
          <button class="btn btn-success mt-2" @click="goToCalendar">Continuar</button>
          <br />
          <button class="back-button1 mt-3" @click="goBack">Regresar</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getBarbers } from '@/services/api';

export default {
  name: 'SeleccionarBarbero',
  data() {
    return {
      barbers: [],
      selectedBarber: null,
      selectedServices: [],
      currentUser: null,
    };
  },
  methods: {
    async fetchBarbers() {
      try {
        this.barbers = await getBarbers();
      } catch (error) {
        console.error('Error al obtener barberos:', error);
      }
    },
    getImageUrl(imageName) {
      if (!imageName) return '/assets/img/default-barber.jpg';
      return `http://localhost:5000/uploads/${imageName}`;
    },
    selectBarber(barber) {
      this.selectedBarber = barber;
    },
    clearSelection() {
      this.selectedBarber = null;
    },
    goToCalendar() {
      if (!this.selectedBarber) {
        alert("Selecciona un barbero.");
        return;
      }

      if (!this.selectedServices.length) {
        alert("No hay servicios seleccionados.");
        return;
      }

      if (!this.currentUser || !this.currentUser.id) {
        alert("Información del usuario no disponible.");
        return;
      }

      if (!this.selectedBarber.user_id) {
        alert("Este barbero no tiene un user_id asignado.");
        return;
      }

      this.$router.push({
        path: '/Calendario',
        query: {
          barber_id: this.selectedBarber.user_id, // ✅ Aquí va el user_id
          barber_name: this.selectedBarber.full_name,
          servicios: JSON.stringify(this.selectedServices),
          user_id: this.currentUser.id,
          user_name: this.currentUser.name,
        },
      });
    },
    goBack() {
      this.$router.push("/ElegirServicio");
    },
  },
  mounted() {
    const { user_id, user_name, servicios } = this.$route.query;

    // Guardar datos del usuario actual
    if (user_id && user_name) {
      this.currentUser = {
        id: parseInt(user_id),
        name: user_name,
      };
    } else {
      alert("No se recibió la información del usuario correctamente.");
    }

    // Guardar servicios seleccionados
    if (servicios) {
      try {
        this.selectedServices = JSON.parse(servicios);
      } catch (error) {
        console.error("Error al parsear los servicios:", error);
      }
    }

    this.fetchBarbers();
  },
};
</script>

<style scoped>
.barber-card {
  text-align: center;
  border: 1px solid #ddd;
  padding: 20px;
  border-radius: 5px;
  cursor: pointer;
  transition: 0.3s;
}
.barber-card:hover {
  background-color: #f8f8f8;
}
.selected {
  border: 2px solid green;
  background-color: #e6ffe6;
}
.barber-img {
  width: 100%;
  max-height: 200px;
  object-fit: cover;
  margin-bottom: 10px;
}
.select-barber {
  background-color: green;
  color: white;
  padding: 10px;
  border-radius: 5px;
  cursor: pointer;
  border: none;
  transition: background-color 0.3s;
}
.select-barber:hover {
  background-color: darkgreen;
}
.custom-card {
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 5px;
}
.back-button1 {
  padding: 10px;
  margin-top: 20px;
  background-color: #007bff;
  color: white;
  border: none;
  cursor: pointer;
}
.back-button1:hover {
  background-color: #0056b3;
}
</style>
