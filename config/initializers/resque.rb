# To change this template, choose Tools | Templates
# and open the template in the editor.

module Resque
  def redis_check
    begin 
      workers = working
    rescue
      wasGood = system( "./bin/redis-server ./bin/redis.conf > ./log/redis-server.log &" ) 
    end
  end 
end
