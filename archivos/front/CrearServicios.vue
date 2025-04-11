<template>
  <div class="container">
    <!-- Header -->
    <header class="d-flex flex-wrap align-items-center justify-content-between py-3 mb-4 border-bottom">
      <div class="col-md-3">
          <img src="/img/background/LOGO.png" alt="Logo" width="125" height="125" />
      </div>
      <h1 class="text-center mx-auto">Agregar Servicio</h1>
    </header>

    <!-- Main Content -->
    <div class="row edit-container">
      <!-- Imagen y Precio -->
      <div class="col-md-5 text-center">
        <div class="image-placeholder mx-auto mb-3">
          <img :src="previewImage || '/img/background/signointerrogacion.jpg'" alt="Preview" style="width: 100%; max-height: 250px; object-fit: cover;" />
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

      <!-- Formulario -->
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

          <button type="submit" class="btn boton1 w-100">Agregar</button>
        </form>
      </div>
    </div>

    <!-- Botón Regresar -->
    <div class="text-center mt-4">
      <button class="btn boton2" @click="regresar">Regresar</button>
    </div>

    <!-- Mensajes -->
    <div class="text-center mt-3">
      <p v-if="message" class="text-success">{{ message }}</p>
      <p v-if="error" class="text-danger">{{ error }}</p>
    </div>
  </div>
</template>

<script>
import { ref } from 'vue';
import { useRouter } from 'vue-router';
import { createService } from '@/services/servicesApi';

export default {
  setup() {
    const router = useRouter();
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

    const handleImageUpload = (e) => {
      const file = e.target.files[0];
      if (file) {
        form.value.image = file.name;
        imagePreview.value = URL.createObjectURL(file);
      }
    };

    const handleSubmit = async () => {
      try {
        message.value = '';
        error.value = '';
        await createService(form.value);
        message.value = 'Servicio creado correctamente.';
        // Reiniciar
        form.value = {
          name_service: '',
          description: '',
          estimated_time: '',
          price: '',
          id_category_services: '',
          id_status: 1,
          image: ''
        };
        imagePreview.value = null;
      } catch (err) {
        console.error(err);
        error.value = 'Error al crear el servicio.';
      }
    };

    const regresar = () => {
      router.push('/editarServiciosADM');
    };

    return { form, imagePreview, handleSubmit, handleImageUpload, regresar, message, error };
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

.boton1,
.boton2 {
  padding: 10px 20px;
  border: none;
  border-radius: 6px;
  color: white;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

.boton1 {
  background-color: #007bff;
}

.boton1:hover {
  background-color: #0056b3;
}

.boton2 {
  background-color: #6c757d;
}

.boton2:hover {
  background-color: #5a6268;
}
</style>
