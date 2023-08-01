# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def help
    redirect_to root_path
  end

  def language_change
    redirect_to root_path
  end
end
