# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :update, :destroy, :index_json ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.order(created_at: :desc).page(params[:page]).per(5) # Cambiado a 5
    @product = Product.new

    respond_to do |format|
      format.html
      format.json { render json: @products }
    end
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        # Recargar los productos con la página actual después de guardar
        @products = Product.order(created_at: :desc).page(params[:page]).per(5) # Agregado .per(5)
        format.html { redirect_to products_path, notice: "Producto guardado exitosamente." }
        format.json {
          render json: {
            success: true,
            message: "Producto guardado exitosamente.",
            product: @product,
            html: render_to_string(partial: "product_list", locals: { products: @products }, formats: [ :html ])
          }
        }
      else
        format.html {
          @products = Product.order(created_at: :desc).page(params[:page]).per(5) # Cambiado a 5
          render :index, status: :unprocessable_entity
        }
        format.json { render json: {
          success: false,
          errors: @product.errors.full_messages
        }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        # Recargar los productos con la página actual después de actualizar
        @products = Product.order(created_at: :desc).page(params[:page]).per(5) # Cambiado a 5
        format.html { redirect_to products_path, notice: "Producto actualizado exitosamente." }
        format.json {
          render json: {
            success: true,
            message: "Producto actualizado exitosamente.",
            product: @product,
            html: render_to_string(partial: "product_list", locals: { products: @products }, formats: [ :html ])
          }
        }
      else
        format.json { render json: {
          success: false,
          errors: @product.errors.full_messages
        }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_path, notice: "Producto eliminado exitosamente." }
      format.json {
        # Recargar los productos con la página actual después de eliminar
        @products = Product.order(created_at: :desc).page(params[:page]).per(5) # Cambiado a 5
        render json: {
          success: true,
          message: "Producto eliminado exitosamente.",
          html: render_to_string(partial: "product_list", locals: { products: @products }, formats: [ :html ])
        }
      }
    end
  end

  def index_json
    @products = Product.all.order(created_at: :desc)
    render json: @products
  end

  def search
    @products = if params[:q].present?
      Product.where("name ILIKE :search OR category ILIKE :search OR brand ILIKE :search",
                    search: "%#{params[:q]}%")
    else
      Product.all
    end.order(created_at: :desc).page(params[:page]).per(5) # Cambiado a 5

    respond_to do |format|
      format.json {
        render json: {
          html: render_to_string(partial: "product_list", locals: { products: @products }, formats: [ :html ])
        }
      }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category, :price, :brand)
  end
end
