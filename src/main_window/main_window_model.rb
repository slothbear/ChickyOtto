class MainWindowModel

  attr_accessor :capture_progress
  attr_accessor :farm_image
  
  
  attr_accessor :locating
  attr_accessor :farm_location
  
  def initialize
    @capture_progress = "from-model"
    @farm_image = nil
    @farm_location = "10249,90"  # some indication of unsettedness
    @locating = false
  end

end
