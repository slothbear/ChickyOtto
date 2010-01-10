class MainWindowView < ApplicationView
  set_java_class 'OttoFrame'
  
  map :model => :capture_progress, :view => "capture_progress.text"
  
  define_signal :name => :hide_window, :handler => :hide_window
  define_signal :name => :show_window, :handler => :show_window
  
  def hide_window(model, transfer)
    hide
  end
  
  def show_window(model, transfer)
    show
    @main_view_component.setImage(model.farm_image)
  end
end
