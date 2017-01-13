
require 'gosu'

class WhackARuby < Gosu::Window

  def initialize
    super(800, 600)
    self.caption = 'Catch the Minion!'
    @background_image = Gosu::Image.new(self, "images.jpeg", :tileable => true)
    @image = Gosu::Image.new('minion-150px.png')
    @x = 200
    @y = 200
    @width = 50
    @height = 50
    # determines the speed of the first image
    @velocity_x = 5                      
    @velocity_y = 5
    @visible = 0
    @hammer_image = Gosu::Image.new('purple-minion2.png')
    @hit = 0
    @font = Gosu::Font.new(30)
    @score = 0
    @playing = true
    @start_time = 0
  end

  def update
    if @playing
      @x += @velocity_x
      @y += @velocity_y
      @velocity_x *= -1 if @x + @width / 2 > 800 || @x - @width / 2 < 0
      @velocity_y *= -1 if @y + @height / 2 > 600 || @y - @height / 2 < 0
      @visible -= 1
      @visible = 30 if @visible < -10 && rand < 0.01
      @time_left = (100 - ((Gosu.milliseconds - @start_time) / 1000))
      @playing = false if @time_left < 0
    end
  end

  def draw
    @background_image.draw_as_quad(0, 0, 0xffffffff, 800, 0, 0xffffffff, 800, 600, 0xffffffff, 0, 600, 0xffffffff, 0)
    if @visible > 0
      @image.draw(@x - @width / 2, @y - @height / 2, 1)
    end
    @hammer_image.draw(mouse_x - 25, mouse_y - 25, 1)
    if @hit == 0
      c = Gosu::Color::NONE
    elsif @hit == 1
      c = Gosu::Color::GREEN
    elsif @hit == -1
      c = Gosu::Color::RED
    end
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
    @font.draw(@score.to_s, 700, 20, 2)
    @font.draw(@time_left.to_s, 20, 20, 2)
    unless @playing
      @font.draw('Game Over', 300, 300, 3)
      @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
      @visible = 20
    end
  end

  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        if Gosu.distance(mouse_x, mouse_y, @x, @y) < 150 && @visible >= 0
          @hit = 1
          @score += 5
        else
          @hit = -1
          @score -= 1
        end
      end
    else
      if (id == Gosu::KbSpace)
        @playing = true
        @visible = -10
        @start_time = Gosu.milliseconds
        @score = 0
      end
    end
  end
end

window = WhackARuby.new
window.show
