class TrelloController < ApplicationController
  def form
  	@boards = boards
  end

  def search
  	@board_name = params['board_name']
  	@boards = boards  	
  end

  private
  def boards
  	boards = Trello::Board.all
  	boards.map { | board | board.name }
  end
end
