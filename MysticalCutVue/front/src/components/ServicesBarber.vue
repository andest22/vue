<template>
  <div class="container">
    <HeaderComponent />

    <!-- Barra de navegación de categorías -->
    <div class="category-nav">
      <ul class="nav justify-content-center">
        <li v-for="(services, category) in servicesByCategory" :key="category" class="nav-item">
          <a :href="'#' + getCategoryId(category)" class="nav-link">{{ category }}</a>
        </li>
      </ul>
    </div>

    <div class="d-flex justify-content-between align-items-center my-3">
      <router-link to="/Create-Services" class="btn btn-agregar">
        <img :src="personPlus" style="width: 20px; height: 20px; margin-right: 5px;" />
        Agregar
      </router-link>

      <router-link to="/Services-Inactivos" class="btn btn-secondary">
        Servicios Inactivos
      </router-link>
    </div>

    <!-- Contenedor principal -->
    <div class="d-flex flex-wrap justify-content-center gap-4 align-items-start">

      <!-- Servicios por categoría -->
      <div class="col-lg-8">
        <div v-for="(services, category) in servicesByCategory" :key="category" class="service-category">
          <h3 :id="getCategoryId(category)" class="text-center text-uppercase category-title">
            {{ category }}
          </h3>

          <div class="d-flex flex-column align-items-center">
            <div class="service-section w-100 mb-5" v-for="service in services" :key="service.id_services">
              <div class="card">
                <div class="card-body d-flex">
                  <!-- Imagen del servicio -->
                  <div class="service-image">
                    <img :src="getServiceImage(service.image)" :alt="service.name_service" class="img-fluid"
                      style="max-width: 150px; margin-right: 15px;">
                  </div>
                  <!-- Detalle del servicio -->
                  <div class="service-details">
                    <h5 class="card-title">{{ service.name_service }}</h5>
                    <p class="card-description">{{ service.description }}</p>

                    <div class="card-actions mt-2">
                      <router-link :to="`/services/view/${service.id_services}`"
                        class="btn btn-outline-primary me-2">Ver</router-link>
                      <button class="btn btn-success me-2" @click="selectService(service)">Seleccionar</button>
                      <router-link :to="`/Editar-Services/${service.id_services}`" class="btn btn-warning me-2">Editar</router-link>
                      <button class="btn btn-danger" @click="confirmDelete(service.id_services)">Eliminar</button>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Recuadro de servicios seleccionados -->
      <div v-if="selectedServices.length" class="selected-service-box card text-white bg-dark p-4">
        <h4 class="mb-3">Servicios Seleccionados</h4>
        <ul class="list-unstyled">
          <li v-for="service in selectedServices" :key="service.id_services" class="mb-2">
            <strong>{{ service.name_service }}</strong> - ${{ service.price }}
            <button class="btn btn-sm btn-outline-danger ms-2" @click="removeSelected(service.id_services)">X</button>
          </li>
        </ul>

        <p class="mt-3"><strong>Total:</strong> ${{ totalPrice }}</p>

        <div class="d-flex justify-content-between mt-3">
          <button class="btn btn-danger" @click="clearAllSelected">Eliminar selección</button>
          <button class="btn btn-success">Continuar</button>
        </div>
      </div>
    </div>

    <!-- Botón Regresar -->
    <div class="btn-regresar mt-3 text-center">
      <button class="btn btn-secondary" @click="goBack">Regresar</button>
    </div>

    <footer class="py-3 my-4">
      <p class="text-center text-white">© 2024 www.mysticalcut.com, Inc</p>
    </footer>
  </div>
</template>

<script setup>
import { onMounted, ref, computed } from 'vue';
import { getAllServices, deleteService } from '@/services/servicesApi';
import HeaderComponent from '@/components/HeaderComponent.vue';
import { useRouter } from 'vue-router';
import '@/assets/css/style.css';
import '@/assets/css/services.css';

const router = useRouter();
const services = ref([]);
const selectedServices = ref([]); // Múltiples servicios seleccionados

// Cargar servicios
const fetchServices = async () => {
  try {
    services.value = await getAllServices();
  } catch (error) {
    console.error("Error al cargar servicios:", error);
    alert("Hubo un problema al obtener los servicios.");
  }
};

// Agrupar servicios por categoría
const servicesByCategory = computed(() => {
  const categorized = {};
  services.value.forEach(service => {
    const category = service.category_name || "Otros";
    if (!categorized[category]) {
      categorized[category] = [];
    }
    categorized[category].push(service);
  });
  return categorized;
});

// Crear ID de categoría para anclaje
const getCategoryId = (category) => {
  return category.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]+/g, '');
};

// Obtener imagen del servicio
const getServiceImage = (image) => {
  return image ? `/background/${image}` : '/img/background/combo01.png';
};

// Seleccionar múltiples servicios sin duplicar
const selectService = (service) => {
  const exists = selectedServices.value.find(s => s.id_services === service.id_services);
  if (!exists) selectedServices.value.push(service);
};

// Eliminar un servicio seleccionado
const removeSelected = (id) => {
  selectedServices.value = selectedServices.value.filter(s => s.id_services !== id);
};

// Limpiar toda la selección
const clearAllSelected = () => {
  selectedServices.value = [];
};

// Calcular el total
const totalPrice = computed(() => {
  return selectedServices.value.reduce((sum, s) => sum + parseFloat(s.price || 0), 0).toFixed(2);
});

// Confirmar eliminación
const confirmDelete = async (id) => {
  if (!id) {
    console.error("ID inválido para eliminar:", id);
    alert("ID de servicio inválido.");
    return;
  }

  const confirmar = confirm('¿Estás seguro de eliminar este servicio?');
  if (!confirmar) return;

  try {
    await deleteService(id);
    alert("✅ Servicio eliminado correctamente.");
    await fetchServices();
  } catch (error) {
    console.error("❌ Error al eliminar el servicio:", error);
    alert("❌ No se pudo eliminar el servicio.");
  }
};

// Volver atrás
const goBack = () => router.push('/Home');

onMounted(fetchServices);
</script>

<style scoped>
/* Navegación de categorías */
.category-nav {
  margin: 20px 0;
}

.category-nav .nav-link {
  font-size: 1.1rem;
  font-weight: bold;
  color: gold;
  text-transform: uppercase;
}

.category-nav .nav-link:hover {
  color: white;
  text-decoration: underline;
}

/* Títulos de categoría */
.category-title {
  margin-top: 50px;
  padding-top: 20px;
  border-top: none;
  color: gold;
  font-size: 1.8rem;
}

/* Recuadro servicio seleccionado */
.selected-service-box {
  max-width: 350px;
  min-width: 280px;
  border: 2px solid #444;
  border-radius: 12px;
  background-color: #111;
  box-shadow: 0 0 10px rgba(255, 215, 0, 0.3);
  align-self: flex-start;
}

/* Botón regresar */
.btn-regresar button {
  font-size: 1rem;
  padding: 10px 20px;
}
</style>
