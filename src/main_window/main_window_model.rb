class MainWindowModel

  attr_accessor :capture_progress
  attr_accessor :farm_image
  
  attr_accessor :locating
  attr_accessor :farm_location
  attr_accessor :coop_location
  attr_accessor :primers_location
  attr_accessor :premiums_location
  
  def initialize
    @capture_progress = "from-model"
    @farm_image = nil
    @locating = false
    @farm_location = "unk-farm" 
    @coop_location = "unk-coop" 
    @primers_location = "unk-primers" 
    @premiums_location = "unk-premiums"
  end

end
