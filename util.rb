require_relative('settings')

DEBUG = SETTINGS[:debug]
SCREEN_W = SETTINGS[:width]
SCREEN_H = SETTINGS[:height]

def debug(msg)
  return unless DEBUG
  puts msg
end

def main_loop

  running = true

  while running

    while event = SDL::Event2.poll
      case event
      when SDL::Event2::Quit
        running = false
      end
    end
   
    yield
    
  end

end
