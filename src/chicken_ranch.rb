require 'field'

ROBOT = java.awt.Robot.new

class ChickenRanch
  
  def initialize(primers, primer_color, premiums, premium_colors, coop, settings)
    @primer_pen = Field.new(*primers)
    @premium_pen = Field.new(*premiums)
    @primer_color = primer_color
    @premium_colors = premium_colors
    @coop = coop
    @settings = settings
  end


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
    return unless @settings["play-sounds"]  # don't bother alien purple chicken

    sound_spec = @settings[sound_key]
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

  def click_at(plot, move_off = false)
    pause?
    
    if move_off
      ROBOT.mouseMove(plot[0]+10,plot[1]+10)
      ROBOT.delay(100)
    end
    
    ROBOT.mouseMove(plot[0],plot[1])
    ROBOT.delay(100 + rand(20))
    return if @settings["no-clicking"]
    ROBOT.mousePress(java.awt.event.InputEvent::BUTTON1_MASK)
    ROBOT.delay(50 + rand(10))
    ROBOT.mouseRelease(java.awt.event.InputEvent::BUTTON1_MASK)
    ROBOT.delay(@settings["ms-after-click"] + rand(100))
  end

  def add_chicken(chicken)
    click_at chicken
    click_at [chicken[0]+16, chicken[1]+10]  # chicken/move
    click_at @coop
  end

  def remove_chicken(remove_button, landing, primer=false)
    if primer
      click_at @coop, :move_off
      click_at [@coop[0]+16,@coop[1]+32] # Look Inside when Collect Eggs active
    else
      click_at @coop
      click_at [@coop[0]+16, @coop[1]+10]  # Look Inside
    end
    ROBOT.delay(@settings["ms-after-look-inside"] + rand(25))  # wait for look inside
    click_at remove_button
    ROBOT.delay(100 + rand(25))   # a little extra for the remove
    click_at [landing[0]-11, landing[1]+27]   # deposit the chick
    click_at landing # click on chick
    click_at [landing[0]+16, landing[1]+52]  # menu/Stay
  end

  def load_coop primer
    add_chicken primer
    premiums = @premium_pen.plots.dup  # TODO: this seems unkind.  weird.
    add_chicken premiums.shift
    remove_chicken(@settings["remove-button"][@primer_color], primer, :primer)

    premiums.each do |premium|
      add_chicken premium
    end
    sleep_for @settings["secs-after-coop-loaded"], "coop-loaded"
  end

  def collect_eggs
  click_at @coop, :move_off
    click_at [@coop[0]+16,@coop[1]+10] # collect eggs
    sleep_for @settings["secs-after-collect"], "collect-eggs"
  end

  def unload_coop
    removes = []
    @premium_colors.each do |color, count|
      count.times {removes << @settings["remove-button"][color]}
    end

    @premium_pen.plots.each_with_index do |landing, index|
      remove_chicken(removes[index], landing)
    end
  end

  def tend
    sleep_for @settings["secs-before-beginning"], "startup-sound"
    @primer_pen.plots.each do |primer|
      load_coop primer
      collect_eggs
      unload_coop
      sleep_for @settings["secs-after-unload"], "check-unload-progress"
    end  # primers
    
    make_noise "shutdown-sound"
    sleep 3
  end  # tend

end # class