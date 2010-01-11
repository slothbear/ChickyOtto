class MainWindowView < ApplicationView
  set_java_class 'OttoFrame'
  # TODO: need a status line somewhere for errors, status, etc.  + a log.
  
  map :model => :capture_progress, :view => "capture_progress.text"
  
  map :model => "location[:farm]", :view => "farm_location.text"
  map :model => "location[:coop]", :view => "coop_location.text"
  map :model => "location[:primers]", :view => "primers_location.text"
  map :model => "location[:premiums]", :view => "premiums_location.text"
  
  define_signal :name => :hide_window, :handler => :hide_window
  define_signal :name => :show_window, :handler => :show_window
  
  define_signal :name => :locating, :handler => :crosshair_cursor
  define_signal :name => :idle, :handler => :normal_cursor
  
  add_listener :type => :mouse, :components => [:ia]
  
  
  def hide_window(model, transfer)
    hide
  end
  
  def show_window(model, transfer)
    show
    @main_view_component.setImage(model.farm_image)
  end
  
  def crosshair_cursor(model, transfer)
    @main_view_component.setCursor(
      java.awt.Cursor.new(java.awt.Cursor::CROSSHAIR_CURSOR));
  end
  
  def normal_cursor(model, transfer)
    @main_view_component.setCursor(
      java.awt.Cursor.new(java.awt.Cursor::DEFAULT_CURSOR));
  end
end
