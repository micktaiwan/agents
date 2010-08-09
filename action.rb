require 'vector'

class Action
  attr_reader :type, :argument

  MOVE = 1

  def initialize(t=nil,a=nil)
    @type = t
    @argument = a
  end

end

class MoveNorthAction < Action
  def initialize
    super(Action::MOVE, MVector.new(0.001,0,0))
  end
end
class MoveSouthAction < Action
  def initialize
    super(Action::MOVE, MVector.new(-0.001,0,0))
  end
end
class MoveEastAction < Action
  def initialize
    super(Action::MOVE, MVector.new(0,0.001,0))
  end
end
class MoveWestAction < Action
  def initialize
    super(Action::MOVE, MVector.new(0,-0.001,0))
  end
end

