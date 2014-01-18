require 'sdl'

require_relative('util')

class JoystickState
  
  def self.init_all
    @@joysticks = []
    n_sticks = SDL::Joystick.num
    0.upto(n_sticks - 1) do |n|
      js = SDL::Joystick.open(n)
      @@joysticks << js
      debug "Opened Joystick #{SDL::Joystick.index_name(n)} as controller #{n + 1} \
(#{js.num_axes} axes, #{js.num_buttons} buttons)"
    end
  end

  def self.joysticks
    @@joysticks
  end

end
