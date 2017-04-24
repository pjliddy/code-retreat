class Game
  def initialize(size)
    @size = size
    # create board w/all cells defaulted to false
    @board = Array.new(size) { Array.new(size, false) }
    # set all = false
  end

  @board.each_with_index do |x, xi|
   x.each_with_index do |y, yi|
     puts "element [#{xi}, #{yi}] is #{y}"
   end
 end
end
