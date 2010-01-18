# distance between fields at minimum zoom,
# and between animals or trees at maximum zoom.
STEP_X = 25
STEP_Y = 12

class Field
  attr_accessor :plots

  def initialize(x, y, rows, columns)
    @plots = Array.new

    # x and y denote the upper left corner of a rectangle
    # start_* is the left end of the current row
    start_x = x
    start_y = y

    row = 1
    while row <= rows
      ix = start_x
      iy = start_y
      column = 1
      while column <= columns
        @plots << [ix, iy]
        ix  += STEP_X
        iy  -= STEP_Y
        column += 1
      end # next column
      start_x += STEP_X
      start_y += STEP_Y
      row += 1
    end # next row
  end  # initialize

end  # class