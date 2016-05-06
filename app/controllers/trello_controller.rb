class TrelloController < ApplicationController
  def form
  	@boards = boards
  end

  def search
  	@board_name   = params['board_name']
  	@card_details = card_details(cards(@board_name))
  	puts @card_details
  	@boards = boards  	
  end

  private
  def boards
  	boards = Trello::Board.all
  	boards.map { | board | board.name }
  end

  def cards(board_name)
    opts =  {cards_limit:4}
    query = "board:\"#{board_name}\" edited:week"
    Trello::Action.search(query,opts)['cards']
  end

  def card_details(cards)
    card_details = []
	cards.each do | card |
		output = {list: card.list.name, name: card.name, members: card.members.map(&:full_name), url: card.url, text: card.desc, archived: card.closed?, last_modified: card.last_activity_date}
		card_details << output
	end

	card_details
  end
end
