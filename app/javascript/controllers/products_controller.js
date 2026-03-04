// app/javascript/controllers/products_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "name", "category", "price", "brand", "deleteName"]
  static values = { 
    productId: Number,
    deleteId: Number
  }

  connect() {
    console.log("✅ Products controller connected")
    this.setupSearch()
  }

  // ===== FUNCIONES PARA MODALES =====
  openAddModal() {
    this.openModal('addModal')
  }

  openEditModal(event) {
    const button = event.currentTarget
    this.productIdValue = button.dataset.id
    
    document.getElementById('edit_name').value = button.dataset.name
    document.getElementById('edit_category').value = button.dataset.category
    document.getElementById('edit_price').value = button.dataset.price
    document.getElementById('edit_brand').value = button.dataset.brand
    
    this.openModal('editModal')
  }

  openDeleteModal(event) {
    const button = event.currentTarget
    this.deleteIdValue = button.dataset.id
    document.getElementById('deleteProductName').textContent = `"${button.dataset.name}"`
    
    this.openModal('deleteModal')
  }

  openModal(modalId) {
    const modal = document.getElementById(modalId)
    if (modal) {
      modal.classList.add('show')
      document.body.style.overflow = 'hidden'
    }
  }

  closeModal(event) {
    const modal = event.currentTarget.closest('.modal')
    if (modal) {
      modal.classList.remove('show')
      document.body.style.overflow = ''
    }
  }

  clickOutside(event) {
    if (event.target.classList.contains('modal')) {
      this.closeModal(event)
    }
  }

  // ===== ENVÍO DE FORMULARIOS =====
  async submitAdd(event) {
    event.preventDefault()
    const form = event.currentTarget
    
    if (!this.validateForm(form)) return
    
    this.setLoading(true)
    
    try {
      const formData = new FormData(form)
      const response = await fetch('/products', {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })
      
      const result = await response.json()
      
      if (result.success) {
        this.closeModal(event)
        if (result.html) {
          document.getElementById('productsTableContainer').innerHTML = result.html
        }
        form.reset()
        this.showMessage('success', '✅ Producto guardado exitosamente')
        this.updateStats()
      } else {
        if (result.errors) {
          this.displayErrors(result.errors)
        }
      }
    } catch (error) {
      console.error('Error:', error)
      this.showMessage('danger', '❌ Error de conexión')
    } finally {
      this.setLoading(false)
    }
  }

  async submitEdit(event) {
    event.preventDefault()
    const form = event.currentTarget
    
    try {
      const formData = new FormData(form)
      formData.append('_method', 'patch')
      
      const response = await fetch(`/products/${this.productIdValue}`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })
      
      const result = await response.json()
      
      if (result.success) {
        this.closeModal(event)
        if (result.html) {
          document.getElementById('productsTableContainer').innerHTML = result.html
        }
        this.showMessage('success', '✅ Producto actualizado exitosamente')
        this.updateStats()
      } else {
        this.showMessage('danger', '❌ Error: ' + (result.errors || 'Error desconocido').join(', '))
      }
    } catch (error) {
      console.error('Error:', error)
      this.showMessage('danger', '❌ Error de conexión')
    }
  }

  async submitDelete(event) {
    event.preventDefault()
    
    try {
      const formData = new FormData()
      formData.append('_method', 'delete')
      formData.append('authenticity_token', document.querySelector('[name="csrf-token"]').content)
      
      const response = await fetch(`/products/${this.deleteIdValue}`, {
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        body: formData
      })
      
      const result = await response.json()
      
      if (result.success) {
        this.closeModal(event)
        if (result.html) {
          document.getElementById('productsTableContainer').innerHTML = result.html
        }
        this.showMessage('success', '✅ Producto eliminado exitosamente')
        this.updateStats()
      } else {
        this.showMessage('danger', '❌ Error al eliminar')
      }
    } catch (error) {
      console.error('Error:', error)
      this.showMessage('danger', '❌ Error de conexión')
    }
  }

  // ===== BÚSQUEDA =====
  setupSearch() {
    const searchInput = document.getElementById('searchInput')
    if (!searchInput) return
    
    searchInput.addEventListener('input', (e) => {
      const query = e.target.value.trim().toLowerCase()
      const clearSearch = document.getElementById('clearSearch')
      
      if (clearSearch) {
        clearSearch.style.display = query.length > 0 ? 'block' : 'none'
      }
      
      this.filterTable(query)
    })
    
    const clearSearch = document.getElementById('clearSearch')
    if (clearSearch) {
      clearSearch.addEventListener('click', () => {
        searchInput.value = ''
        clearSearch.style.display = 'none'
        this.filterTable('')
      })
    }
  }

  filterTable(query) {
    const tableBody = document.querySelector('#productsTableContainer table tbody')
    if (!tableBody) return
    
    const rows = tableBody.querySelectorAll('tr')
    let visibleCount = 0
    
    rows.forEach(row => {
      const text = row.textContent.toLowerCase()
      if (query.length === 0 || text.includes(query)) {
        row.style.display = ''
        visibleCount++
      } else {
        row.style.display = 'none'
      }
    })
    
    this.toggleNoResults(visibleCount, query)
  }

  toggleNoResults(visibleCount, query) {
    const container = document.getElementById('productsTableContainer')
    let noResults = document.getElementById('noResultsMessage')
    
    if (visibleCount === 0 && query.length > 0) {
      if (!noResults) {
        noResults = document.createElement('div')
        noResults.id = 'noResultsMessage'
        noResults.className = 'text-center py-5'
        noResults.innerHTML = `
          <i class="bi bi-search" style="font-size: 60px; color: var(--rosa-clarito);"></i>
          <h4 class="mt-3 text-muted">No se encontraron productos</h4>
          <p class="text-muted">No hay resultados para "<strong>${query}</strong>"</p>
        `
        container.appendChild(noResults)
      }
    } else if (noResults) {
      noResults.remove()
    }
  }

  // ===== VALIDACIONES =====
  validateForm(form) {
    let isValid = true
    const fields = [
      { name: 'name', label: 'nombre', minLength: 3 },
      { name: 'category', label: 'categoría' },
      { name: 'price', label: 'precio', isNumber: true },
      { name: 'brand', label: 'marca' }
    ]
    
    fields.forEach(field => {
      const input = form.querySelector(`[name="product[${field.name}]"]`)
      if (!input) return
      
      if (!input.value.trim()) {
        this.showFieldError(input, `El ${field.label} es obligatorio`)
        isValid = false
      } else if (field.minLength && input.value.trim().length < field.minLength) {
        this.showFieldError(input, `El ${field.label} debe tener al menos ${field.minLength} caracteres`)
        isValid = false
      } else if (field.isNumber && parseFloat(input.value) <= 0) {
        this.showFieldError(input, `El ${field.label} debe ser mayor a 0`)
        isValid = false
      } else {
        this.clearFieldError(input)
      }
    })
    
    return isValid
  }

  showFieldError(input, message) {
    input.classList.add('is-invalid')
    const errorDiv = input.closest('.mb-3').querySelector('.invalid-feedback')
    if (errorDiv) {
      errorDiv.textContent = message
      errorDiv.style.display = 'block'
    }
  }

  clearFieldError(input) {
    input.classList.remove('is-invalid')
    const errorDiv = input.closest('.mb-3').querySelector('.invalid-feedback')
    if (errorDiv) {
      errorDiv.style.display = 'none'
    }
  }

  displayErrors(errors) {
    errors.forEach(error => {
      const errorLower = error.toLowerCase()
      if (errorLower.includes('nombre')) {
        const input = document.getElementById('product_name')
        if (input) this.showFieldError(input, error)
      } else if (errorLower.includes('categor')) {
        const input = document.getElementById('product_category')
        if (input) this.showFieldError(input, error)
      } else if (errorLower.includes('precio')) {
        const input = document.getElementById('product_price')
        if (input) this.showFieldError(input, error)
      } else if (errorLower.includes('marca')) {
        const input = document.getElementById('product_brand')
        if (input) this.showFieldError(input, error)
      } else {
        this.showMessage('danger', `❌ ${error}`)
      }
    })
  }

  // ===== UTILIDADES =====
  setLoading(loading) {
    const btn = document.getElementById('submitBtn')
    if (btn) {
      if (loading) {
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Guardando...'
        btn.disabled = true
      } else {
        btn.innerHTML = '<i class="bi bi-check-circle"></i> Guardar Producto'
        btn.disabled = false
      }
    }
  }

  showMessage(type, text) {
    const oldMessage = document.querySelector('.alert-global')
    if (oldMessage) oldMessage.remove()
    
    const messageDiv = document.createElement('div')
    messageDiv.className = `alert alert-${type} alert-global alert-dismissible fade show`
    messageDiv.innerHTML = `
      <i class="bi ${type === 'success' ? 'bi-check-circle' : 'bi-exclamation-triangle'} me-2"></i>
      ${text}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    `
    
    const container = document.querySelector('.flash-messages') || document.querySelector('.content-wrapper')
    if (container) {
      container.prepend(messageDiv)
    }
    
    setTimeout(() => {
      if (messageDiv.parentElement) messageDiv.remove()
    }, 5000)
  }

  updateStats() {
    setTimeout(() => {
      fetch('/product_data')
        .then(response => response.json())
        .then(data => {
          document.getElementById('totalProducts').textContent = data.length || 0
          const categories = new Set((data || []).map(p => p.category))
          document.getElementById('totalCategories').textContent = categories.size
          const brands = new Set((data || []).map(p => p.brand))
          document.getElementById('totalBrands').textContent = brands.size
        })
        .catch(error => console.error('Error al actualizar stats:', error))
    }, 500)
  }
}