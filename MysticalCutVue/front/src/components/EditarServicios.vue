<template>
    <div class="container">
      <header class="d-flex flex-wrap align-items-center justify-content-between py-3 mb-4 border-bottom">
        <div class="col-md-3">
          <img src="/img/background/LOGO.png" alt="Logo" width="125" height="125" />
        </div>
        <h1 class="text-center mx-auto">Editar Servicio</h1>
      </header>
  
      <div class="row edit-container">
        <div class="col-md-5 text-center">
          <div class="image-placeholder mx-auto mb-3">
            <img :src="imagePreview || '/img/background/signointerrogacion.jpg'" alt="Preview" style="width: 100%; max-height: 250px; object-fit: cover;" />
          </div>
          <div class="mb-3">
            <label class="form-label">Imagen</label>
            <input type="file" @change="handleImageUpload" class="form-control" />
          </div>
          <div class="mb-3">
            <label class="form-label">Precio</label>
            <input v-model="form.price" type="number" class="form-control" placeholder="Precio" required />
          </div>
        </div>
  
        <div class="col-md-5 offset-md-1">
          <form @submit.prevent="handleSubmit" class="edit-form">
            <div class="mb-3">
              <label class="form-label">Nombre</label>
              <input v-model="form.name_service" type="text" class="form-control" placeholder="Nombre del servicio" required />
            </div>
  
            <div class="mb-3">
              <label class="form-label">Descripción</label>
              <input v-model="form.description" type="text" class="form-control" placeholder="Descripción" required />
            </div>
  
            <div class="mb-3">
              <label class="form-label">Tiempo estimado</label>
              <input v-model="form.estimated_time" type="text" class="form-control" placeholder="00:30:00" required />
            </div>
  
            <div class="mb-3">
              <label class="form-label">Categoría</label>
              <select v-model="form.id_category_services" class="form-select" required>
                <option disabled value="">Seleccionar</option>
                <option value="1">Corte</option>
                <option value="2">Barba</option>
                <option value="3">Cejas</option>
                <option value="4">Tintes</option>
                <option value="5">Combos</option>
              </select>
            </div>
  
            <div class="mb-3">
              <label class="form-label">Estado</label>
              <select v-model="form.id_status" class="form-select">
                <option value="1">Activo</option>
                <option value="2">Inactivo</option>
              </select>
            </div>
  
            <button type="submit" class="btn w-100" style="background-color: #FFD700; color: black;">
              Guardar Cambios
            </button>
          </form>
        </div>
      </div>
  
      <router-link to="/Services" class="btn btn-secondary btn-regresar">Regresar</router-link>
  
      <div class="text-center mt-3">
        <p v-if="message" class="text-success">{{ message }}</p>
        <p v-if="error" class="text-danger">{{ error }}</p>
      </div>
    </div>
  </template>
  
  <script>
  import { ref, onMounted } from 'vue';
  import { useRouter, useRoute } from 'vue-router';
  import { getServiceById, updateService } from '@/services/servicesApi';
  
  export default {
    setup() {
      const router = useRouter();
      const route = useRoute();
      const id = route.params.id;
  
      const imagePreview = ref(null);
      const form = ref({
        name_service: '',
        description: '',
        estimated_time: '',
        price: '',
        id_category_services: '',
        id_status: 1,
        image: ''
      });
  
      const message = ref('');
      const error = ref('');
  
      const loadService = async () => {
        try {
          const data = await getServiceById(id);
          form.value = { ...data };
          if (form.value.image) {
            imagePreview.value = `/img/services/${form.value.image}`;
          }
        } catch (err) {
          console.error(err);
          error.value = 'Error al cargar el servicio.';
        }
      };
  
      const handleImageUpload = (e) => {
        const file = e.target.files[0];
        if (file) {
          form.value.image = file.name;
          imagePreview.value = URL.createObjectURL(file);
        }
      };
  
      const handleSubmit = async () => {
        message.value = '';
        error.value = '';
  
        if (
          !form.value.name_service.trim() ||
          !form.value.description.trim() ||
          !form.value.estimated_time.trim() ||
          !form.value.price ||
          !form.value.id_category_services ||
          !form.value.image
        ) {
          error.value = 'Por favor, complete todos los campos antes de continuar.';
          return;
        }
  
        try {
          await updateService(id, form.value);
          message.value = 'Servicio actualizado correctamente.';
          setTimeout(() => {
            router.push('/Services');
          }, 1000);
        } catch (err) {
          console.error(err);
          error.value = 'Error al actualizar el servicio.';
        }
      };
  
      onMounted(loadService);
  
      return {
        form,
        imagePreview,
        handleSubmit,
        handleImageUpload,
        message,
        error
      };
    }
  };
  </script>
  
  <style scoped>
  .container {
    padding: 20px;
  }
  
  .image-placeholder img {
    max-height: 300px;
    object-fit: cover;
  }
  
  .btn-regresar {
    margin-top: 20px;
  }
  </style>
  