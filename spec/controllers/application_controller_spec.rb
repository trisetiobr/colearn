# spec/controllers/application_controller_spec.rb

require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#home" do
    context "when game has started" do
      it "redirects to games_path" do
        allow(subject).to receive(:game_started?).and_return(true)
        get :home
        expect(response).to redirect_to(games_path)
      end
    end

    context "when game has not started" do
      it "renders the home template" do
        allow(subject).to receive(:game_started?).and_return(false)
        get :home
        expect(response).to render_template(:home)
      end
    end
  end
end
