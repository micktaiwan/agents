require 'Utils'

INFINITY = 1.0 / 0.0

# Takes a state iterator and the maximum search depth and returns
# the best possible value and the best operation to execute.
#
# A state should implement
# * #each_successor (yield every successor state and the action that leads to the state)
# * #value (the heuristic that values the state)
# * #final? (true iff no successor states can be generated. See State#final?)
def alpha_beta(state, maxdepth = 10, alpha = -INFINITY, beta = INFINITY)
   return state.value, nil if (maxdepth == 0) or state.final?
   log 3, 3*3-(3*maxdepth), "============== entering alpha_beta: depth=#{maxdepth}"
   best_operation = []
   state.each_successor do | new_state, operation |
      
      val = -alpha_beta(new_state, maxdepth - 1, -beta, -alpha)[0]

      return beta, nil if (val >= beta)
     
      if (val > alpha)
        alpha = val
        best_operation = operation
      end    
   end

   if best_operation == nil
      log 3,0,"best_operation == nil"
   else
      log 3, 3*3-(3*maxdepth), "returing #{alpha}: #{sanitize(best_operation.join(','))}"
   end
   return alpha, best_operation
end


if __FILE__ == $0

map = AIMap.new
puts alpha_beta(map,0)

end
