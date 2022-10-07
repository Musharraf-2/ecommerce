# frozen_string_literal: true

json.product do
  json.id @product.id
  json.title @product.title
  json.price @product.price
  json.quantity @product.quantity
  json.description @product.description
  json.serial_number @product.serial_number
  json.comments @product.comments do |comment|
    json.id comment.id
    json.body comment.body
    json.user_email comment.user.email
  end
  json.images_path @product.images do |image|
    json.image_path rails_blob_url(image)
  end
end
