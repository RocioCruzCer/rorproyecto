// app/javascript/questionnaire_list.js
document.addEventListener('DOMContentLoaded', function() {
  // Elementos del DOM
  const refreshBtn = document.getElementById('refreshBtn');
  const exportBtn = document.getElementById('exportBtn');
  const exportModal = new bootstrap.Modal(document.getElementById('exportModal'));
  const exportJSONBtn = document.getElementById('exportJSON');
  const exportCSVBtn = document.getElementById('exportCSV');
  const exportResult = document.getElementById('exportResult');
  const questionnairesTableBody = document.getElementById('questionnairesTableBody');
  const mobileList = document.getElementById('mobileList');

  // Detectar tamaño de pantalla
  function checkScreenSize() {
    if (window.innerWidth < 768) {
      if (questionnairesTableBody) questionnairesTableBody.parentElement.parentElement.classList.add('d-none');
      if (mobileList) mobileList.classList.remove('d-none');
    } else {
      if (questionnairesTableBody) questionnairesTableBody.parentElement.parentElement.classList.remove('d-none');
      if (mobileList) mobileList.classList.add('d-none');
    }
  }

  // Verificar al cargar y al redimensionar
  checkScreenSize();
  window.addEventListener('resize', checkScreenSize);

  // Botón de actualizar
  if (refreshBtn) {
    refreshBtn.addEventListener('click', function() {
      this.innerHTML = '<span class="spinner-border spinner-border-sm" role="status"></span> Actualizando...';
      this.disabled = true;
      
      setTimeout(() => {
        location.reload();
      }, 500);
    });
  }

  // Botón de exportar
  if (exportBtn) {
    exportBtn.addEventListener('click', function() {
      exportModal.show();
    });
  }

  // Exportar a JSON
  if (exportJSONBtn) {
    exportJSONBtn.addEventListener('click', async function() {
      try {
        const response = await fetch('/questionnaire_data');
        const data = await response.json();
        
        const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `questionnaires_${new Date().toISOString().split('T')[0]}.json`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        exportResult.innerHTML = '<div class="alert alert-success">✅ JSON exportado exitosamente</div>';
        setTimeout(() => exportModal.hide(), 2000);
      } catch (error) {
        exportResult.innerHTML = '<div class="alert alert-danger">❌ Error al exportar JSON</div>';
      }
    });
  }

  // Exportar a CSV
  if (exportCSVBtn) {
    exportCSVBtn.addEventListener('click', async function() {
      try {
        const response = await fetch('/questionnaire_data');
        const data = await response.json();
        
        // Crear CSV
        const headers = ['ID', 'Nombre', 'Email', 'Fecha de Creación'];
        const rows = data.map(item => [
          item.id,
          `"${item.name.replace(/"/g, '""')}"`,
          item.email,
          new Date(item.created_at).toLocaleString('es-ES')
        ]);
        
        const csvContent = [
          headers.join(','),
          ...rows.map(row => row.join(','))
        ].join('\n');
        
        const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
        const url = URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.href = url;
        a.download = `questionnaires_${new Date().toISOString().split('T')[0]}.csv`;
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);
        
        exportResult.innerHTML = '<div class="alert alert-success">✅ CSV exportado exitosamente</div>';
        setTimeout(() => exportModal.hide(), 2000);
      } catch (error) {
        exportResult.innerHTML = '<div class="alert alert-danger">❌ Error al exportar CSV</div>';
      }
    });
  }

  // Actualizar automáticamente cada 60 segundos
  setInterval(() => {
    if (refreshBtn && !refreshBtn.disabled) {
      refreshBtn.click();
    }
  }, 60000);
});