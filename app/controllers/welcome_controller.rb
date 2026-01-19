class WelcomeController < ApplicationController
  def index
    @click = Click.last || Click.create(count: 0)
    @total_clicks = @click.count
  end
  
  def error_page
    @error_code = params[:code] || "500"
    
    @error_messages = {
      "400" => "Solicitud Incorrecta",
      "401" => "No Autorizado", 
      "403" => "Prohibido",
      "404" => "Página No Encontrada",
      "405" => "Método No Permitido",
      "408" => "Tiempo de Espera Agotado",
      "418" => "¡Soy una Tetera!",
      "429" => "Demasiadas Solicitudes",
      "500" => "Error Interno del Servidor",
      "502" => "Puerta de Enlace Incorrecta",
      "503" => "Servicio No Disponible"
    }
    
    @error_message = @error_messages[@error_code] || "Error Desconocido"
  end
  
  # ¡ESTA ES LA ACCIÓN QUE FALTABA!
  def random_error
    error_codes = ["400", "401", "403", "404", "408", "418", "429", "500", "502", "503"]
    random_code = error_codes.sample
    redirect_to error_page_path(code: random_code)
  end
end