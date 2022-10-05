# frozen_string_literal: true

module Api
  module V1
    class ProductsController < ApplicationController
      skip_before_action :authenticate_user!

      def index
        @products = Product.all
      end

      def show
        @product = Product.includes(:comments).find(params[:id])
      end
    end
  end
end
