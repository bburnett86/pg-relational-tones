module ApplicationHelper

  def logged_in?
    return session[:user_id] != nil
  end

  def current_user
    if logged_in?
      return User.find(session[:user_id])
    end
    nil
  end

end
