# spec/controllers/games_controller_spec.rb

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  let(:valid_session) { { player1: 'Player 1', player2: 'Player 2', current_move: 1 } }

  describe "POST #create" do
    context "with valid players" do
      it "initializes the game session and redirects to games_path" do
        post :create, params: { player1: 'Player 1', player2: 'Player 2' }
        expect(session[:player1]).to eq('Player 1')
        expect(session[:player2]).to eq('Player 2')
        expect(session[:current_move]).to eq(1)
        expect(session[:board]).to eq([['', '', ''], ['', '', ''], ['', '', '']])
        expect(response).to redirect_to(games_path)
      end
    end

    context "board max size 20" do
      before do
        allow(Rails.application.config).to receive(:board_size).and_return(100)
      end

      it "initializes board size equals to 5" do
        post :create, params: { player1: 'Player 1', player2: 'Player 2' }
        expect(session[:board].length).to eq(20)
        expect(session[:board][0].length).to eq(20)
      end
    end

    context "board size = 5" do
      before do
        allow(Rails.application.config).to receive(:board_size).and_return(5)
      end

      it "initializes board size equals to 5" do
        post :create, params: { player1: 'Player 1', player2: 'Player 2' }
        expect(session[:board].length).to eq(5)
        expect(session[:board][0].length).to eq(5)
      end
    end

    context "board minimum size 3" do
      before do
        allow(Rails.application.config).to receive(:board_size).and_return(3)
      end

      it "initializes board size equals to 5" do
        post :create, params: { player1: 'Player 1', player2: 'Player 2' }
        expect(session[:board].length).to eq(3)
        expect(session[:board][0].length).to eq(3)
      end
    end

    context "with invalid players" do
      it "missing player 1 name" do
        post :create, params: { player1: '', player2: 'Player 2' }
        expect(response).to redirect_to(root_path)
      end

      it "invalid player 1 name length" do
        post :create, params: { player1: "#{SecureRandom.uuid}#{SecureRandom.uuid}", player2: 'Player 2' }
        expect(response).to redirect_to(root_path)
      end

      it "missing player 2 name" do
        post :create, params: { player1: 'Player 1', player2: '' }
        expect(response).to redirect_to(root_path)
      end

      it "invalid player 2 name length" do
        post :create, params: { player1: 'Player 1', player2: "#{SecureRandom.uuid}#{SecureRandom.uuid}"}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "DELETE #delete" do
    before do
      session.merge!(valid_session)
      session[:board] = [['O', '', ''], ['', '', ''], ['', '', '']]
    end

    it "reset the game and redirect to root path" do
      delete :delete, params: { grid_x: 0, grid_y: 0, player_move: 1 }
      expect(session[:board]).to eq(nil)
      expect(session[:player1]).to eq(nil)
      expect(session[:player2]).to eq(nil)
      expect(session[:winner]).to eq(nil)
      expect(session[:current_move]).to eq(nil)
      expect(response).to redirect_to(root_path)
    end
  end

  describe "POST #move" do
    before do
      session.merge!(valid_session)
      session[:board] = [['', '', ''], ['', '', ''], ['', '', '']]
    end

    context "with valid move" do
      it "updates the game board and handles winner" do
        post :move, params: { grid_x: 0, grid_y: 0, player_move: 1 }
        expect(session[:board][0][0]).to eq(1)
        # Add more expectations for handling winner
        expect(response).to redirect_to(games_path)
      end
    end

    context "player 1 win the game" do
      before do
        session.merge!(valid_session)
        session[:board] = [['', '', ''], ['', 1, 2], [1, 2, '']]
      end

      it "updates the game board and win a game" do
        post :move, params: { grid_x: 2, grid_y: 0, player_move: 1 }
        expect(session[:winner].present?).to eq(true)
        expect(session[:winner]).to eq(1)
      end
    end

    context "player 2 win the game" do
      before do
        session.merge!(valid_session)
        session[:current_move] = 2
        session[:board] = [[2, 2, ''], [1, 1, ''], [1, '', '']]
      end

      it "updates the game board and win a game" do
        post :move, params: { grid_x: 2, grid_y: 0, player_move: 2 }
        expect(session[:winner]).to eq(2)
      end
    end

    context "draw the game" do
      before do
        session.merge!(valid_session)
        session[:current_move] = 2
        session[:board] = [[2, 1, ''], [2, 1, 2], [1, 2, 1]]
      end

      it "updates the game board and draw the game" do
        post :move, params: { grid_x: 2, grid_y: 0, player_move: 2 }
        expect(session[:winner]).to eq('draw')
      end
    end

    context "with invalid move" do
      it "sets flash alert and redirects to games_path" do
        post :move, params: { grid_x: 0, grid_y: 0, player_move: 2 }
        expect(flash[:game_alert]).to eq('Invalid move, please try again.')
        expect(response).to redirect_to(games_path)
      end
    end
  end

  describe "DELETE #delete" do
    it "resets the session and redirects to root_path" do
      delete :delete
      expect(session).to be_empty
      expect(response).to redirect_to(root_path)
    end
  end
end
