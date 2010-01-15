class MainWindowModel
  attr_accessor :farm_image
  
  attr_accessor :locating   # false or the name of thing being located
  attr_accessor :location   # all points of interest
  
  attr_accessor :primer_rows, :primer_columns
  attr_accessor :premium_rows, :premium_columns
  
  attr_accessor :premium_colors
  attr_accessor :primer_color
  attr_accessor :remove_primer
  
  def initialize
    @farm_image = nil
    @locating = false    
    @location = Hash.new([0,0])
    @premium_colors = Hash.new(7)
    
    @primer_rows = 0
    @primer_columns = 0
    @premium_rows = 0
    @premium_columns = 0

    @primer_color = :white
    @remove_primer = true
  end

  def locate_remove_buttons
    rw = [@location[:farm][0]+163, @location[:farm][1]+305]
    @remove_button = {
      :white,  rw,
      :brown,  [rw[0]+292, rw[1]],
      :black,  [rw[0], rw[1]+190],
      :golden, [rw[0]+292, rw[1]+190]
    }
  end

  # main call from the controller
  def tend_coop
    locate_remove_buttons
  end

end
