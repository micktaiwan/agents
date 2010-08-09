# Written in Ruby from scratch by Mickael, so it might not be as good as you expect :)
# References:
#     http://en.wikipedia.org/wiki/A-star_search_algorithm
#     http://www.policyalmanac.org/games/aStarTutorial.htm
#     http://theory.stanford.edu/~amitp/GameProgramming/

# this file contains a method for clients to find the best way in the map to a target case
# the algorithm used is the A* algorithm.
# A* is explained in the references given above


if __FILE__ == $0 # defined only if this file is used in standalone mode for testing purpose, otherwise use the Map.rb implementation


class Map

   attr_accessor :w, :h # width and height
   attr_accessor :hash  # obstacles

   def initialize
      @w = 20
      @h = 20
      @hash = [[2,0],[2,1],[1,1]]
   end

   def has_obstacle(n)
      #puts pnode(n)
      return true if(@hash.include?(n))
      return nil
   end

end # class Map

end # if __FILE__


##########################################################################


def out s
   #puts s # comment out to get rid of the print out
end

def pnode(n)
   "(#{n[0]},#{n[1]})"
end

# format a path for printing
def ppath(p)
   return "(no path)" if p == nil
   str = ""
   p.each { |n,h|
      str += pnode(n)
      }
   str
end

##########################################################################
# caution: not optimized
class MQueue

   def initialize
      #puts 'Queue'
      clear()
   end

   def clear
      #puts 'ok'
      @q = []  # array of path arrays [path] themselves arrays of [node,heuritic]
   end

   # add a node and its H to a new path
   def add_path(p) # node, heuristic
      @q.each_index { |i|
         if(@q[i][-1][1] > p[-1][1]) # sort the queue based on H, puts best H first
            @q.insert(i,p)
            return
         end
         }
      @q << p
   end

   def size; @q.size; end
   def shift; @q.shift; end
end

##########################################################################
class Pathfinder

   attr_accessor :ignore_obs_target
   
   def initialize(map)
      #puts 'PathFinder'
      @map = map
      @q = MQueue.new
      @ignore_obs_target = false # if true, then the target is never an obstacle
   end

   def manhattan(c,t) # Current, Target
      1*((c[0]-t[0]).abs + (c[1]-t[1]).abs) # 1 is the weight of a node, could be more, it depends on the function used
   end

   #return a array of adjacent nodes without testing validity
   def adjacent_nodes(n)
      [ [n[0]-1, n[1] ] , [ n[0]+1, n[1] ] , [ n[0], n[1]-1 ] , [ n[0], n[1]+1] ]
   end

   # test if the node is valid (contains no obstacles, and is in the map)
   def is_valid(n)
      return true if n==@target and @ignore_obs_target == true
      return nil if(n[0]<0 or n[1]<0 or n[0]>=@map.w or n[1]>=@map.h)
      return nil if @map.has_obstacle(n)
      return true
   end

   # returns the set of paths created by extending p with one neighbor node.
   # the path can contain the node from wich we came from: [A, B, C, D] and add C again to the path
   # this path is invalidated by the caller function
   def successors(p)
      return [] if @max > 0 and p.size >= @max # if the path is longer than the remaining actions points, we have no successor
      rv = []
      adjacent_nodes(extract_node(p[-1])).each { |n|
         next if not is_valid(n)
         rv << p+[make_NH(n)]
         }
      rv
   end

   # returns the node contained in [n,h], used only for code clarity
   def extract_node(e)
      e[0]
   end

   # make [n,h]: a couple of a node and its heuristic
   def make_NH(node)
      [node,manhattan(node,@target)] # the heurostic is manhattan, but could be based on another function
   end


   # return the best path from start to target
   # A* based
   def find(start,target,max=0)
      out "Finding a path from #{pnode(start)} to #{pnode(target)} with max #{max} nodes. The map contains #{@map.hash.size} obstacle(s)"
      @max = max
      @target = target
      closed = [] # cases we already analysed
      @q.add_path([make_NH(start)]) # initialize the queue by making the start node the first node of a new path
      while(@q.size > 0)
         p = @q.shift
         x = p[-1] # [n,h]: last node and its heuritic
         out "Analysing (#{extract_node(x)[0]},#{extract_node(x)[1]}): #{x[1]}"
         next if(closed.include?(extract_node(x)))
         return p if extract_node(x) == @target
         closed << extract_node(x)
         successors(p).each { |y| # y is a path (array of [n,h])
            @q.add_path(y) if not (closed.include?(extract_node(y[-1]))) #  y[-1] => last [n,h] of y
            }
      end # while
      return nil
   end

end # Pathfinder

if __FILE__ == $0 # defined only if it is the executed file (for testing purpose)

puts:"Map is:"
puts "A XB"
puts ".XX."
puts "...."

max = 8 # test with 8 first, and then with 7 to see what happen :)
map = Map.new
pf = Pathfinder.new(map)
path = pf.find([0,0],[3,0],max) # max is a optional parameter, default to "infinite"
puts "Path has #{path.size} nodes" if path != nil
puts ppath(path) 

end
