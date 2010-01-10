class MainWindowController < ApplicationController
  set_model 'MainWindowModel'
  set_view 'MainWindowView'
  set_close_action :exit
  
  def capture_farm_action_performed
    rectScreenSize =
      java.awt.Rectangle.new(java.awt.Toolkit.getDefaultToolkit.getScreenSize)
    
    signal :hide_window
    sleep 0.5  # give screen time to settle down
    robot = java.awt.Robot.new
    model.farm_image = robot.createScreenCapture(rectScreenSize)
    signal :show_window

    model.capture_progress = "captured"
    update_view
  end
  
  def locate_farm_action_performed event
    # puts event
    model.locating = :farm
    model.farm_location = "locating"
    signal :locating
    update_view
  end
  
  def locate_coop_action_performed event
    # puts event
    model.locating = :coop
    model.coop_location = "locating"
    signal :locating
    update_view
  end
  
  def locate_primers_action_performed event
    # puts event
    model.locating = :primers
    model.primers_location = "locating"
    signal :locating
    update_view
  end
  
  def locate_premiums_action_performed event
    # puts event
    model.locating = :premiums
    model.premiums_location = "locating"
    signal :locating
    update_view
  end
  
  def ia_mouse_clicked event
    return unless model.locating

    xy = event.get_x.to_s + "," + event.get_y.to_s
    case model.locating
    when :farm
      model.farm_location = xy
    when :coop
      model.coop_location = xy
    when :primers
      model.primers_location = xy
    when :premiums
      model.premiums_location = xy
    end
    
    model.locating = false
    signal :idle
    update_view
  end
end
