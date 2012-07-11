class SessionWatcher  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 4, :max_time => 30, :max_queue => 10, :wait_time => 1
 #direct :min_workers => 10, :max_workers => 0, :max_time => 1, :max_queue => 1, :wait_time => 1
  # @queue = :test

  @queue = :session_watcher_queue

  def self.perform(session_id)
    session_record = ActiveRecord::SessionStore::Session.find_by_session_id(session_id)
    session = session_record.data
    puts("Session activated for user:" + session["user_id"].to_s)

    while not session["user_id"].nil?
      global_timeout = Settings.login_time_out.to_i

      # puts("in session watcher....")
      # puts("user-id:",session["user_id"], session_id, session["last_seen"], 2.minutes.ago)
      sleep 1.minutes.to_i  
      if session["active"] then
        if session["last_seen"] < global_timeout.minutes.ago
          user = User.find(session["user_id"])
          user.households.update_all(:user_id=>nil)
          user.voters.update_all(:user_id=>nil)
          session_record.delete
          puts("Session Closed due to inactivity. ("+ global_timeout.to_s+" minute[s])")
          break
        end
      end

      session_record = ActiveRecord::SessionStore::Session.find_by_session_id(session_id) 
      
      if session_record.nil? then
        user = User.find(session["user_id"])
        user.households.update_all(:user_id=>nil)
        user.voters.update_all(:user_id=>nil)
        puts("Session Closed due to logout.")
        break
        
      end
      
      session = session_record.data

    end
  end 
  
end

#  if session[:logged_in]
#    reset_session if session[:last_seen] < 2.minutes.ago
#    session[:last_seen] = Time.now
#  else
#    ... authenticate
#    session[:last_seen] = Time.now
#  end
