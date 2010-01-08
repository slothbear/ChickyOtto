class MainWindowController < ApplicationController
  set_model 'MainWindowModel'
  set_view 'MainWindowView'
  set_close_action :exit
  
  def capture_farm_action_performed
    puts 'take snapshot now'
    model.capture_progress = "click"
    update_view
  end
end
