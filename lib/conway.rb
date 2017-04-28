# frozen_string_literal: true

# require_relative 'lib/conway.rb'
# x = Game.new(cols, rows ,'acorn | pento | rabbit | random_%').play
# x = Game.new(40,30,'acorn').play

# x.play

# Game class
class Game
  # initialize game
  def initialize(cols, rows, mode)
    @cols = cols
    @rows = rows
    @board = Array.new(@rows) { Array.new(@cols, 0) }
    init_board(mode)
    self
  end

  # initialize board with specified pattern
  def init_board(mode)
    if mode.is_a? String
      # draw the pattern
      init_pattern(mode)
    elsif mode.is_a? Numeric
      # seed with a random pattern of mode %
      fill_random(mode)
    else
      # seed with a random pattern of 25 %
      fill_random(25)
    end
  end

  # render one of the pre-defined patterns
  def init_pattern(mode)
    if mode == 'acorn'
      fill_pattern([[-1, -2], [0, 0], [1, -3], [1, -2], [1, 1], [1, 2], [1, 3]])
    elsif mode == 'pento'
      fill_pattern([[-1, 0], [-1, 1], [0, -1], [0, 0], [1, 0]])
    elsif mode == 'rabbit'
      fill_pattern([[-1, -3], [0, -3], [0, -2], [0, -1], [1, -2], [1, 1],
                    [1, 2], [1, 3], [0, 2]])
    else
      fill_random(25)
    end
  end

  # fill in cells with seed pattern
  def fill_pattern(cells)
    c = @cols / 2
    r = @rows / 2
    cells.each { |cell| @board[cell[0] + r][cell[1] + c] = 1 }
  end

  # initialize the board with p% random cells
  def fill_random(percent)
    @board.each_with_index do |r, ri|
      r.each_with_index do |_c, ci|
        # set some percent of cells to 1 (live)
        @board[ri][ci] = rand(100) > percent ? 0 : 1
      end
    end
  end

  # loop through the board until a done state exists
  def play
    done = false
    done = check_board until done
  end

  # check the status of each cell on the board
  def check_board
    # @last = @board
    done = false
    draw_board
    turn = Array.new(@rows) { Array.new(@cols, 0) }
    turn.each_with_index do |r, ri|
      # check new status for each cell and store in next_board array
      r.each_with_index { |_c, ci| turn[ri][ci] = check_square(ri, ci) }
    end

    turn == @board ? done = true : @board = turn
    done
  end

  # draw the game board for each turn
  def draw_board
    puts `clear`
    draw_horiz_border
    @board.each do |row|
      print '+'
      row.each { |col| print col == 1 ? 'o ' : '  ' }
      print "+\n"
    end
    draw_horiz_border
    sleep(1.0 / 8.0)
  end

  # draw the horizontal border for the top and bottom of the game board
  def draw_horiz_border
    (@cols + 1).times { print '+ ' }
    print "\n"
  end

  # check the number of neighbors for a cell
  def check_square(r, c)
    n = 0
    bounds = get_bounds(r, c)

    (bounds[:r_min]..bounds[:r_max]).each do |ri|
      (bounds[:c_min]..bounds[:c_max]).each do |ci|
        n += @board[ri][ci] unless ri == r && ci == c
      end
    end

    live_or_die(n, r, c)
  end

  # get the min/max bounds of cells to check on edges of the game board
  def get_bounds(r, c)
    {
      r_min: r <= 0 ? 0 : r - 1,
      r_max: r >= @rows - 1 ? @rows - 1 : r + 1,
      c_min: c <= 0 ? 0 : c - 1,
      c_max: c >= @cols - 1 ? @cols - 1 : c + 1
    }
  end

  # check whether the cell lives or dies
  def live_or_die(n, row, col)
    dead = @board[row][col].zero?
    (n == 3 && dead) || ((n == 2 || n == 3) && !dead) ? 1 : 0
  end
end

# require_relative 'lib/conway.rb'
puts "x = Game.new(cols, rows ,'acorn | pento | rabbit | random_%').play"
# x = Game.new(88,46,25).play
# x = Game.new(40,30,'rabbit').play
