# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username image])
  end

  private

  def user_not_authorized
    flash[:alert] = 'You are not authorized to to perform this action.'
    redirect_to root_path
  end

  def record_not_found
    flash[:alert] = 'The record you are asking does not exists.'
    redirect_to root_path
  end
end
