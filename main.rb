#!/usr/bin/env ruby

require 'sdl'

require_relative('settings')
require_relative('util')
require_relative('joystick')
require_relative('sprite')

SDL.init SDL::INIT_EVERYTHING
screen = SDL::set_video_mode SCREEN_W, SCREEN_H, 24, SDL::SWSURFACE

JoystickState::init_all

BGCOLOR = screen.format.mapRGB 0, 0, 0
LINECOLOR = screen.format.mapRGB 255, 255, 255

SDL::TTF.init
FONT = SDL::TTF.open(SETTINGS[:font], 14, 0)

H_SCREEN_W = SCREEN_W / 2
H_SCREEN_H = SCREEN_H / 2;

SPRITES = Array.new(SETTINGS[:sprites]) { Sprite.new(screen) }

@js = JoystickState.joysticks[0]
@x = @y = 0

@score = 0
@misses = 0

@shooting = false
@canshoot = true
@shotstart = 0
@state = :intro
@timer = 60000
@mark = SDL::get_ticks

def draw_intro(screen)

  time = ((3000 - SDL::get_ticks - @mark) / 1000.0).round
  
  screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, BGCOLOR
  
  str = "#{time}"
  w = FONT.text_size(str)[0]

  FONT.draw_blended_utf8(screen, "#{time}", (SCREEN_W - w) / 2, H_SCREEN_H, 255, 255, 255)
  
  if time <= 0
    @mark = SDL::get_ticks
    return :game 
  end

  return :intro
  
end

def draw_dead(screen)

  screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, BGCOLOR
  str = "You scored #{@score} points!"
  w = FONT.text_size(str)[0]
  FONT.draw_blended_utf8(screen, str, (SCREEN_W - w) / 2, H_SCREEN_H, 255, 255, 255)

end

def draw_game(screen)

  @timer = 60000 - (SDL::get_ticks - @mark)
  
  if @timer <= 0
    return :dead
  end

  @x = H_SCREEN_W + ((@js.axis(0) / 32768.0) * H_SCREEN_W)
  @y = H_SCREEN_H + ((@js.axis(1) / 32768.0) * H_SCREEN_H)
  
  if @canshoot && @js.axis(5) > 0 && !@shooting && @ticks - @shotstart > 100
    @shotstart = @ticks
    @shooting = true
    @canshoot = false
  end
  
  if !@canshoot && @js.axis(5) < 0
    @canshoot = true
  end
  
  SPRITES.each do |s| 
    s.tick(screen)
    
    if @shooting && s.hit?(@x, @y)
      @score += s.points
      debug "Hit: #{@score}"
      s.die
    elsif s.y < -(s.size / 2)
      @misses += 1
      debug "Miss: #{@misses}"
      s.init(screen)
    end
    
  end
  
  @shooting = false
  
  if @ticks - @shotstart <= 20
    screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, LINECOLOR
  else
    screen.fill_rect 0, 0, SCREEN_W, SCREEN_H, BGCOLOR
  end
  screen.draw_line @x, 0, @x, SCREEN_H, LINECOLOR
  screen.draw_line 0, @y, SCREEN_W, @y, LINECOLOR
  
  FONT.draw_blended_utf8(screen, "Score: #{@score}", 5, 5, 255, 255, 255)
  FONT.draw_blended_utf8(screen, 
    "Time: %2.2f" % [ @timer / 1000.0 ], 5, 5 + FONT.line_skip, 255, 255, 255)
  
  SPRITES.each{|s| s.draw(screen) }
  
  return :game

end

main_loop do

  @ticks = SDL::get_ticks

  case @state
  when :intro

    @state = draw_intro(screen)

  when :game
    
    @state = draw_game(screen)    
    
  when :dead
  
    @state = draw_dead(screen)
    
  end

  screen.flip

end
