require 'vector'
require 'goal'
require 'action'

class Agent

  attr_accessor :pos

  attr_accessor :inputs

  def initialize
    @goals = []
    @pos = MVector.new
    @inputs = []
    @actions = []
    opengl_list
  end

  def do_action
    @next_action = think(self)
    return if @next_action == nil
    case @next_action.type
      when Action::MOVE
        @pos += @next_action.argument
    end

  end

  # for each actions I could do evaluate the state compared to goals
  def think(current_self)
    return nil if @actions.size == 0
    results = []
    @actions.each { |a|
      projected_self  = current_self + a
      note            = evaluate_performance(projected_self)
      results << [a,note, projected_self]
      }
    results = results.sort_by { |r| -r[1]}
    # @next_action = Action.new(Action::MOVE, MVector(0.01, 0, 0))
    results[0][0] # return the best action
  end

  # fonction of @inputs and @goals
  def evaluate_performance(projected_self)
    obj = @inputs[1]
    -(obj.pos - projected_self.pos).length
  end

  def +(action)
    projected_self = self.deep_copy
    case action.type
      when Action::MOVE
        projected_self.pos += action.argument
    end
    projected_self
  end

  def draw
    GL.PushMatrix
      GL.Translate(@pos.x, @pos.y, @pos.z+0.5)
      GL.CallList(@agent_list)
    GL.PopMatrix
  end

  def deep_copy
    Marshal::load(Marshal.dump(self))
  end

private

  def opengl_list
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

class SearchFoodAgent < Agent
  def initialize
    super
    @goals << Goal.new(Goal::SEARCH_FOOD)
    @actions << MoveNorthAction.new
    @actions << MoveSouthAction.new
    @actions << MoveEastAction.new
    @actions << MoveWestAction.new
  end
end

