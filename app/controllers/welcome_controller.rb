# app/controllers/welcome_controller.rb
class WelcomeController < ApplicationController
  def index
    # Código existente
  end

  def dashboard
    # Código existente
  end

  def error_page
    # Código existente
  end

  def personal_data
    # Acción para mostrar el formulario de datos personales
  end

  def save_personal_data
    # Acción para procesar el formulario
    flash[:success] = "Registro guardado exitosamente (simulación)"
    redirect_to personal_data_path, notice: "Registro guardado exitosamente (simulación)"
  end

  def system_info
    # Acción para mostrar información del sistema
  end

  def random_error
    # Código existente
  end

  def advanced_dashboard
    # Nueva acción para el dashboard avanzado
  end
end
