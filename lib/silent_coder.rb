
class Game
  def initialize(size)
    @size = size
    @board = Array.new(10) { Array.new(10, false) }
  end

  def checkBoard
    @temp_board = @board # copy not reference
     @temp_board.each_with_index do |x, xi|
      x.each_with_index do |y, yi|
        @temp_board[xi][yi] = checkSquare(xi, yi)
      end
    end
  end

  def checkSquare(x,y)
    # get score
    if x > 0
      x_min = x - 1
    else
      x_min = 0

    if x < size - 1
      x_max = x + 1
    else
      x_max = size - 1

    if y > 0
      y_min = y - 1
    else
      y_min = 0

    if y < size - 1
      y_max = y + 1
    else
      y_max = size - 1

    n = 0

    (x_min..x_max).each do |col|
      (y_min..y_max).each do |row|
        # if not center, check is alive
          if (col != x && row != y) && @board[col][row] == 1
            n += 1
          end
      end
    end

    # total neighbors = n
    # don't return total, evaluate against rules & return T or F
    result = get_result(n, @board[col][row])


  end

  def get_result(n, live)
    if n < 2 && live
      # die
    elsif n > 3 && live
      #die

  end
end
