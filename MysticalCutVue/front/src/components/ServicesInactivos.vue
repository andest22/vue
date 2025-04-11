<template>
    <div class="container">
      <header class="d-flex flex-wrap align-items-center justify-content-center justify-content-md-between py-3 mb-4 border-bottom">
        <div class="col-md-3 mb-2 mb-md-0">
          <img src="/img/background/LOGO.png" alt="Logo" width="125" height="125" class="d-inline-block align-text-top" />
        </div>
        <ul class="nav col-12 justify-content-center mx-auto">
          <h1>Servicios Inactivos</h1>
        </ul>
      </header>
  
      <div class="content">
        <div class="pedido-container">
          <div v-for="service in inactiveServices" :key="service.id_services" class="pedido-box">
            <div class="icon-usuario-container">
              <img src="/img/logos/tools.svg" class="btn icon-usuario" />
            </div>
            <span class="user-name">{{ service.name_service }}</span>
            <button class="activate-btn" @click="activateServiceHandler(service)">Activar</button>
          </div>
          <button class="btn back-button" @click="goBack">Regresar</button>
        </div>
      </div>
  
      <FooterComponent />
    </div>
  </template>
  
  <script setup>
  import { ref, onMounted } from 'vue';
  import { useRouter } from 'vue-router';
  import { getInactiveServices, activateService } from '@/services/servicesApi';
  import FooterComponent from '@/components/FooterComponent.vue';
  import '@/assets/css/style.css';
  import '@/assets/css/usersInfo.css';
  
  const router = useRouter();
  const inactiveServices = ref([]);
  
  const loadInactiveServices = async () => {
    try {
      inactiveServices.value = await getInactiveServices();
    } catch (error) {
      console.error("Error al obtener servicios inactivos:", error);
    }
  };
  
  const activateServiceHandler = async (service) => {
    try {
      await activateService(service.id_services);
      inactiveServices.value = inactiveServices.value.filter(s => s.id_services !== service.id_services);
    } catch (error) {
      console.error("Error al activar el servicio:", error);
    }
  };
  
  const goBack = () => {
    router.push('/Services');
  };
  
  onMounted(loadInactiveServices);
  </script>
  
  <style scoped>
  .activate-btn {
    background-color: #CCAF54;
    color: rgb(0, 0, 0);
    padding: 5px 10px;
    border: 1px;
    border-radius: 5px;
    cursor: pointer;
    box-shadow: #6d550e;
  }
  .activate-btn:hover {
    background-color: #8a7432;
  }
  </style>
  