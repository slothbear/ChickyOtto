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
  
  def ia_mouse_clicked event
    return unless model.locating
    model.locating = false
    
    model.farm_location = event.get_x.to_s + "," + event.get_y.to_s
    signal :idle
    update_view
  end
end
