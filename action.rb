class Action
  attr_reader :type, :argument
  
  MOVE = 1
  
  def initialize(t=nil,a=nil)
    @type = t
    @argument = a
  end
  
end
