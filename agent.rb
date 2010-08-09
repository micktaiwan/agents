require 'vector'
require 'goal'
require 'action'

class Agent

  #attr_accessor :agent_list

  def initialize
    @goals = []
    @goals << Goal.new(Goal::SEARCH_FOOD)
    @pos = MVector.new
    list
  end
  
  def do_action 
    gather_inputs
    think
    case @next_action.type
      when Action::MOVE
        @pos += @next_action.argument
    end
    
  end
  
  def gather_inputs
    @inputs = []
  end
  
  # fonction of @inputs and @goals
  def think
    @next_action = Action.new(Action::MOVE, MVector(0.01, 0, 0))
  end

  def draw
    GL.PushMatrix()
      GL.Translate(@pos.x, @pos.y, @pos.z+0.5)
      GL.CallList(@agent_list)
    GL.PopMatrix()
  end
  
private

  def list
    m_r = 0.5
    @agent_list = GL.GenLists(1)
    GL.NewList(@agent_list, GL::COMPILE)
      GL.Begin(GL::POLYGON)
          GL.Vertex3d(-m_r, m_r, m_r)
          GL.Vertex3d(-m_r, -m_r, m_r)
          GL.Vertex3d( m_r, -m_r, m_r)
          GL.Vertex3d( m_r, m_r, m_r)
      GL.End

      GL.Begin(GL::POLYGON)
          GL.Vertex3d( m_r, m_r, -m_r)
          GL.Vertex3d( m_r, -m_r, -m_r)
          GL.Vertex3d( -m_r, -m_r, -m_r)
          GL.Vertex3d( -m_r, m_r, -m_r)
      GL.End

      GL.Begin(GL::POLYGON)                 
          GL.Vertex3d( m_r, m_r, m_r)
          GL.Vertex3d( m_r, -m_r, m_r)
          GL.Vertex3d( m_r, -m_r, -m_r)
          GL.Vertex3d( m_r, m_r, -m_r)
      GL.End

      GL.Begin(GL::POLYGON)
          GL.Vertex3d( -m_r, m_r, m_r)
          GL.Vertex3d( -m_r, m_r, -m_r)
          GL.Vertex3d( -m_r, -m_r, -m_r)
          GL.Vertex3d( -m_r, -m_r, m_r)
      GL.End

      GL.Begin(GL::POLYGON)
          GL.Vertex3d( -m_r, -m_r, m_r)
          GL.Vertex3d( -m_r, -m_r, -m_r)
          GL.Vertex3d( m_r, -m_r, -m_r)
          GL.Vertex3d( m_r, -m_r, m_r)
      GL.End

      GL.Begin(GL::POLYGON)                 
          GL.Vertex3d( -m_r, m_r, m_r)
          GL.Vertex3d( m_r, m_r, m_r)
          GL.Vertex3d( m_r, m_r, -m_r)
          GL.Vertex3d( -m_r, m_r, -m_r)
      GL.End

    GL.EndList
  end
  
end

