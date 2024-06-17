class Product < ApplicationRecord
  has_many :order_items
  has_many :orders, through: :order_items

  has_many_attached :images do |attachable|
    attachable.variant :thumb, resize_to_limit: [50, 50], preprocessed: true
    attachable.variant :small, resize_to_limit: [300, 300], preprocessed: true
  end

  # Método para obtener la imagen predeterminada en miniatura
  def default_thumb
    if images.attached?
      images.first.variant(:thumb)
    else
      'assets/default_thumb.jpg' # Ruta de tu miniatura predeterminada
    end
  end

  # Método para obtener la imagen predeterminada en tamaño pequeño
  def default_small
    if images.attached?
      images.first.variant(:small)
    else
      'assets/default_small.jpg' # Ruta de tu imagen predeterminada en tamaño pequeño
    end
  end
end
