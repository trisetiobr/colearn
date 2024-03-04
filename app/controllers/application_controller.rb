# frozen_string_literal: true

# Base controller of this rails application
class ApplicationController < ActionController::Base
  include GameHelper

  def home
    redirect_to games_path if game_started?
  end
end
