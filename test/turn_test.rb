require "minitest/autorun"
require "minitest/pride"
require "./lib/ship"
require "./lib/board"
require "./lib/player"
require "./lib/turn"

class TurnTest < Minitest::Test

  def setup
    # 1-s are auto
    # 2-s are user input
    @board1 = Board.new
    @board1.generate_cells
    @board2 = Board.new
    @board2.generate_cells
    @cruiser1 = Ship.new("Cruiser", 3)
    @submarine1 = Ship.new("Submarine", 2)
    @cruiser2 = Ship.new("Cruiser", 3)
    @submarine2 = Ship.new("Submarine", 2)
    @player1 = Player.new(:auto, @board1)
    @player2 = Player.new(:user, @board2)
    @turn_user = Turn.new(@player2)
  end

  def test_it_exists
    assert_instance_of Turn, @turn_user
  end

  def test_it_has_attributes
    assert_equal @player2, @turn_user.player
  end

  # when turn called, it should print to terminal :auto board (render default false) and :user board (render parameter set to true)
  def test_auto_and_user_boards_print_to_terminal
    expected1 = "  1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n"
    expected2 = "  1 2 3 4 \nA S S S . \nB . . . . \nC . . . . \nD . . . . \n"
    @player1.ship_setup
    assert_equal expected1, @turn_user.display_board
  end


  # AFTER print to terminal occurs (this looop behavior could occur in game "start" loop)

  # user input of coord (singular)
    # GUARD: user error input of more than one coord or invalid coord
    # auto input of coord created from this?

  # shoot behavior (results in hit, miss, or sunk)

  # print result of both :auto and :user

  # MUST RECORD RESULT TO BOARD FOR NEW RENDER (in next turn)

end