module Graphics

  module Renderers
    class Ascii
    end
    class Html
    end
  end

  class Point
    def initialize(x, y)
      @x = x
      @y = y
    end

    def x
      @x
    end

    def y
      @y
    end

    def ==(other)
      return true if other.x == @x and other.y == @y
      false
    end

    alias_method :eql?, :==

    def distance(other)
      Math.sqrt((@x-other.x)*(@x-other.x) + (@y-other.y)*(@y-other.y))
    end

  end

  class Line
    def initialize(from, to)
      set_from from, to
      set_to from, to
    end

    def set_from(from, to)
      @from = Point.new(from.x,[from.y,to.y].min) if from.x == to.x
      @from = from if from.x < to.x
      @from = to if from.x > to.x
    end

    def set_to(from, to)
      @to = Point.new(from.x,[from.y,to.y].max) if from.x == to.x
      @to = from if from.x > to.x
      @to = to if from.x < to.x
    end

    def from
      @from
    end

    def to
      @to
    end

    def ==(other)
      return true if other.from == @from and other.to == @to
      false
    end

    alias_method :eql?, :==

    private :set_from, :set_to
  end

  class Rectangle
    def initialize(first, second)
      set_left first, second
      set_right first, second
      set_vertices
    end

    def set_left(first, second)
      @left = Point.new(first.x,[first.y,second.y].min) if first.x == second.x
      @left = first if first.x < second.x
      @left = second if first.x > second.x
    end

    def set_right(first, second)
      @right = Point.new(first.x,[first.y,second.y].max) if first.x == second.x
      @right = first if first.x > second.x
      @right = second if first.x < second.x
    end

    def set_vertices
      @top_left = Point.new([@left.x,@right.x].min,[@left.y,@right.y].min)
      @top_right = Point.new([@left.x,@right.x].max,[@left.y,@right.y].min)
      @bottom_left = Point.new([@left.x,@right.x].min,[@left.y,@right.y].max)
      @bottom_right = Point.new([@left.x,@right.x].max,[@left.y,@right.y].max)
    end

    def top_left
      @top_left
    end

    def top_right
      @top_right
    end

    def bottom_left
      @bottom_left
    end

    def bottom_right
      @bottom_right
    end

    def ==(other)
      return true if other.top_left == @top_left and other.bottom_right == @bottom_right
      false
    end

    alias_method :eql?, :==

    private :set_left, :set_right, :set_vertices
  end

  class Canvas
    HTML_SYMBOL_LENGTH = 7
    ASCII_CODE = {0 => '-', 1 => '@'}
    HTML_CODE = {0 => '<i></i>', 1 => '<b></b>'}
    HTML_BEGIN = ' <!DOCTYPE html>
                    <html>
                    <head>
                      <title>Rendered Canvas</title>
                      <style type="text/css">
                        .canvas {
                          font-size: 1px;
                          line-height: 1px;
                        }
                        .canvas * {
                          display: inline-block;
                          width: 10px;
                          height: 10px;
                          border-radius: 5px;
                        }
                        .canvas i {
                          background-color: #eee;
                        }
                        .canvas b {
                          background-color: #333;
                        }
                      </style>
                    </head>
                    <body>
                      <div class="canvas">'
    HTML_END = '  </div>
                </body>
                </html>'
    def initialize(width, height)
      @width = width
      @height = height
      @pixels = Array.new(width*height, 0)
    end

    def width
      @width
    end

    def height
      @height
    end

    def set_pixel(x, y)
      @pixels[x + @width*y] = 1
    end

    def pixel_at?(x, y)
      @pixels[x + @width*y] == 1
    end

    def draw(figure)
      set_pixel(figure.x,figure.y) if figure.class == Point
      draw_line(figure.from,figure.to) if figure.class == Line
      draw_rectangle(figure) if figure.class == Rectangle
    end

    def draw_line(from, to)
      set_pixel(from.x, from.y)
      set_pixel(to.x,to.y)
      draw_sub_line(from, to)
    end

    def draw_sub_line(from, to)
      return if from.distance(to) <= 1.5
      return if from == to
      mid_point = Point.new((from.x + to.x)/2, (from.y+to.y)/2)
      set_pixel(mid_point.x, mid_point.y)
      if not from == mid_point then draw_sub_line(from, mid_point) end
      if not to == mid_point then draw_sub_line(mid_point, to) end
    end

     def draw_rectangle(rectangle)
      draw_line(rectangle.top_left, rectangle.top_right)
      draw_line(rectangle.top_right, rectangle.bottom_right)
      draw_line(rectangle.bottom_right, rectangle.bottom_left)
      draw_line(rectangle.bottom_left, rectangle.top_left)
    end

    def render_as(render_type)
      return render_ascii if render_type == Renderers::Ascii
      return render_html if render_type == Renderers::Html
    end

    def render_ascii
      pixels_ascii = @pixels.map{ |x| ASCII_CODE[x]}.reduce(:+)
      pixels_ascii.scan(/.{#{@width}}|.+/).join("\n")[0..-1]
    end

    def render_html
      html_line_length = @width * HTML_SYMBOL_LENGTH
      pixels_html = @pixels.map{ |x| HTML_CODE[x]}.reduce(:+)
      pixels_html =  pixels_html.scan(/.{#{html_line_length}}|.+/).join("<br>")[0..-1]
      HTML_BEGIN + pixels_html + HTML_END
    end

    private :draw_line, :draw_rectangle, :draw_sub_line, :render_html, :render_ascii

  end
end