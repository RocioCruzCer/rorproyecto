class ClicksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :increment ]

  def increment
    # Obtener el token de reCAPTCHA desde los parámetros
    recaptcha_response = params["g-recaptcha-response"]

    # Validar reCAPTCHA
    unless verify_recaptcha(response: recaptcha_response)
      render json: {
        success: false,
        error: "Por favor, verifica que no eres un robot antes de continuar."
      }, status: :unprocessable_entity
      return
    end

    # Si reCAPTCHA es válido, proceder con la lógica normal
    click = Click.last || Click.create(count: 0)
    click.update(count: click.count + 1)

    render json: {
      success: true,
      total: click.count,
      message: "Interacción registrada correctamente."
    }
  end

  def total
    click = Click.last || Click.create(count: 0)
    render json: { total: click.count }
  end
end
