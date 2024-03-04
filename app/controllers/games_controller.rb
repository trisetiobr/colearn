# frozen_string_literal: true

# Controller to handle of tic tac toe game
class GamesController < ApplicationController
  include GameHelper

  before_action :check_session, except: %i[create]

  def create
    if valid_players?
      initialize_game_session
      redirect_to games_path
    else
      redirect_to root_path
    end
  end

  def move
    if invalid_move?
      flash[:game_alert] = 'Invalid move, please try again.'
    else
      make_move
      handle_winner
    end

    redirect_to games_path
  end

  def delete
    reset_session
    redirect_to root_path
  end

  private

  def validate_player1_field
    if params[:player1].blank?
      flash[:alert_player1] = 'Player 1 name is missing'
      return false
    end

    if params[:player1].length > 32
      flash[:alert_player1] = 'Player 1 maximum character is 32'
      return false
    end

    true
  end

  def validate_player2_field
    if params[:player2].blank?
      flash[:alert_player2] = 'Player 2 name is missing'
      return false
    end

    if params[:player2].length > 32
      flash[:alert_player2] = 'Player 2 maximum character is 32'
      return false
    end

    true
  end

  def check_session
    redirect_to root_path unless game_started?
  end
end
