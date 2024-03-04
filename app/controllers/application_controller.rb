class ApplicationController < ActionController::Base
  def home
    redirect_to games_path if session[:player1] && session[:player2]
  end
end
