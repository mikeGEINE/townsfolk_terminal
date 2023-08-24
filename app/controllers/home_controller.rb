# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :validate_rights!, except: %i[approve]
  layout 'simple', only: %i[approve base]

  def index; end

  def help
    redirect_to root_path
  end

  def language_change
    redirect_to root_path
  end

  # TODO: This controller needs a rework. Separate basic pages from Terminal pages

  def approve; end

  def base; end
end
