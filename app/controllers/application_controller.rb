# frozen_string_literal: true

class ApplicationController < ActionController::Base
  around_action :switch_locale
  layout :layout_by_resource
  before_action :authenticate_user!

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_view_rooms_path
    else
      root_path
    end
  end

  private

  def layout_by_resource
    if devise_controller?
      'simple'
    else
      'application'
    end
  end

  def validate_rights!
    redirect_to approve_path if current_user.inactive?
  end
end
