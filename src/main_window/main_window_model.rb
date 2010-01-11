class MainWindowModel
  attr_accessor :farm_image
  
  attr_accessor :locating   # false or the name of thing being located
  attr_accessor :location   # all points of interest
  
  def initialize
    @farm_image = nil
    @locating = false    
    @location = Hash.new('0,0')
  end

end
