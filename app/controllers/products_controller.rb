# app/controllers/products_controller.rb
class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [ :create, :update, :destroy, :index_json ]
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.order(created_at: :desc).page(params[:page]).per(15)
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
        @products = Product.order(created_at: :desc).page(params[:page]).per(15)
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
          @products = Product.order(created_at: :desc).page(params[:page]).per(15)
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
        @products = Product.order(created_at: :desc).page(params[:page]).per(15)
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
        @products = Product.order(created_at: :desc).page(params[:page]).per(15)
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
    @products = Product.where("name ILIKE :search OR category ILIKE :search OR brand ILIKE :search",
                              search: "%#{params[:q]}%")
                      .order(created_at: :desc)
                      .page(params[:page]).per(15)

    render json: {
      html: render_to_string(partial: "product_list", locals: { products: @products }, formats: [ :html ])
    }
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :category, :price, :brand)
  end
end
