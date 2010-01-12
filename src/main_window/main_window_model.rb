class MainWindowModel
  attr_accessor :farm_image
  
  attr_accessor :locating   # false or the name of thing being located
  attr_accessor :location   # all points of interest
  
  attr_accessor :primers_rows, :primers_cols
  attr_accessor :premiums_rows, :premiums_cols
  
  attr_accessor :premium_colors
  
  def initialize
    @farm_image = nil
    @locating = false    
    @location = Hash.new('0,0')
    @premium_colors = Hash.new(7)
    
    @primers_rows = 0
    @primers_cols = 0
    @premiums_rows = 0
    @premiums_cols = 0
  end

end
