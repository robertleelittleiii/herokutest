class CustomerActionsController < ApplicationController
  def order_history
      @user = User.find_by_id(session[:user_id])
      @orders = @user.orders
  end

end
