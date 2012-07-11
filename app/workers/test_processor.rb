class TestProcessor  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 4, :max_time => 30, :max_queue => 10, :wait_time => 1
  # @queue = :test

  @queue = :test_queue
  def self.perform(importer_id)
    time_now = Time.now
    while Time.now.to_i < (time_now.to_i + 120)
      
    end      
  end

end

def test
  cleaner_running = false
  Resque.working.each do |worker|
    if worker.to_s.split(":").last == "session_watcher_queue" then
      cleaner_running = true
    end 
  end
  
end