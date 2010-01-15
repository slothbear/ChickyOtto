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
  
  def image_area_mouse_clicked event
    return unless model.locating

    model.location[model.locating] = [event.get_x, event.get_y]
    model.locating = false
    signal :idle
    update_view
    signal :refresh   # repaint the ImageArea
  end

  def remove_primer_item_state_changed event
    model.remove_primer = event.item.is_selected?
  end

  def white_primers_action_performed
    model.primer_color = :white
  end

  def brown_primers_action_performed
    model.primer_color = :brown
  end

  def black_primers_action_performed
    model.primer_color = :black
  end

  def golden_primers_action_performed
    model.primer_color = :golden
  end

  def tend_button_action_performed
    update_model view_state.model,
      :primer_rows, :primer_columns,
      :premium_rows, :premium_columns

    [:white, :brown, :black, :golden]. each do |color|
      model.premium_colors[color] = view_state.model.premium_colors[color]
    end

    model.tend_coop
  end  # tend

end
