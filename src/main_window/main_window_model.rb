class MainWindowModel

  attr_accessor :capture_progress
  attr_accessor :farm_image
  
  def initialize
    @capture_progress = "unk-prog"
    @farm_image = nil
  end

end
