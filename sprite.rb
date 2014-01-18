require 'sdl'

class Sprite
  attr_accessor :x, :y, :speed_x, :speed_y, :size, :points
  
  def initialize(screen)
    init(screen)
  end
  
  def init(screen)

    @dying = false
    @diecolor = screen.format.mapRGB(100, 0, 0)
    
    @x = rand(SCREEN_W)
    @y = 0

    @speed_x = (-20 + rand(40)) * 0.5
    @speed_y = (20 + rand(10)) * 0.5
     
    if (@x > SCREEN_W * 0.6666 && @speed_x > 0) || 
      (@x < SCREEN_W * 0.3333 && @speed_x < 0)
      @speed_x = -@speed_x
    end      
     
    @size = 20 + rand(20)
    @points = 40 - @size
     
    @color = screen.format.mapRGB(100 + rand(155), 100 + rand(155), 100 + rand(155))

  end
  
  def hit?(x, y)
  
    return false if @dying
    
    dx = (x - @x).abs
    dy = ((SCREEN_H - y) - @y).abs
    d = Math.sqrt((dx ** 2) + (dy ** 2))
    
    d <= @size
    
  end
  
  def die
    @dying = true
  end
  
  def tick(screen)
    
    if @dying
    
      @size -= 1
      if @size == 0
        init(screen)
      end
    
    else
    
      @speed_y -= 0.05
      
      @x += @speed_x * 0.25
      @y += @speed_y * 0.25
      
    end
    
  end
  
  def draw(screen)
  
    color = @dying ? @diecolor : @color
    screen.draw_aa_filled_circle(@x.round, SCREEN_H - @y.round, @size, color)
  
  end

end
