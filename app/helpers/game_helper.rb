# frozen_string_literal: true

# Module to provide helper for game tic tac toe functionality
module GameHelper
  def valid_players?
    validate_player1_field && validate_player2_field
  end

  def initialize_game_session
    session[:player1] = params[:player1]
    session[:player2] = params[:player2]
    session[:current_move] = 1
    session[:board] = Array.new(3) { Array.new(3, '') }
  end

  def invalid_move?
    params[:grid_x].blank? || params[:grid_y].blank? ||
      params[:player_move].to_i != session[:current_move] ||
      cell_already_filled?
  end

  def cell_already_filled?
    board[params[:grid_y].to_i][params[:grid_x].to_i].present?
  end

  def make_move
    board[params[:grid_y].to_i][params[:grid_x].to_i] = session[:current_move]
    switch_current_move
  end

  def switch_current_move
    session[:current_move] = session[:current_move] == 1 ? 2 : 1
  end

  def handle_winner
    session[:winner] = check_winner
    flash[:game_alert] = 'Move successful.' unless session[:winner].present?
  end

  def board
    session[:board]
  end

  def game_started?
    session[:player1] && session[:player2]
  end

  def check_winner
    check_rows || check_columns || check_diagonals || check_draw
  end

  def check_draw
    return 'draw' if board.flatten.none?(&:blank?)

    nil
  end

  def check_rows
    board.each do |row|
      return row[0] if row.uniq.size == 1 && row[0] != ''
    end

    nil
  end

  def check_columns
    board.transpose.each do |col|
      return col[0] if col.uniq.size == 1 && col[0] != ''
    end

    nil
  end

  def check_diagonals
    diagonal_winner || anti_diagonal_winner
  end

  def diagonal_winner
    first_cell = board[0][0]
    return nil if first_cell == ''

    (0...board.size).all? { |i| board[i][i] == first_cell } ? first_cell : nil
  end

  def anti_diagonal_winner
    last_cell = board[0][board.size - 1]
    return nil if last_cell == ''

    (0...board.size).all? { |i| board[i][board.size - 1 - i] == last_cell } ? last_cell : nil
  end
end
