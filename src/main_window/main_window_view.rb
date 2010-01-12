class MainWindowView < ApplicationView
  set_java_class 'OttoFrame'
  # TODO: need a status line somewhere for errors, status, etc.  + a log.
  
  map :model => "location[:farm]", :view => "farm_location.text"
  map :model => "location[:coop]", :view => "coop_location.text"
  map :model => "location[:primers]", :view => "primers_location.text"
  map :model => "location[:premiums]", :view => "premiums_location.text"
    
  # map :model => "primers_rows", :view => "primers_rows.text",
  #   :using => [:to_s, :to_i]
  # map :model => "primers_cols", :view => "primers_cols.text",
  #     :using => [:to_s, :to_i]
  # map :model => "premiums_rows", :view => "premiums_rows.text",
  #     :using => [:to_s, :to_i]
  # map :model => "premiums_cols", :view => "premiums_cols.text",
  #     :using => [:to_s, :to_i]
  # 
  # map :model => "premium_colors[:white]", :view => "white_premiums.text",
  #     :using => [:to_s, :to_i]
  # map :model => "premium_colors[:brown]", :view => "brown_premiums.text",
  #     :using => [:to_s, :to_i]
  # map :model => "premium_colors[:black]", :view => "black_premiums.text",
  #     :using => [:to_s, :to_i]
  # map :model => "premium_colors[:golden]", :view => "golden_premiums.text",
  #     :using => [:to_s, :to_i]
        
  define_signal :name => :hide_window, :handler => :hide_window
  define_signal :name => :show_window, :handler => :show_window
  
  define_signal :name => :locating, :handler => :crosshair_cursor
  define_signal :name => :idle, :handler => :normal_cursor
  define_signal :name => :refresh, :handler => :refresh
  
  add_listener :type => :mouse, :components => [:ia]

  def to_s(fixnum)
    fixnum.to_s
  end
  
  def to_i(string)
    string.to_i
  end
  
  def hide_window(model, transfer)
    hide
  end
  
  def show_window(model, transfer)
    show
    @main_view_component.setImage(model.farm_image)
  end
  
  def refresh(model, transfer)
    @main_view_component.repaint
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
