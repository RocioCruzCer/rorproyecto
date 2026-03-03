# app/controllers/questionnaires_controller.rb
class QuestionnairesController < ApplicationController
  protect_from_forgery with: :exception

  # Mostrar formulario
  def new
    @questionnaire = Questionnaire.new
  end

  # Guardar formulario (AJAX)
  def create
    @questionnaire = Questionnaire.new(questionnaire_params)

    if @questionnaire.save
      render json: {
        success: true,
        message: "Cuestionario guardado correctamente"
      }
    else
      render json: {
        success: false,
        errors: @questionnaire.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  # Listado
  def index
    @questionnaires = Questionnaire.order(created_at: :desc)
  end

  # Exportar JSON
  def export_json
    render json: Questionnaire.all
  end

  # Exportar CSV
  def export_csv
    require 'csv'
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["ID", "Nombre", "Email", "Fecha"]
      Questionnaire.find_each do |q|
        csv << [q.id, q.name, q.email, q.created_at]
      end
    end

    send_data csv_data, filename: "questionnaires.csv"
  end

  private

  def questionnaire_params
    params.require(:questionnaire).permit(:name, :email)
  end
end