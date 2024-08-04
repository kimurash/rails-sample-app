class ApplicationController < ActionController::Base
  # どのコントローラからでもログイン関連のメソッドを
  # 呼び出せるようにする
  include SessionsHelper
end
