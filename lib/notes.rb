# class

require 'pry'

class Game
  def initialize(size)
    @size = size
    @board = Array.new(@size) { Array.new(@size, random_init(20)) }
    puts @board
    checkBoard # run perpetually until empty
  end

  def random_init(p)
    # return a 1 p percent of the time
    num = rand * 100

    if num < p
      puts "#{p} of #{num} = #{result}"
      result = true
    else
      puts "#{p} of #{num} = #{result}"
      result = false
    end

    result
  end

  def checkBoard
    @temp_board = @board # copy not reference
     @temp_board.each_with_index do |x, xi|
      x.each_with_index do |y, yi|
        @temp_board[xi][yi] = checkSquare(xi, yi)
      end
    end

    @board = @temp_board

    # if any square on the board is true
    # if @board.any? { true }
    #   checkBoard
    # end
  end

  def checkSquare(x,y)
    # get score
    if x > 0
      x_min = x - 1
    else
      x_min = 0
    end

    if x < @size - 1
      x_max = x + 1
    else
      x_max = @size - 1
    end

    if y > 0
      y_min = y - 1
    else
      y_min = 0
    end

    if y < @size - 1
      y_max = y + 1
    else
      y_max = @size - 1
    end

    n = 0

    (x_min..x_max).each do |col|
      (y_min..y_max).each do |row|
        # puts x, y
        # if not center, check is alive
        if (col != x && row != y) && @board[col][row] == true
          n += 1
        end
      end
    end

    # total neighbors = n
    # don't return total, evaluate against rules & return T or F
    result = handle_result(n, x, y)
    result
  end

  def handle_result(n, x, y)
    live = @board[x][y]

    if n < 2 && live
      false
    elsif n > 3 && live
      false
    elsif (n == 2 || n == 3) && live
      true
    elsif n == 3 && !live
      true
    end
  end
end

binding.pry
''
