#!/usr/bin/env ruby

require 'sdl'

SDL.init SDL::INIT_EVERYTHING

require_relative('settings')
require_relative('util')
require_relative('joystick')
require_relative('sprite')

screen = SDL::set_video_mode SCREEN_W, SCREEN_H, 24, SDL::SWSURFACE
x = y = 0

JoystickState::init_all
js = JoystickState.joysticks[0]

BGCOLOR = screen.format.mapRGB 0, 0, 0
LINECOLOR = screen.format.mapRGB 255, 255, 255

H_SCREEN_W = SCREEN_W / 2
H_SCREEN_H = SCREEN_H / 2;

SPRITES = Array.new(SETTINGS[:sprites]) { Sprite.new(screen) }

score = 0
misses = 0

paused = false

shooting = false
canshoot = true
shotstart = 0

main_loop do

  x = H_SCREEN_W + ((js.axis(0) / 32768.0) * H_SCREEN_W)
  y = H_SCREEN_H + ((js.axis(1) / 32768.0) * H_SCREEN_H)
  
  ticks = SDL::get_ticks
  
  if canshoot && js.axis(5) > 0 && !shooting && ticks - shotstart > 100
    shotstart = ticks
    shooting = true
    canshoot = false
  end
  
  if !canshoot && js.axis(5) < 0
    canshoot = true
  end
  
  SPRITES.each do |s| 
    s.tick(screen)
    
    if shooting && s.hit?(x, y)
      score += s.points
      puts "Hit: #{score}"
      s.die
    elsif s.y < -(s.size / 2)
      misses += 1
      puts "Miss: #{misses}"
      s.init(screen)
    end
    
  end
  
  shooting = false
  
  if ticks - shotstart <= 20
    screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, LINECOLOR
  else
    screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, BGCOLOR
  end
  screen.draw_line x, 0, x, SCREEN_H, LINECOLOR
  screen.draw_line 0, y, SCREEN_W, y, LINECOLOR
  
  SPRITES.each{|s| s.draw(screen) }

  screen.flip

end
