class Slide < ApplicationRecord
  has_one_attached :image
  
  validates :title, presence: true, length: { maximum: 100 }
  validate :validate_image
  
  private
  
  def validate_image
    return unless image.attached?
    
    # Validar tipo de archivo
    allowed_types = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp']
    unless allowed_types.include?(image.content_type)
      errors.add(:image, "debe ser una imagen (JPEG, PNG, GIF, WebP)")
    end
    
    # Validar tamaño (máximo 5MB)
    max_size = 5.megabytes
    if image.byte_size > max_size
      errors.add(:image, "es demasiado grande (máximo 5MB)")
    end
  end
end