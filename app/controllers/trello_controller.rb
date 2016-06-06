class TrelloController < ApplicationController

  before_filter :init

  def form
  end

  def search
  	@board_name   = params['board_name']
    @list_names   = params['list_names']
    @time_period  = params['time_period']    

    puts 'Starting to fetch card details'

  	@card_details = []
    @list_names.split(',').each do | list_name |
      puts "Fetching card details for board: #{@board_name}, list: #{list_name} and time: #{@time_period}"      
      @card_details.concat card_details(cards(@board_name, list_name, @time_period))
    end
    
    puts 'Card details fetched'
  end

  private

  def init
    default_list_names
    time_periods
    default_board_name
  end

  def default_list_names
    @default_list_names = ['Done','Validating Learning','Waiting to Deploy','In Review','In Progress', 'Post Release Actions', 'Wait']
  end 

  def time_periods
    @default_time_periods = ['day', 'week', 'month'] + (1..100).to_a
  end 

  def default_board_name
    @default_board_name = 'Cornetto'
  end

  def boards
  	boards = Trello::Board.all
  	boards.map { | board | board.name }
  end

  def cards(board_name, list_name, time_period)
    opts =  {cards_limit:20}
    query = "board:\"#{board_name}\" list:\"#{list_name}\" edited:#{time_period}"
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
