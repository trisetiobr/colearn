# app/controllers/games_controller.rb
class GamesController < ApplicationController
  before_action :check_session,  except: %i[create]

  def index
  end

  def create
    valid = validate_player1_field && validate_player2_field

    if valid
      session[:player1] = params[:player1]
      session[:player2] = params[:player2]
      session[:current_move] = 1
      session[:board] = Array.new(3) { Array.new(3, '') }
      redirect_to games_path
    else
      redirect_to root_path
    end
  end

  def move
    if params[:grid_x].blank? || params[:grid_y].blank?
      flash[:game_alert] = 'Player still not select a move'
    elsif params[:player_move].to_i != session[:current_move]
      flash[:game_alert] = 'Invalid move, please try again'
    elsif session[:board][params[:grid_y].to_i][params[:grid_x].to_i].present?
      flash[:game_alert] = 'Invalid move, please try again'
    else
      session[:board][params[:grid_y].to_i][params[:grid_x].to_i] = session[:current_move]
      if session[:current_move] == 1
        session[:current_move] = 2
      else
        session[:current_move] = 1
      end

      winner = check_winner

      if winner.present?
        session[:winner] = winner
      else
        flash[:game_alert] = 'Success to move'
      end
    end

    redirect_to games_path
  end

  def check_winner
    board = session[:board]

    board.each do |row|
      return row[0] if row.uniq.size == 1 && row[0] != ''
    end

    board.transpose.each do |col|
      return col[0] if col.uniq.size == 1 && col[0] != ''
    end

    if (0...board.size).all? { |i| board[i][i] == board[0][0] } && board[0][0] != ''
      return board[0][0]
    elsif (0...board.size).all? { |i| board[i][board.size - 1 - i] == board[0][board.size - 1] } && board[0][board.size - 1] != ''
      return board[0][board.size - 1]
    end

    return nil
  end

  def delete
    reset_session
    redirect_to root_path
  end

  private

  def validate_player1_field
    if params[:player1].blank?
      flash[:alert_player1] = "Player 1 information missing"
      return false
    end

    if params[:player1].length > 32
      flash[:alert_player1] = "Player 1 maximum character is 32"
      return false
    end

    true
  end

  def validate_player2_field
    if params[:player2].blank?
      flash[:alert_player2] = "Player 2 information missing"
      return false
    end

    if params[:player2].length > 32
      flash[:alert_player2] = "Player 2 maximum character is 32"
      return false
    end

    true
  end

  def check_session
    redirect_to root_path unless has_session?
  end

  def has_session?
    session[:player1] && session[:player2]
  end
end
