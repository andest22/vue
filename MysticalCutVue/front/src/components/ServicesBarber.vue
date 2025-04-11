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

    

    <!-- Servicios por categoría -->
    <div class="row justify-content-center">
      <div class="col-md-10">
        <div v-for="(services, category) in servicesByCategory" :key="category" class="service-category">
          <h3 :id="getCategoryId(category)" class="text-center text-uppercase category-title">
            {{ category }}
          </h3>

          <div class="d-flex flex-column align-items-center">
            <div class="service-section w-75 mb-5" v-for="service in services" :key="service.id_services">
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

// Cargar servicios desde la base de datos
const fetchServices = async () => {
  try {
    services.value = await getAllServices();
  } catch (error) {
    console.error("Error al cargar servicios:", error);
    alert("Hubo un problema al obtener los servicios.");
  }
};

// Agrupa los servicios por su nombre de categoría
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

// Crea un ID limpio para anclaje
const getCategoryId = (category) => {
  return category.toLowerCase().replace(/\s+/g, '-').replace(/[^\w-]+/g, '');
};

// Retorna imagen o imagen por defecto
const getServiceImage = (image) => {
  return image ? `/background/${image}` : '/img/background/combo01.png';
};

// Confirmar eliminación (CORREGIDO)
const confirmDelete = async (id) => {
  if (!id) {
    console.error("ID inválido para eliminar:", id);
    alert("ID de servicio inválido.");
    return;
  }

  const confirmar = confirm('¿Estás seguro de eliminar este servicio?');

  if (!confirmar) return;

  try {
    console.log("Eliminando servicio con ID:", id);
    await deleteService(id);
    alert("✅ Servicio eliminado correctamente.");
    await fetchServices();
  } catch (error) {
    console.error("❌ Error al eliminar el servicio:", error);
    alert("❌ No se pudo eliminar el servicio.");
  }
};

// Redirigir a página anterior
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

/* Animación de scroll suave */
html {
  scroll-behavior: smooth;
}

/* Botón regresar */
.btn-regresar button {
  font-size: 1rem;
  padding: 10px 20px;
}
</style>
