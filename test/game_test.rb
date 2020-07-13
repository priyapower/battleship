require "minitest/autorun"
require "minitest/pride"
require "./lib/ship"
require "./lib/board"
require "./lib/player"
require "./lib/game"

class GameTest < Minitest::Test

  def setup
    @auto_cruiser = Ship.new("Cruiser", 3)
    @auto_submarine = Ship.new("Submarine", 2)
    @user_cruiser = Ship.new("Cruiser", 3)
    @user_submarine = Ship.new("Submarine", 2)

    @auto_board = Board.new
    @auto_board.generate_cells
    @user_board = Board.new
    @user_board.generate_cells

    @auto = Player.new(:auto, @auto_board)
    @user = Player.new(:user, @user_board)

    @auto.add_ship(@auto_cruiser)
    @auto.add_ship(@auto_submarine)
    @user.add_ship(@user_cruiser)
    @user.add_ship(@user_submarine)

    @auto.board.place(@user_cruiser, ["B1", "C1", "D1"])
    @auto.board.place(@user_submarine, ["A1", "A2"])
    @user.board.place(@user_cruiser, ["A1", "A2", "A3"])
    @user.board.place(@user_submarine, ["C3", "D3"])
    @game = Game.new(@user, @auto)
  end

  def test_it_exists
    skip
    assert_instance_of Game, @game
  end

  def test_it_has_attributes
    skip
    assert_equal @user, @game.user
    assert_equal @auto, @game.auto
  end

  def test_it_can_print_both_auto_and_user_boards_to_terminal
    skip
    expected1 = "~~~~~~~~~~~~~ TURN #1 ~~~~~~~~~~~~~\n=============COMPUTER BOARD=============\n 1 2 3 4 \nA . . . . \nB . . . . \nC . . . . \nD . . . . \n==============PLAYER BOARD==============\n 1 2 3 4 \nA S S S . \nB . . . . \nC . . S . \nD . . S . \n"
    assert_equal expected1, @game.display_board
  end

  def test_it_can_shoot
    skip
      # attempt to fire on A1
      # produce computer A1 = H
    @game.fire(@user, "A1")
    assert_equal true, @game.auto.board.cells["A1"].fired_upon?

    # attempt to fire on C3
    # produce computer C3 = M
    # attempt to fire on B1, C1, D1
    # produce computer B1, C1, D1 = X

  end

  def test_DEBUG_board_renders_shot_behavior_for_testing
    skip
    skip
    expected2 = "~~~~~~~~~~~~~ TURN #1 ~~~~~~~~~~~~~\n=============COMPUTER BOARD=============\n 1 2 3 4 \nA H . . . \nB . . . . \nC . . . . \nD . . . . \n==============PLAYER BOARD==============\n 1 2 3 4 \nA S S S . \nB . . . . \nC . . S . \nD . . S . \n"

    # attempt to fire on A1
      # produce computer A1 = H

    # attempt to fire on C3
      # produce computer C3 = M

    # attempt to fire on B1, C1, D1
      # produce computer B1, C1, D1 = X

  end

  def test_it_has_a_main_menu
    skip
    #does print to the screen as expected
    expected = "Welcome to BATTLESHIP
Enter p to play. Enter q to quit."

    assert_equal expected, @game.main_menu

  end

  def test_it_has_a_set_up_ships
    skip
    auto_cruiser = Ship.new("Cruiser", 3)
    auto_submarine = Ship.new("Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)

    auto_board = Board.new
    auto_board.generate_cells
    user_board = Board.new
    user_board.generate_cells

    auto = Player.new(:auto, auto_board)
    user = Player.new(:user, user_board)

    auto.add_ship(auto_cruiser)
    auto.add_ship(auto_submarine)
    user.add_ship(user_cruiser)
    user.add_ship(user_submarine)
    game = Game.new(user, auto)

    assert_equal nil, game.players_setup_ships
  end

  def test_it_can_determine_winner
    auto_cruiser = Ship.new("Cruiser", 3)
    auto_submarine = Ship.new("Submarine", 2)
    user_cruiser = Ship.new("Cruiser", 3)
    user_submarine = Ship.new("Submarine", 2)

    auto_board = Board.new
    auto_board.generate_cells
    user_board = Board.new
    user_board.generate_cells

    auto = Player.new(:auto, auto_board)
    user = Player.new(:user, user_board)

    auto.add_ship(auto_cruiser)
    auto.add_ship(auto_submarine)
    user.add_ship(user_cruiser)
    user.add_ship(user_submarine)
    game = Game.new(user, auto)

    auto.board.place(user_cruiser, ["B1", "C1", "D1"])
    auto.board.place(user_submarine, ["A1", "A2"])
    user.board.place(user_cruiser, ["A1", "A2", "A3"])
    user.board.place(user_submarine, ["C3", "D3"])


    assert_equal false, game.check_ships_sunk?(user)
    assert_equal false, game.check_ships_sunk?(auto)
    assert_equal false, game.winner?

    game.user.ships[0].hit
    game.user.ships[0].hit
    game.user.ships[0].hit

    assert_equal 0, user.ships[0].health

    game.user.ships[1].hit
    game.user.ships[1].hit
    
    assert_equal 0, user.ships[1].health

    assert_equal true, game.check_ships_sunk?(user)
    assert_equal false, game.check_ships_sunk?(auto)
    assert_equal true, game.winner?

    #update with game.fire method to fully test functionality
  end

end
