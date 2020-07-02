class ProductFavorite < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :product_id, uniqueness: { scope: :user_id,
    message: "Este producto ya existe en sus favoritos" }
end
