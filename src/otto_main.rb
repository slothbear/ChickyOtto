require 'java'
require 'yaml'

OTTO_VERSION = "0.5.8"

# distance between fields at minimum zoom,
# and between animals or trees at maximum zoom.
STEP_X = 25
STEP_Y = 12

ROBOT = java.awt.Robot.new

class Field
  attr_reader :plots
  
  def initialize(x, y, rows, columns, color="none")
    @plots = generate_plot_list(x, y, rows, columns)
    @chicken_color = color
  end

  def generate_plot_list(x, y, rows, columns)

    # x and y denote the upper left corner of a rectangle
    # start_* is the left end of the current row
    start_x = x
    start_y = y

    plots = Array.new
    row = 1
    while row <= rows
      ix = start_x
      iy = start_y
      column = 1
      while column <= columns
        plots << [ix, iy]
        ix  += STEP_X
        iy  -= STEP_Y
        column += 1
      end # next column
      start_x += STEP_X
      start_y += STEP_Y
      row += 1
    end # next row
    plots
  end # method
    
end # class

def caps_lock?
  tk = java.awt.Toolkit.getDefaultToolkit
  tk.getLockingKeyState(java.awt.event.KeyEvent::VK_CAPS_LOCK)
end

def pause?
  while caps_lock?
    make_noise("pause-extended")
    sleep 15
  end
end

def sleep_for(secs, sound=false)
  make_noise(sound)
  sleep secs
  pause?
end

def make_noise(sound_key)
  return unless Settings["play-sounds"]  # don't bother alien purple chicken
  
  sound_spec = Settings[sound_key]
  return if !sound_spec
  
  if sound_spec =~ /^say /     # Macintosh only.  TODO: enforce
    system sound_spec
  else
    sound_file = java.io.File.new("sounds/#{sound_spec}")
    sound_url = sound_file.toURI().toURL()
    
    #TODO: check for existance: sound_url.openConnection.getInputStream.close
    #      raises exception if file not found.  play() just ignores
    java.applet.Applet.newAudioClip(sound_url).play
  end
end

def click_at(plot)
  pause?
  ROBOT.mouseMove(plot[0],plot[1])
  ROBOT.delay(100 + rand(20))
  return if Settings["no-clicking"]
  ROBOT.mousePress(java.awt.event.InputEvent::BUTTON1_MASK)
  ROBOT.delay(50 + rand(10))
  ROBOT.mouseRelease(java.awt.event.InputEvent::BUTTON1_MASK)
  ROBOT.delay(@click_delay + rand(100))
end


def load_coop(pen)
  last_premium = pen.plots.last
  remove_primer = Settings["remove-primer-chicken"]
  
  pen.plots.each do | premium |
    if remove_primer && premium == last_premium
      # move off of coop to ?unselect it
      # coop menu doesn't activate if cursor left there after adding.
      ROBOT.mouseMove premium[0],premium[1]
      ROBOT.delay(100)
      
      remove_chicken(
        @remove_button[remove_primer],
        [last_premium[0] + STEP_X, last_premium[1] - STEP_Y],
        :primer
        )
    end
    add_chicken(premium)
  end
  
  if Settings["collect-eggs-after-load"]
    sleep_for @after_coop_loaded, "coop-loaded"
    
    # move off coop to ?unselect it
    ROBOT.mouseMove @coop[0],@coop[1]-205
    ROBOT.delay 100
    click_at @coop
    click_at [@coop[0]+16,@coop[1]+10] # collect eggs
  end
end

def add_chicken(chicken)
  click_at chicken
  click_at [chicken[0]+16, chicken[1]+10]  # chicken/move
  ROBOT.mouseMove(@coop[0],@coop[1])
  click_at @coop
end

def remove_chicken(remove_button, landing, primer=false)
  click_at @coop
  if primer
    click_at [@coop[0]+16,@coop[1]+32] # Look Inside when Collect Eggs active
  else
    click_at [@coop[0]+16, @coop[1]+10]  # Look Inside
  end
  ROBOT.delay(@after_look_inside + rand(25))  # wait for look inside
  click_at remove_button
  ROBOT.delay(100 + rand(25))   # a little extra for the remove
  click_at [landing[0]-11, landing[1]+27]   # deposit the chick
end

def unload_coop(pen)
  colors = Settings["premium-colors"]
  removes = []
  colors.each do |color, count|
    count.times {removes << @remove_button[color]}
  end

  pen.plots.each_with_index do |landing, index|
    remove_chicken(removes[index], landing)
  end
end

begin
  cmd = ARGV[0]

  if !%w{load_coop unload_coop load_unload}.include?(cmd)
    puts "FarmerOtto version #{OTTO_VERSION}"
    puts "usage:"
    puts "   otto load_coop"
    puts "   otto unload_coop"
    puts "   otto load_unload"
    exit 2
  end

  if !File.exists?("farm.yaml")
    puts "The farm definition file 'farm.yaml' cannot be found."
    exit 8
  end

  Settings = YAML::load_file("farm.yaml")
  if !Settings["settings-customized"]
    puts "Please describe your farm in the file 'farm.yaml',"
    puts "then change 'settings-customized' to true (in farm.yaml)."
    exit 4
  end
 
  @coop = Settings["coop"]

  # delays used elsewhere
  @click_delay = Settings["ms-after-click"] || 600
  @after_look_inside = Settings["ms-after-look-inside"] || 350
  @after_coop_loaded = Settings["secs-after-coop-loaded"] || 5

  # delays used in main()
  startup_delay = Settings["secs-before-beginning"] || 10
  between_load_unload = Settings["secs-between-load-unload"] || 10
  after_unload = Settings["secs-after-unload"] || 15

  rw = Settings["remove-white-chicken-button"]
  @remove_button = {
    "white", rw,
    "brown", [rw[0]+292, rw[1]],
    "black", [rw[0], rw[1]+190],
    "golden", [rw[0]+292, rw[1]+190]
  }

  premium_pen = Field.new(*Settings["premium-pen"])

  sleep_for startup_delay, "startup-sound"

  if cmd == "load_coop"
    load_coop(premium_pen)
  elsif cmd == "unload_coop"
    unload_coop(premium_pen)
  elsif cmd == "load_unload"
    passes = ARGV[1] || 1
    passes = passes.to_i
    last_pass = passes - 1
    passes.times do |pass|
      load_coop(premium_pen)
      sleep_for between_load_unload, "collect-eggs"
      unload_coop(premium_pen)
      unless pass == last_pass
        sleep_for after_unload, "check-unload-progress"
      end
    end
  else
    # cmd is also validated at start
    puts "unknown command: #{cmd}" if cmd
  end

  make_noise("shutdown-sound")
  sleep 3 # allow time for shutdown sound
rescue SystemExit => e
  # exit via guard clauses at start of program -- ok
end



