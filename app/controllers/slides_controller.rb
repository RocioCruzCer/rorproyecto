# app/controllers/slides_controller.rb
class SlidesController < ApplicationController
  before_action :set_slide, only: [:destroy]
  
  def index
    @slides = Slide.all.order(created_at: :desc)
    @slide = Slide.new
  end
  
  def new
    @slide = Slide.new
  end
  
  def create
    @slide = Slide.new(slide_params)
    
    if @slide.save
      redirect_to slides_path, notice: 'Slide agregado exitosamente.'
    else
      render :new
    end
  end
  
  def destroy
    @slide.destroy
    redirect_to slides_path, notice: 'Slide eliminado exitosamente.'
  end
  
  private
  
  def set_slide
    @slide = Slide.find(params[:id])
  end
  
  def slide_params
    params.require(:slide).permit(:title, :image)
  end
end