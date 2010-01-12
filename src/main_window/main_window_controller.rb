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
    update_view
  end
  
  def start_locating thing
    model.locating = thing
    signal :locating
    update_view
  end
  
  def locate_farm_action_performed
    start_locating(:farm)
  end
  
  def locate_coop_action_performed event
    start_locating(:coop)
  end
  
  def locate_primers_action_performed event
    start_locating(:primers)
  end
  
  def locate_premiums_action_performed event
    start_locating(:premiums)
  end
  
  def ia_mouse_clicked event
    return unless model.locating

    model.location[model.locating] =
      event.get_x.to_s + "," + event.get_y.to_s
    model.locating = false
    signal :idle
    update_view
    signal :refresh   # repaint the ImageArea
  end

  def tend_button_action_performed
    update_model view_state.model,
      :primers_rows, :primers_cols,
      :premiums_rows, :premiums_cols

    [:white, :brown, :black, :golden]. each do |color|
      model.premium_colors[color] = view_state.model.premium_colors[color]
    end

  end

end
