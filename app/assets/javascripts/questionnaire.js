// app/javascript/questionnaire.js
document.addEventListener('DOMContentLoaded', function() {
  // Elementos del DOM
  const form = document.getElementById('questionnaireForm');
  const submitBtn = document.getElementById('submitBtn');
  const submitText = document.getElementById('submitText');
  const submitSpinner = document.getElementById('submitSpinner');
  const formMessage = document.getElementById('formMessage');
  const successModal = new bootstrap.Modal(document.getElementById('successModal'));

  // Validar formulario al enviar
  form.addEventListener('submit', async function(e) {
    e.preventDefault();
    
    // Validar campos
    if (!validateForm()) {
      return;
    }
    
    // Obtener datos del formulario
    const formData = new FormData(form);
    const data = {};
    formData.forEach((value, key) => {
      // Convertir question[name] a question[name]
      data[key] = value;
    });
    
    // Agregar authenticity_token
    const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
    
    // Mostrar estado de carga
    setLoadingState(true);
    
    try {
      // Enviar con Fetch API
      const response = await fetch('/submit_questionnaire', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'Accept': 'application/json'
        },
        body: JSON.stringify(data)
      });
      
      const result = await response.json();
      
      if (result.success) {
        // Mostrar modal de éxito
        document.getElementById('modalMessage').textContent = 
          `¡Gracias ${data['questionnaire[name]']}! Tu información ha sido guardada.`;
        successModal.show();
        
        // Limpiar formulario
        form.reset();
        
        // Mostrar mensaje temporal
        showMessage('success', '✅ Datos guardados exitosamente en la base de datos');
      } else {
        // Mostrar errores
        if (result.errors && result.errors.length > 0) {
          showMessage('danger', '❌ ' + result.errors.join('<br>'));
        } else {
          showMessage('danger', '❌ Error al guardar el cuestionario');
        }
      }
    } catch (error) {
      console.error('Error:', error);
      showMessage('danger', '❌ Error de conexión con el servidor');
    } finally {
      setLoadingState(false);
    }
  });

  // Función de validación
  function validateForm() {
    let isValid = true;
    const nameInput = document.getElementById('name');
    const emailInput = document.getElementById('email');
    
    // Limpiar errores previos
    clearErrors();
    
    // Validar nombre (mínimo 2 caracteres)
    if (!nameInput.value.trim()) {
      showFieldError('name', 'El nombre es obligatorio');
      isValid = false;
    } else if (nameInput.value.trim().length < 2) {
      showFieldError('name', 'El nombre debe tener al menos 2 caracteres');
      isValid = false;
    }
    
    // Validar email
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailInput.value.trim()) {
      showFieldError('email', 'El email es obligatorio');
      isValid = false;
    } else if (!emailRegex.test(emailInput.value)) {
      showFieldError('email', 'Ingresa un email válido (ejemplo@correo.com)');
      isValid = false;
    }
    
    return isValid;
  }

  // Mostrar error en campo específico
  function showFieldError(fieldId, message) {
    const input = document.getElementById(fieldId);
    const errorDiv = document.getElementById(`${fieldId}Error`);
    
    if (input && errorDiv) {
      input.classList.add('is-invalid');
      errorDiv.textContent = message;
      errorDiv.style.display = 'block';
    }
  }

  // Limpiar errores
  function clearErrors() {
    document.querySelectorAll('.is-invalid').forEach(el => {
      el.classList.remove('is-invalid');
    });
    
    document.querySelectorAll('.invalid-feedback').forEach(el => {
      el.style.display = 'none';
    });
  }

  // Mostrar mensajes
  function showMessage(type, text) {
    formMessage.innerHTML = `
      <div class="alert alert-${type} alert-dismissible fade show" role="alert">
        <div>${text}</div>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
      </div>
    `;
    
    // Auto-ocultar mensajes de éxito después de 5 segundos
    if (type === 'success') {
      setTimeout(() => {
        const alert = formMessage.querySelector('.alert');
        if (alert) {
          bootstrap.Alert.getOrCreateInstance(alert).close();
        }
      }, 5000);
    }
  }

  // Estado de carga
  function setLoadingState(isLoading) {
    if (isLoading) {
      submitText.style.display = 'none';
      submitSpinner.style.display = 'inline-block';
      submitBtn.disabled = true;
      submitBtn.classList.add('disabled');
    } else {
      submitText.style.display = 'inline-block';
      submitSpinner.style.display = 'none';
      submitBtn.disabled = false;
      submitBtn.classList.remove('disabled');
    }
  }

  // Validación en tiempo real
  document.getElementById('name').addEventListener('blur', validateName);
  document.getElementById('email').addEventListener('blur', validateEmail);

  function validateName() {
    const nameInput = document.getElementById('name');
    if (nameInput.value.trim().length < 2 && nameInput.value.trim() !== '') {
      showFieldError('name', 'El nombre debe tener al menos 2 caracteres');
    } else if (nameInput.value.trim()) {
      clearFieldError('name');
    }
  }

  function validateEmail() {
    const emailInput = document.getElementById('email');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (emailInput.value.trim() && !emailRegex.test(emailInput.value)) {
      showFieldError('email', 'Ingresa un email válido');
    } else if (emailInput.value.trim()) {
      clearFieldError('email');
    }
  }

  function clearFieldError(fieldId) {
    const input = document.getElementById(fieldId);
    const errorDiv = document.getElementById(`${fieldId}Error`);
    
    if (input && errorDiv) {
      input.classList.remove('is-invalid');
      errorDiv.style.display = 'none';
    }
  }
});