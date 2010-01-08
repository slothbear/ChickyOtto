class MainWindowView < ApplicationView
  set_java_class 'OttoFrame'
  
  map :model => :capture_progress, :view => "capture_progress.text"
end
