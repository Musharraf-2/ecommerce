# frozen_string_literal: true

json.array! @products do |product|
  json.id product.id
  json.title product.title
  json.price product.price
  json.quantity product.quantity
  json.image_path rails_blob_url(product.images[0])
end
