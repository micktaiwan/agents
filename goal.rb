require 'util'

class Goal

  def initialize
  end

end

class SearchFoodGoal < Goal

  def initialize
  end

  def evaluate(projected_self)
    food = select_nearest_food(projected_self)
    return 0 if not food
    Util.distance(food, projected_self) # the smaller, the better
  end

  def select_nearest_food(projected_self)
    nearest = nil
    projected_self.inputs.each{ |o|
      next if o.respond_to?(:do_action)
      nearest = o if not nearest or Util.nearest(projected_self, o, nearest)
      }
    nearest
  end


end

class SurviveGoal < Goal

  def initialize
  end

  def evaluate(projected_self)
    agent = select_nearest_agent(projected_self)
    -Util.distance(projected_self,agent) # the greater, the better
  end

  def select_nearest_agent(projected_self)
    nearest = nil
    projected_self.inputs.each{ |o|
      next if not o.respond_to?(:do_action) or o == projected_self
      nearest = o if not nearest or Util.nearest(projected_self, o, nearest)
      }
    nearest
  end

end

