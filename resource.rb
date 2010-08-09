require 'vector'

class Resource

  attr_accessor :pos

  def initialize(x,y,z)
    @pos = MVector.new(x,y,z)
    list
  end

  def draw
    GL.PushMatrix()
      GL.Translate(@pos.x, @pos.y, @pos.z+0.1)
      GL.CallList(@agent_list)
    GL.PopMatrix()
  end

private

  def list
    m_r = 0.1
    @agent_list = GL.GenLists(1)
    GL.NewList(@agent_list, GL::COMPILE)
      GL.Color(1, 0, 0, 1)
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

