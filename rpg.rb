# Defining the backbone of all creatures
class Creature
  $livingmonsters = []
  def self.metaclass
    class << self
      self
    end
  end
  
  def self.traits( *args )
    # If no arguments are found, then return list of current traits
    return @traits if args.empty?
    
    # Set up the attribute accessor methods for the traits
    attr_accessor( *args )
    
    # Define the (class) methods for the traits in the class
    args.each do |trait|
      metaclass.instance_eval do
        define_method( trait ) do |value|
          @traits ||= {}
          @traits[trait] = value
        end
      end
    end
    # Initialize the class with the values for each trait
    class_eval do
      define_method( :initialize ) do
        self.class.traits.each do |trait,value|
          instance_variable_set("@#{trait}",value)
          puts "The trait [#{trait}] of [#{self}] has been set to [#{value}]."
        end
        $livingmonsters.push( self )
      end
    end
  end
  
  def self.stats
    return @traits
  end
  # Define the possible traits
  traits :life, :strength
  
  # Time to define actions!
  
  # Hit target with specified power -- meta-method
  def hit( power )
    @life -= power
    # Maybe remove this?
    if @life <= 0
      puts "#{self} died!"
      # Remove dead monster from the list of living monsters
      $livingmonsters.delete( self )
    end
  end
  def fight( target )
    # Check if the fighter is alive
    if self.life <= 0
      puts "[#{ self.class } is dead and cannot fight!]"
      return
    end
    
    # Check if target is already dead
    if target.life <= 0
      puts "[Gah. #{target} is already dead!]"
      return
    end
    
    # Calculate the strength of the hit and hit the enemy with it!
    player_hit = rand( strength * 2 )
    # Check if the player hit himself
    if self == target
      puts "[You hit yourself with #{player_hit} points of damage.]"
    else
      puts "[Hit calculated to #{player_hit} points of damage.]"
    end
    target.hit( player_hit )
    
    # Check if target died
    if target.life <= 0
      "[You killed #{target}!]"
    end
  end
end

class RandomMonster < Creature
  life 100
  strength 50
end