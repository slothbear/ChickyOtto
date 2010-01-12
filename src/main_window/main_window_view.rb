class MainWindowView < ApplicationView
  set_java_class 'OttoFrame'

  define_signal :name => :hide_window, :handler => :hide_window
  define_signal :name => :show_window, :handler => :show_window

  define_signal :name => :locating, :handler => :crosshair_cursor
  define_signal :name => :idle, :handler => :normal_cursor
  define_signal :name => :refresh, :handler => :refresh

  add_listener :type => :mouse, :components => [:image_area]

  # TODO: is there a more natural object that could do point/array w/o convert?  
  map :model => "location[:farm]", :view => "farm_location",
    :using => [:to_point, :to_a]
  map :model => "location[:coop]", :view => "coop_location",
      :using => [:to_point, :to_a]
  map :model => "location[:primers]", :view => "primers_location",
      :using => [:to_point, :to_a]
  map :model => "location[:premiums]", :view => "premiums_location",
      :using => [:to_point, :to_a]
    
  map :model => "primers_rows", :view => "primers_rows.text",
      :using => [nil, :to_i]
  map :model => "primers_cols", :view => "primers_cols.text",
      :using => [nil, :to_i]
  map :model => "premiums_rows", :view => "premiums_rows.text",
      :using => [nil, :to_i]
  map :model => "premiums_cols", :view => "premiums_cols.text",
      :using => [nil, :to_i]

  map :model => "premium_colors[:white]", :view => "white_premiums.text",
      :using => [nil, :to_i]
  map :model => "premium_colors[:brown]", :view => "brown_premiums.text",
      :using => [nil, :to_i]
  map :model => "premium_colors[:black]", :view => "black_premiums.text",
      :using => [nil, :to_i]
  map :model => "premium_colors[:golden]", :view => "golden_premiums.text",
      :using => [nil, :to_i]


  def to_i(string)
    string.to_i
  end
  
  def to_point(array)
    java.awt.Point.new(array[0], array[1])
  end

  def to_a(point)
    [point.x, point.y]
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
