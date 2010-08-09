CONFIG = {
  
  :joy => { # joystick configuration
    :dev => '/dev/input/js0',
    :factor => (32000.0)
    },
  
  :log => { # log config (not used)
    :joy   => nil,
    :pos   => nil,
    :event => nil,
    :collision => nil,
    :camera => nil,
    :debug => nil
  },
  
  :mouse => {
    :speed_factor => 0.2
    },
  
  :draw => {
    :screen_width => 800,
    :screen_height => 600,
    :point_size  =>6,
    :constraints => true,
    :forces => false,
    :menu => false
    },
    
  :cam => {
    :follow => true,
    :rotate => 0    # distance of rotation, 0 = no rotation
    }
  
}
