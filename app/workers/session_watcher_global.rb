class SessionWatcherGlobal  
  extend Resque::Plugins::Director
  direct :min_workers => 0, :max_workers => 1, :max_time => 30, :max_queue => 10, :wait_time => 1
  #direct :min_workers => 10, :max_workers => 0, :max_time => 1, :max_queue => 1, :wait_time => 1
  # @queue = :test

  @queue = :session_watcher_queue

  def self.perform(session_id)
    global_timeout = Settings.login_time_out.to_i
    session_list = ActiveRecord::SessionStore::Session.where("updated_at < ?",global_timeout.minutes.ago)

    while ActiveRecord::SessionStore::Session.all.size > 0
      
      session_list.each do |a_session|
        if not a_session.data["user_id"].nil? then
          user = User.find(a_session.data["user_id"])
          user.households.update_all(:user_id=>nil)
          user.voters.update_all(:user_id=>nil)
        end
        a_session.delete
        puts("Session Closed due to inactivity. ("+ global_timeout.to_s+" minute[s])")
      end
      
      sleep 1.minutes.to_i  
      global_timeout = Settings.login_time_out.to_i
      session_list = ActiveRecord::SessionStore::Session.where("updated_at < ?",global_timeout.minutes.ago)
    end
  end 
end
