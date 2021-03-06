require_relative "./battleship"
require "colorize"

class Game

  attr_reader :user, :auto, :turn_counter, :turn_coord

  def initialize(user, auto)
    @user = user
    @auto = auto
    @turn_counter = 0
    @turn_coord = nil
  end

  def start
    main_menu
    players_setup_ships
    until winner != nil
      print display_board
      fire_coordinate(@user)
      fire_coordinate(@auto)
    end
    end_game
  end

  def display_board
    message_turn
    message_computer_display
    message_player_display
  end

  def fire_coordinate(declarer)
    case declarer
    when @user
      # message_user_input
      fire(@user, message_user_input)
    when @auto
      fire(@auto, auto_generate_single_coordinate)
    end
  end

  # ============ HELPERS FOR START ============

  def players_setup_ships
    print message_computer_display
    print message_player_display
    @auto.ship_setup
    puts "\nI have laid out my ships on the grid.\n" + "You".magenta + " now need to lay out your two ships.\n\nThe" + " Cruiser ".red + "is " + "three ".red + "coordinates long.\nThe " + "Submarine ".blue + "is " + "two ".blue + "coordinates long."
    @user.ship_setup
  end


  # ============================================

  # ============ HELPERS FOR DISPLAY ============
  def message_turn
    @turn_counter += 1
    print "~~~~~~~~~~~~~ TURN ##{@turn_counter} ~~~~~~~~~~~~~\n"
  end

  def message_computer_display
    print "=============COMPUTER BOARD=============\n"
    @auto.board.render
  end

  def message_player_display
    print "==============PLAYER BOARD==============\n"
    @user.board.render(true)
  end
  # ============================================

  # ============ HELPERS FOR FIRE COORDINATE ============


  def fire(declarer, coordinate)
    if declarer == @user
      @auto.board.cells[coordinate].fire_upon
      print "Your shot on #{coordinate} was a #{@auto.board.cells[coordinate].render}\n"
    elsif declarer == @auto
      @user.board.cells[coordinate].fire_upon
      print "May C. Puter's shot on #{coordinate} was a #{@user.board.cells[coordinate].render}\n"
    end
  end


  def print_welcome_to_battleship
      puts "                                                                                 ".magenta
      puts "  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____  ".magenta
      puts "                                                                                 ".magenta
      puts "                                                                                 ".magenta
      puts "                                                                                 ".magenta
      puts "        *******************~~~~~~~~~~~~~~~~~~~~~~~~~~~~*******************       ".magenta
      puts "  ************~~~~~~~~~~~~~~~ WELCOME TO BATTLESHIP ~~~~~~~~~~~~~~~************  ".magenta
      puts "        *******************~~~~~~~~~~~~~~~~~~~~~~~~~~~~*******************       ".magenta
      puts "                                                                                 ".magenta
      puts "                                BY ARIQUE & PRIYA                                ".magenta
      puts "                                                                                 ".magenta
      puts " _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____   ".magenta
      puts "                                                                                 ".magenta
  end

  def main_menu
    print_welcome_to_battleship
    print "Enter p to play. Enter q to quit. > "
    response = gets.chomp.downcase[0]
    if response == "p"
      puts "Let's play!"
    elsif response == "q"
      puts "See you next time!"
      leave_game
    else
      puts "Invalid entry. Bye!"
      leave_game
    end
  end

  def message_user_input
    p "Enter the coordinate for your shot"
    print "> "
    @turn_coord = gets.chomp.upcase[0..1]
    checking_user_coordinates
    if @auto.board.cells[@turn_coord].fired_upon?
      message_error_fired_upon
    else
      checking_user_coordinates
    end
    @turn_coord
  end

  def message_error_fired_upon
    until @auto.board.cells[@turn_coord].fired_upon? == false
      p "MISFIRE! You are trying to fire on a cell that you have already fired upon! Please try again!"
      print "> "
      @turn_coord = gets.chomp.upcase[0..1]
      if @auto.board.cells[@turn_coord] == nil
        message_error_user_input
      end
    end
  end

  def leave_game
    exit
  end

  def winner
    if @auto.ships.sum {|ship| ship.health } == 0
      you_won_banner
      end_game
    elsif @user.ships.sum { |ship| ship.health } == 0
      i_won_banner
      end_game
    else
      nil
    end
  end

  def you_won_banner
    puts "                                                                                 ".magenta
    puts "  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____  ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "            **************~~~~~~~~~~~~~~~~~~~~~~~~~~~~~**************            ".magenta
    puts "        ************~~~~~~~~~~~~~~~ YOU WON! ~~~~~~~~~~~~~~~************         ".magenta
    puts "            **************~~~~~~~~~~~~~~~~~~~~~~~~~~~~~**************            ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts " _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____   ".magenta
    puts "                                                                                 ".magenta
  end

  def i_won_banner
    puts "                                                                                 ".magenta
    puts "  _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____  ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "            **************~~~~~~~~~~~~~~~~~~~~~~~~~~~~~**************            ".magenta
    puts "        ************~~~~~~~~~~~~~~~  I WON!  ~~~~~~~~~~~~~~~************         ".magenta
    puts "            **************~~~~~~~~~~~~~~~~~~~~~~~~~~~~~**************            ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts "                                                                                 ".magenta
    puts " _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____ _____   ".magenta
    puts "                                                                                 ".magenta
  end

  def end_game
    battleship = Battleship.new
    main_menu
  end

  def checking_user_coordinates
    loop do
      message_error_user_input
      valid_user_coordinate?(@turn_coord)
    break if (valid_user_coordinate?(@turn_coord) == true)
    end
  end

  def message_error_user_input
    until valid_user_coordinate?(@turn_coord)
      p "You have input invalid coordinates for your board. Please try again."
      print "> "
      @turn_coord = gets.chomp.upcase[0..1]
    end
  end

  def valid_user_coordinate?(coordinate)
    @user.board.valid_coordinate?(@turn_coord)
  end

  def auto_generate_single_coordinate
    next_hit = @user.board.cells.find_all do |cell|
      cell[1].fired_upon? == false
    end
    next_hit.shuffle[0][0]
  end
  # ====================================================

end
