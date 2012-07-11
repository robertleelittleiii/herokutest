class GeocodeProcessor  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 4, :max_time => 30, :max_queue => 10, :wait_time => 1
  # @queue = :test

  @queue = :geocode_queue
  def self.perform(mission_id)
   
    mission = Mission.find(mission_id)
    
    mission.status="Start"
    mission.status_percent=1
    mission.status_message="Begining Geo-code processing..."
    mission.save 
    
    mission.voter_scopes.each_with_index do |voter_scope, scope_index|
      households = voter_scope.households_in_scope().readonly(false)
      household_count = households.count.count
      
      
      households.each_with_index do |household, index|
        if household.longitude.blank? then 
          household.geocode
          #sleep 0.01
          puts(index,household.inspect)
          household.save
        end
        
        
        status_percent=Float(Float(index)/Float(household_count)*100)
        mission.reload
        if (mission.status=="Cancel") then
          mission.status="Canceling..." 
          mission.status_percent=100
          mission.status_message="Process Complete"
          mission.save
          return(false)
        end
        mission.status="Processing..." 
        mission.status_percent=status_percent.to_i
        mission.status_message="Processing Scope "+ scope_index.to_s + "(" + index.to_s + " of " + household_count.to_s + ")"
        mission.save
      end 
    end 

    mission.status="Complete"
    mission.status_percent=100
    mission.status_message="Process Complete"
    mission.save
  end 
end
