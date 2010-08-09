#!/usr/bin/ruby
require 'config'
require 'world'
require 'agent'
require 'resource'
require 'openglmenu'

class SpaceWorld < World

  attr_accessor :cam, :console

  def initialize
    super
    @agents   = []
    1.upto(10) {
      a         = SearchFoodAgent.new(MVector.new(rand(10)-5,rand(10)-5,0))
      @agents   << a
      add_object(a)
      }
    1.upto(10) {
      add_object(Resource.new(rand(5)-2,rand(5)-2,0))
      }
    @console.push("hello, nothing much for now")
  end

  def draw
    t = GLUT.Get(GLUT::ELAPSED_TIME)
    # clear
    GL.Clear(GL::COLOR_BUFFER_BIT | GL::DEPTH_BUFFER_BIT)
    GL::LoadIdentity()

    # camera
    GL.Rotate(@cam.rot.x, 1.0, 0.0, 0.0)
    GL.Rotate(@cam.rot.y, 0.0, 1.0, 0.0)
    GL.Rotate(@cam.rot.z, 0.0, 0.0, 1.0)
    GL.Translate(-@cam.pos.x, -@cam.pos.y, -@cam.pos.z)

    # give inputs to agents and make them think
    @agents.each { |a|
      a.inputs = @objects
      a.do_action
      }

    # main drawing
    # ground
    GL.CallList(@ground_list)
    draw_objects
    draw_console
    if CONFIG[:draw][:menu]
      enable_2D
      @menu.draw
      disable_2D
    end

    # END
    GLUT.SwapBuffers()

    @frames += 1

    if CONFIG[:cam][:rotate] > 0
      x = @cam.pos.x = Math.cos(t/5000.0)*CONFIG[:cam][:rotate]
      y = @cam.pos.y = Math.sin(t/5000.0)*CONFIG[:cam][:rotate]
      scale = 45/Math.atan(1)
      a = (scale*Math.atan2(y,x))+90
      @cam.rot.z = -a
    end

    # done after rotate so the cam still follow if told to do so
    @cam.follow if CONFIG[:cam][:follow]

    if t - @t0 >= 1000
      seconds = (t - @t0) / 1000.0
      @fps = @frames / seconds
      @t0, @frames = t, 0
      exit if defined? @autoexit and t >= 999.0 * @autoexit
    end
  end

  def key(k, x, y)
    if CONFIG[:draw][:menu]
      rv = @menu.key(k)
      CONFIG[:draw][:menu] = nil if rv == :quit
      return
    end
    case k
      when 13 # Enter
    end
    super
  end

  def special(k, x, y)
    case k
      when GLUT::KEY_UP
        @cam.pos.y += 1
      when GLUT::KEY_DOWN
        @cam.pos.y -= 1
      when GLUT::KEY_LEFT
        @cam.pos.x -= 1
      when GLUT::KEY_RIGHT
        @cam.pos.x += 1
      when GLUT::KEY_F1
        CONFIG[:draw][:menu] = CONFIG[:draw][:menu]? nil : true
    end
    super
  end

  # initializes opengl
  def init
    GLUT.InitDisplayMode(GLUT::RGBA | GLUT::DEPTH | GLUT::DOUBLE)
    GLUT.InitWindowPosition(0, 0)
    GLUT.InitWindowSize(CONFIG[:draw][:screen_width],CONFIG[:draw][:screen_height])
    GLUT.CreateWindow('mecha')
    GL.ClearColor(0.0, 0.0, 0.0, 0.0)
    GL.ShadeModel(GL::SMOOTH)
    GL.DepthFunc(GL::LEQUAL)
    GL.Hint(GL::PERSPECTIVE_CORRECTION_HINT, GL::NICEST)
    GL.Enable(GL::DEPTH_TEST)
    GL.Enable(GL::NORMALIZE)
    GL::Enable(GL::POINT_SMOOTH)
    GL::Enable(GL::BLEND) # for the menu

    @ground_list = GL.GenLists(1)
    GL.NewList(@ground_list, GL::COMPILE)
      draw_grid
    GL.EndList()

    @menu     = OpenGLMenu.new

    err = GL.GetError
    raise "GL Error code: #{err}" if err != 0
  end


private


  def draw_board
    enable_2D
    GL::Color(0, 1, 0, 1)
    disable_2D
  end

  def draw_console
    enable_2D
    # FPS
    GL::Color(1, 1, 0, 1)
    @console.text_out(10,@screen_height-30, GLUT_BITMAP_HELVETICA_18, @fps.to_i.to_s + " fps")
    @console.draw
    disable_2D
  end

  def draw_control(place, value, max)
    GL.Begin(GL::LINE_LOOP)
      GL.Vertex2f(10+place*25, 2)
      GL.Vertex2f(30+place*25, 2)
      GL.Vertex2f(30+place*25, 82)
      GL.Vertex2f(10+place*25, 82)
    GL.End()
    GL.Begin(GL::QUADS)
      GL.Vertex2f(10+place*25, 2+(value/max.to_f)*80)
      GL.Vertex2f(30+place*25, 2+(value/max.to_f)*80)
      GL.Vertex2f(30+place*25, 2)
      GL.Vertex2f(10+place*25, 2)
    GL.End()
  end

end

s = SpaceWorld.new
s.start

