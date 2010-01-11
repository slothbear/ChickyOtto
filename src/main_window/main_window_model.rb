class MainWindowModel

  attr_accessor :capture_progress
  attr_accessor :farm_image
  
  attr_accessor :locating   # false or the name of thing being located
  attr_accessor :location   # all points of interest
  
  def initialize
    @capture_progress = "from-model"
    @farm_image = nil
    
    @locating = false    
    @location = Hash.new('unk-model')
  end

end
