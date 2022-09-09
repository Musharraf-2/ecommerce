# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :initialize_cart

  protected

  def initialize_cart
    session[:cart] ||= []
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username image])
  end
end
