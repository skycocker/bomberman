require "bundler/setup"
require "gaminator"

class Bomberman
  class Brick < Struct.new(:x, :y)
    def char
      "#"
    end
    
    def color
      Curses::COLOR_RED
    end
  end
  
  class Player < Struct.new(:x, :y)
    def char
      "^"
    end
    
    def color
      Curses::COLOR_GREEN
    end
  end
  
  class Target < Struct.new(:x, :y)
    def char
      "#"
    end
    
    def color
      Curses::COLOR_BLUE
    end
  end
  
  def initialize(width, height)
    @width = width
    @height = height
    @bomberman = Player.new(@width / 5, @height - 5)
    @bricks = []
    @target = Target.new(rand(@width), rand(@height))
  end
  
  def objects
    [@bomberman] + @bricks + [@target]
  end
  
  def collision?
    @bricks.any? do |brick|
      brick.y == @bomberman.y &&
        brick.x == @bomberman.x
    end
  end
  
  def check_collision
    if collision?
      @winstatus = "you've been killed."
      exit
    end
  end
  
  def spawn_bricks
    counter = (rand * 1.5).to_i
    counter.times do
      @bricks << Brick.new(rand(@width), rand(@height))
    end
    
    #counter = (rand * 1.5).to_i
    #counter.times do
    #  @bricks << Brick.new(rand(@width), 0)
    #end
  end
  
  def input_map
    {
      ?a => :move_left,
      ?d => :move_right,
      ?w => :move_up,
      ?s => :move_down,
      ?k => :place_bomb
    }
  end
  
  def sleep_time
    0.05
  end
  
  def move_left
    if @bomberman.x > 0
      spawn_bricks
      @bomberman.x -= 1
    end
  end
  
  def move_right
    if @bomberman.x < @width - 1
      spawn_bricks
      @bomberman.x += 1
    end
  end
  
  def move_up
    if @bomberman.y > 0
      @bomberman.y -= 1 
    end
  end
  
  def move_down
    if @bomberman.y < @height - 1
      @bomberman.y += 1 
    end
  end
  
  def place_bomb
    if @bomberman.x == @target.x and @bomberman.y == @target.y
      @winstatus = "you did it!"
      exit
    else
      print "missed it :("
    end
  end
  
  def tick
    spawn_bricks
    check_collision
  end
  
  def textbox_content
    "Use WSAD to move and K to place a bomb. Your objective is to place a bomb on the blue brick without touching the red ones."
  end
  
  def exit_message
    @winstatus
  end
  
  def wait?
    false
  end
end

Gaminator::Runner.new(Bomberman, rows: 30, cols: 80).run
