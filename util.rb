class Numeric
  TO_RAD = Math::PI / 180.0
  TO_DEG = 180.0 / Math::PI
  def to_rad
    self * TO_RAD
  end
  def to_deg
    self * TO_DEG
  end
end

module Util
  # return true if a is nearest than b from o
  def self.nearest(o,a,b)
    return true if ((o.pos-a.pos).length < (o.pos-b.pos).length)
    return false
  end

  def self.distance(a,b)
    (a.pos-b.pos).length
  end
end

