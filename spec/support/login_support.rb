module LoginSupport
  def logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: user.email,
                                          password:,
                                          remember_me: } }
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
