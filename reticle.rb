class Reticle
  attr_accessor :x, :y
  
  def initialize(js, screen)
    @js = js
    tick(screen)
  end
  
  def tick(screen)
    @x = H_SCREEN_W + ((@js.axis(0) / 32768.0) * H_SCREEN_W)
    @y = H_SCREEN_H + ((@js.axis(1) / 32768.0) * H_SCREEN_H)
  end
  
  def draw(screen)
    screen.draw_line @x, 0, @x, SCREEN_H, LINECOLOR
    screen.draw_line 0, @y, SCREEN_W, @y, LINECOLOR
  end
  
end
