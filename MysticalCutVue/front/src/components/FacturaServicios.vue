<template>
    <div class="factura-container">
      <header class="custom-header">
        <img src="/assets/img/LOGO.png" alt="Logo" class="logo" />
        <h1>Resumen de la Cita</h1>
      </header>
  
      <div class="factura-content">
        <div class="factura-box">
          <h2>Detalles de la Cita</h2>
          <p><strong>Cliente ID:</strong> {{ userId }}</p>
          <p><strong>Barbero:</strong> {{ barberName }} (ID: {{ barberId }})</p>
          <p><strong>Fecha:</strong> {{ date }}</p>
          <p><strong>Hora:</strong> {{ time }}</p>
  
          <div v-if="servicios.length">
            <h3>Servicios Seleccionados:</h3>
            <ul>
              <li v-for="(servicio, index) in servicios" :key="index">
                {{ servicio.name_service }} - ${{ servicio.price }}
              </li>
            </ul>
          </div>
  
          <p class="total">
            <strong>Total:</strong> ${{ totalServicios }}
          </p>
          <button class="volver-btn" @click="guardarRelacion">Continuar</button>
        </div>
      </div>
    </div>
  </template>
  
  <script>
  import { createTypeOfQuote } from '@/services/typeQuotesApi';
  
  export default {
    name: 'FacturaServicios',
    data() {
      return {
        userId: null,
        barberId: null,
        barberName: '',
        date: '',
        time: '',
        servicios: [],
        quoteId: null, // id_quotes
      };
    },
    computed: {
      totalServicios() {
        return this.servicios.reduce((total, s) => total + parseFloat(s.price), 0);
      }
    },
    methods: {
      async guardarRelacion() {
        if (!this.quoteId || !this.servicios.length || !this.barberId) {
          alert('Faltan datos para guardar la relación.');
          return;
        }
  
        try {
          for (const servicio of this.servicios) {
            await createTypeOfQuote({
              id_quotes: this.quoteId,
              id_services: servicio.id_services,
              barber_id: this.barberId
            });
          }
  
          alert('Cita registrada exitosamente.');
          this.$router.push('/');
        } catch (error) {
          console.error('Error al guardar en type_of_quotes:', error);
          alert('Hubo un problema al guardar los servicios relacionados.');
        }
      }
    },
    mounted() {
      const query = this.$route.query;
      this.userId = parseInt(query.user_id);
      this.barberId = parseInt(query.barber_id);
      this.barberName = query.barber_name || '';
      this.date = query.date || '';
      this.time = query.time || '';
      this.quoteId = parseInt(query.id_quotes); // <--- aquí lo tomamos
  
      if (query.servicios) {
        try {
          this.servicios = JSON.parse(decodeURIComponent(query.servicios));
        } catch (e) {
          console.error('Error al parsear servicios:', e);
        }
      }
    }
  };
  </script>
  
  
  
  <style scoped>
  .factura-container {
    background-color: #000;
    color: #fff;
    font-family: 'Georgia', serif;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
  }
  
  .custom-header {
    display: flex;
    align-items: center;
    justify-content: center;
    border-bottom: 1px solid #666;
    padding: 10px 0;
    position: relative;
    width: 100%;
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
  
  .factura-content {
    flex: 1;
    display: flex;
    justify-content: center;
    align-items: start;
    padding: 30px;
    width: 100%;
  }
  
  .factura-box {
    background-color: #1a1a1a;
    padding: 30px;
    border-radius: 12px;
    width: 100%;
    max-width: 600px;
    border: 1px solid #ccc;
  }
  
  .factura-box h2,
  .factura-box h3 {
    color: #D4AF37;
    margin-bottom: 10px;
  }
  
  .factura-box p,
  .factura-box li {
    font-size: 16px;
    margin: 5px 0;
  }
  
  .total {
    margin-top: 15px;
    font-size: 18px;
    font-weight: bold;
    color: #D4AF37;
  }
  
  .volver-btn {
    margin-top: 20px;
    background-color: #D4AF37;
    color: #000;
    border: none;
    padding: 12px 20px;
    cursor: pointer;
    border-radius: 6px;
    font-weight: bold;
    width: 100%;
  }
  </style>
  