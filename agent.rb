require 'vector'
require 'goal'
require 'action'
require 'util'

class Agent

  attr_accessor :pos, :inputs
  SURVIVE     = 1
  SEARCH_FOOD = 2

  def initialize(pos=nil)
    @pos      = pos ? pos : MVector.new
    @goals    = []
    @inputs   = []
    @actions  = []
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

  def draw
    GL.PushMatrix
      GL.Translate(@pos.x, @pos.y, @pos.z+0.1)
      GL.CallList(@agent_list)
    GL.PopMatrix
  end

  # returns a new world after doing the action
  def +(action)
    projected_self = self.deep_copy
    case action.type
      when Action::MOVE
        projected_self.pos += action.argument
    end
    projected_self
  end

  def deep_copy
    Marshal::load(Marshal.dump(self))
  end

private

  # for each actions I could do, evaluate the state compared to goals
  def think(current_self)
    return nil if @actions.size == 0
    results = []
    @actions.each { |a|
      projected_self  = current_self + a
      note            = evaluate_performance(projected_self)
      results << [a,note, projected_self]
      }
    results = results.sort_by { |r| r[1]} # the smaller, the better
    results[0][0] # return the best action
  end

  # fonction of @inputs and @goals
  def evaluate_performance(projected_self)
    return @goals.inject(0) { |sum, g|
      sum += g.evaluate(projected_self)
      }
  end

  def goal_factor(g)
    s   = @goals.size
    pos = @goals.index(g)
    return 0 if not pos
    return s - pos
  end


  def opengl_list
    m_r = 0.1
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
  def initialize(pos=nil)
    super(pos)
    @goals << SearchFoodGoal.new
    @goals << SurviveGoal.new
    @actions << MoveNorthAction.new
    @actions << MoveSouthAction.new
    @actions << MoveEastAction.new
    @actions << MoveWestAction.new
  end
end

