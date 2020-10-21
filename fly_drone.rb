
class OrientationSenor
   attr_accessor :pitch, :roll
end

class Gyroscope
    attr_accessor :x, :y, :z
end

class Engine
   def initialize
       @power = 0
       @status = :off
    end
	
    def on
       @status = :on
    end
	
    def off
       @status = :off
    end
	
    def power_up
        @power = [@power + 1, 100].max
	end
	
    def power_down
        @power = [@power - 1, 0].min
    end
end


class Drone

    def initialize
        @engines = Array.new(4).fill(Engine.new) # front-left, front-right, back-left, back-right
        @gyroscope = Gyroscope.new
		@orientation_sensor = OrientationSenor.new
        @status = :off
    end
	
    def take_off
        @status = :moving
        @engines.each(&:on)
        @engines.each(&:power_up)
    end
	
    def stabilize
        @status = :hovering
        max_power = @engines.map(&:power).max
        @engines.each { |engine| engine.power = max_power }
    end
	
    def status
	
      if @status != :off && @engines.any?(&:off)
         # TODO: Need to find broken engine and stop diagonal engine
		 
 land raise EngineStopped
      end
	  
      raise TakeOffFailed if @gyroscope.z.zero? && @engines.map(&:power).all?(&:positive?)
      @status
	  
    end
	
    def land
        stabilize
        while y > 0
          move_down
        end
        @engines.each(&:off)
    end
	
    def move_forward
        stabilize
        @status = :moving
        roll(10) # angle
    end
	
    def move_backward
        stabilize
        @status = :moving
        roll(-10) # angle
    end
	
    def move_left
        stabilize
        @status = :moving
        pitch(10) # angle
    end
	
    def move_right
        stabilize
        @status = :moving
        pitch(-10) # angle
    end
	
    def move_up
        stabilize
        @status = :moving
        @engines.each(&:power_up)
    end
	
    def move_down
        stabilize
        @status = :moving
        @engines.each(&:power_down)
    end
	
    def roll(angle)
	
        if angle.positive?
           @engines[0].power_down
           @engines[1].power_down
           @engines[2].power_up
           @engines[3].power_up
        else
           @engines[0].power_up
           @engines[1].power_up
           @engines[2].power_down
           @engines[3].power_down
		end
    end

def pitch(angle)
    if angle.positive?
    @engines[1].power_down
    @engines[2].power_down
    @engines[0].power_up
    @engines[3].power_up
   else
    @engines[1].power_up
    @engines[2].power_up
    @engines[0].power_down
    @engines[3].power_down
  end
end
end