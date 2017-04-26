# frozen_string_literal: true

require 'pry'

# Game class
class Game
  # initialize game
  def initialize(cols, rows, mode)
    @cols = cols
    @rows = rows
    @board = Array.new(@rows) { Array.new(@cols, 0) }

    init_seeds
    init_pattern(mode)
    check_board
  end

  # initialize pattern seeds
  def init_seeds
    @acorn = [[-1, -2], [0, 0], [1, -3], [1, -2], [1, 1], [1, 2], [1, 3]]
    @pento = [[-1, 0], [-1, 1], [0, -1], [0, 0], [1, 0]]
    @rabbit = [[-1, -3], [0, -3], [0, -2], [0, -1], [1, -2], [1, 1],
               [1, 2], [1, 3], [0, 2]]
  end

  # initialize board with specified pattern
  def init_pattern(mode)
    if mode == 'acorn'
      pattern_init(@acorn)
    elsif mode == 'pento'
      pattern_init(@pento)
    elsif mode == 'rabbit'
      pattern_init(@rabbit)
    else
      # seed with a random pattern
      random_init(25)
    end
  end

  # fill in cells with seed pattern
  def pattern_init(cells)
    c = @cols / 2
    r = @rows / 2
    cells.each { |cell| @board[cell[0] + r][cell[1] + c] = 1 }
  end

  # initialize the board with p% random cells
  def random_init(p)
    @board.each_with_index do |r, ri|
      r.each_with_index do |_c, ci|
        @board[ri][ci] = rand(100) > p ? 0 : 1
      end
    end
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

  # check the status of each cell on the board
  def check_board
    done = false

    until done
      draw_board
      next_board = Array.new(@rows) { Array.new(@cols, 0) }
      next_board.each_with_index do |r, ri|
        r.each_with_index { |_c, ci| next_board[ri][ci] = check_square(ri, ci) }
      end

      next_board == @board ? done = true : @board = next_board
    end
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

  # check the number of neighbors for a cell
  def check_square(r, c)
    # initialize number of neibhors
    n = 0
    bounds = get_bounds(r, c)

    (bounds[:r_min]..bounds[:r_max]).each do |row|
      (bounds[:c_min]..bounds[:c_max]).each do |col|
        n += @board[row][col] unless row == r && col == c
      end
    end

    live_or_die(n, r, c)
  end

  # check whether the cell lives or dies
  def live_or_die(n, row, col)
    dead = @board[row][col].zero?
    (n == 3 && dead) || ((n == 2 || n == 3) && !dead) ? 1 : 0
  end
end

# x = Game.new(cols, rows ,'acorn | pento | rabbit | random')
# x = Game.new(88,46,'random')
# x = Game.new(40,30,'rabbit')
binding.pry
''
