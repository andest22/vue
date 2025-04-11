<template>
  <div class="container">
   

    <!-- Selección de Categoría -->
    <div class="text-center mt-3">
      <label for="categorySelect" class="form-label">Selecciona una Categoría:</label>
      <select id="categorySelect" v-model="selectedCategory" @change="fetchServices" class="form-select">
        <option value="">Todas</option>
        <option v-for="(title, id) in customTitles" :key="id" :value="id">
          {{ title }}
        </option>
      </select>
    </div>

    <!-- Botón Agregar Servicio -->
    <div>
      <router-link to="/Create-Services" class="btn btn-agregar">
        <img src="/assets/img/logos/person-plus-fill.svg" style="width: 20px; height: 20px; margin-right: 5px;">
        Agregar
      </router-link>
    </div>

    <!-- Servicios agrupados por categoría -->
    <div class="row justify-content-center mt-4">
      <div class="col-md-10">
        <section v-for="(servicesList, categoryId) in groupedServices" :key="categoryId" class="mb-5">
          <h3 class="text-center text-uppercase category-title">
            {{ getCustomTitle(categoryId) }}
          </h3>

          <div v-for="service in servicesList" :key="service.id_services" class="card mb-3">
            <div class="card-body d-flex">
              <!-- Imagen del servicio -->
              <div class="service-image">
                <img
                  :src="getServiceImage(service.image)"
                  :alt="service.name_service"
                  class="img-fluid"
                  style="max-width: 150px; margin-right: 15px;"
                />
              </div>

              <!-- Detalle del servicio -->
              <div class="service-details">
                <h5 class="card-title">{{ service.name_service }}</h5>
                <p class="card-description">{{ service.description }}</p>

                <div class="card-actions mt-2">
                  <router-link :to="`/services/view/${service.id_services}`" class="btn btn-icon btn-view">Ver</router-link>
                  <button class="btn btn-icon btn-select" @click="selectService(service)">Seleccionar</button>
                  <router-link :to="`/services/edit/${service.id_services}`" class="btn btn-icon btn-edit">Editar</router-link>
                  <button class="btn btn-icon btn-delete" @click="confirmDelete(service.id_services)">Eliminar</button>
                </div>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>

    <!-- Botón Regresar -->
    <div class="btn-regresar mt-3 text-center">
      <button class="back-button btn btn-secondary" @click="goBack">Regresar</button>
    </div>

    <footer class="py-3 my-4">
      <ul class="nav justify-content-center border-bottom pb-3 mb-3"></ul>
      <p class="text-center text-white"></p>
    </footer>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue';
import { useRouter } from 'vue-router';
import { getServicesByCategory, getAllServices, deleteService } from '@/services/servicesApi';


// Router
const router = useRouter();

// Datos
const services = ref([]);
const selectedCategory = ref("");

// Títulos personalizados por categoría
const customTitles = {
  1: "Cortes de Cabello",
  2: "Afeitado y Barba",
  3: "Coloración y Tintes",
  4: "Tratamientos Capilares",
  5: "Servicios para Niños"
};

// Agrupar servicios por categoría
const groupedServices = computed(() => {
  const grouped = {};
  services.value.forEach(service => {
    const categoryId = service.id_category_services || "Otros";
    if (!grouped[categoryId]) {
      grouped[categoryId] = [];
    }
    grouped[categoryId].push(service);
  });
  return grouped;
});

// Obtener título de la categoría
const getCustomTitle = (id) => customTitles[id] || "Otros Servicios";

// Obtener imagen del servicio
const getServiceImage = (image) => {
  return image ? `/background/${image}` : '/img/background/combo01.png';
};

// Obtener servicios
const fetchServices = async () => {
  try {
    if (selectedCategory.value) {
      services.value = await getServicesByCategory(selectedCategory.value);
    } else {
      services.value = await getAllServices();
    }
    console.log("Servicios obtenidos:", services.value);
  } catch (error) {
    console.error("Error al cargar servicios:", error);
    alert("Hubo un problema al obtener los servicios.");
  }
};

// Eliminar servicio
const confirmDelete = async (id) => {
  if (confirm('¿Estás seguro de eliminar este servicio?')) {
    try {
      await deleteService(id);
      fetchServices();
    } catch (err) {
      alert('Error al eliminar el servicio');
    }
  }
};

// Volver
const goBack = () => router.push('/Home');

// Seleccionar servicio
const selectService = (service) => {
  console.log('Seleccionado:', service);
};

onMounted(() => {
  fetchServices();
});
</script>

<style scoped>
.category-title {
  background-color: #007bff;
  color: white;
  padding: 10px;
  border-radius: 8px;
  margin-bottom: 20px;
}
.card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
}
.btn-icon {
  margin-right: 5px;
}
.btn-agregar {
  margin-top: 20px;
  background-color: #28a745;
  color: white;
  padding: 8px 16px;
  border-radius: 6px;
  font-weight: bold;
  text-decoration: none;
  display: inline-flex;
  align-items: center;
}
.form-select {
  width: 50%;
  margin: 0 auto;
}
</style>
