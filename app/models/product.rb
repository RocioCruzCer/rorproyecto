# app/models/product.rb
class Product < ApplicationRecord
  validates :name, presence: { message: "El nombre es obligatorio" }
  validates :name, length: { minimum: 3, message: "El nombre debe tener al menos 3 caracteres" }
  
  validates :category, presence: { message: "La categoría es obligatoria" }
  
  validates :price, presence: { message: "El precio es obligatorio" }
  validates :price, numericality: { 
    greater_than: 0, 
    message: "El precio debe ser mayor a 0" 
  }
  
  validates :brand, presence: { message: "La marca es obligatoria" }

  CATEGORIES = [
    'Electrónica', 'Ropa y Accesorios', 'Hogar y Muebles',
    'Deportes', 'Juguetes', 'Libros', 'Alimentos y Bebidas',
    'Belleza y Cuidado Personal', 'Automotriz', 'Mascotas'
  ].freeze

  BRANDS = [
    'Samsung', 'Apple', 'Sony', 'LG', 'Nike', 'Adidas',
    'Microsoft', 'Xiaomi', 'HP', 'Dell', 'Lenovo', 'Otros'
  ].freeze
end