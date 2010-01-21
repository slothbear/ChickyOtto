require 'yaml'
require 'field'
require 'chicken_ranch'

class MainWindowModel
  attr_accessor :farm_image
  
  attr_accessor :locating   # false or the name of thing being located
  attr_accessor :location   # all points of interest
  
  attr_accessor :primer_rows, :primer_columns
  attr_accessor :premium_rows, :premium_columns
  
  attr_accessor :premium_colors
  attr_accessor :primer_color
  
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
  end

  def load_settings
    if !File.exists?("farm.yaml")
      msg = "The farm definition file 'farm.yaml' cannot be found."
      javax.swing.JOptionPane.showMessageDialog(nil, msg)
      exit 8
    end
    @settings = YAML::load_file("farm.yaml")
  end

  def remove_buttons
    # locate "remove white" button via farm location.  then the others.
    rw = [@location[:farm][0]+163, @location[:farm][1]+305]
    { :white,  rw,
      :brown,  [rw[0]+292, rw[1]],
      :black,  [rw[0], rw[1]+190],
      :golden, [rw[0]+292, rw[1]+190]
    }
  end

  def valid_farm?
    premium_count = @premium_rows * @premium_columns
    color_count = @premium_colors.values.inject{|sum,x| sum + x}

    valid =
      @farm_image &&
      @location.size == 4 &&
      @primer_rows * @primer_columns > 0 &&
      @primer_color &&
      premium_count > 0 &&
      premium_count <= 20 &&
      premium_count == color_count

    if !valid
      javax.swing.JOptionPane.showMessageDialog(nil, <<EOS)
Yikes!  Something is missing or your numbers are mushy.
      Did you capture the farm image?
      Is the location set for farm, coop, primers, and premiums?
      Is primer rows * primer columns > 0?
      Is premium rows * primer columns > 0 and <= 20?
      Does premium rows * premium columns == the total of premium colors?
      Check the documentation if you need more help.
EOS
    end

    valid
  end

  # main call from the controller
  def tend_coop
    valid_farm? or return
    load_settings
    @settings['remove-button'] = remove_buttons
    primer_pen = @location[:primers] << @primer_rows << @primer_columns
    premium_pen = @location[:premiums] << @premium_rows << @premium_columns

    ranch = ChickenRanch.new(primer_pen, @primer_color,
      premium_pen, @premium_colors,
      @location[:coop], @settings)
    ranch.tend
  end

end
