# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        @products = Product.all
        render json: @products.map { |product|
                       product.as_json.merge(
                         image_spath: url_for(product.images[0])
                       )
                     }
      end

      def show
        @product = Product.find(params[:id])
        render json: @product.as_json.merge(
          images_path: get_images_url(@product.images),
          comments: @product.comments
        )
      end

      private

      def get_images_url(images)
        images_url = []
        images.each do |image|
          images_url << url_for(image)
        end
        images_url
      end
    end
  end
end
