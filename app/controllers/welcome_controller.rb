class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [
    :submit_questionnaire,
    :create_slide,
    :destroy_slide
  ]

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

  def carousel
    @slides = Slide.all.order(created_at: :desc)
    @slide = Slide.new
  end

  def create_slide
    @slide = Slide.new(slide_params)

    if @slide.save
      redirect_to carousel_path, notice: "¡Imagen agregada exitosamente al carrusel!"
    else
      @slides = Slide.all.order(created_at: :desc)
      flash.now[:alert] = @slide.errors.full_messages.join(", ")
      render :carousel, status: :unprocessable_entity
    end
  end

  def destroy_slide
    @slide = Slide.find(params[:id])
    @slide.destroy
    redirect_to carousel_path, notice: "¡Imagen eliminada del carrusel!"
  rescue ActiveRecord::RecordNotFound
    redirect_to carousel_path, alert: "La imagen no fue encontrada"
  end

  # ========== ACCIONES PARA EL FORMULARIO DE CUESTIONARIO ==========
  def questionnaire_form
    # Renderiza la vista con el formulario
  end

  def submit_questionnaire
    @questionnaire = Questionnaire.new(questionnaire_params)

    respond_to do |format|
      if @questionnaire.save
        format.html {
          redirect_to questionnaire_list_path,
          notice: "¡Cuestionario guardado exitosamente!"
        }
        format.json {
          render json: {
            success: true,
            message: "Cuestionario guardado exitosamente.",
            questionnaire: @questionnaire
          }, status: :created
        }
      else
        format.html {
          flash.now[:alert] = @questionnaire.errors.full_messages.join(", ")
          render :questionnaire_form, status: :unprocessable_entity
        }
        format.json {
          render json: {
            success: false,
            errors: @questionnaire.errors.full_messages
          }, status: :unprocessable_entity
        }
      end
    end
  end

  def questionnaire_data
    @questionnaires = Questionnaire.all.order(created_at: :desc)
    render json: @questionnaires
  end

  def questionnaire_list
    @questionnaires = Questionnaire.all.order(created_at: :desc)
  end

  private

  def slide_params
    params.require(:slide).permit(:title, :image)
  end

  def questionnaire_params
    params.require(:questionnaire).permit(:name, :email)
  end
end