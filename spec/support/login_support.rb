module LoginSupport
  module Request
    def logged_in?
      !session[:user_id].nil?
    end

    def log_in_as(user, password: 'password', remember_me: '1')
      post login_path, params: { session: { email: user.email,
                                            password:,
                                            remember_me: } }
    end
  end

  module System
    def log_in_as(user, password: 'password', remember_me: true)
      visit login_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: password
      check 'Remember me on this computer' if remember_me
      click_button 'Log in'
    end
  end
end

RSpec.configure do |config|
  config.include LoginSupport::Request, type: :request
  config.include LoginSupport::System, type: :system
end
