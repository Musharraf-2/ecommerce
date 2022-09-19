# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, except: %i[page_not_found]
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def page_not_found
    render file: Rails.root.join('/public/404.html')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[image])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[image])
  end

  private

  def user_not_authorized
    flash[:alert] = I18n.t('pundit.user_not_authorized')
    redirect_to root_path
  end

  def record_not_found
    flash[:alert] = I18n.t('pundit.record_not_found')
    redirect_to root_path
  end
end
