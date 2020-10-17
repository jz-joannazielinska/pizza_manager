# frozen_string_literal: true

class SignIn < Grape::API
  format :json
  desc 'Endpoint for sign in'
  namespace :sign_in do
    desc 'Sign in using email and password'
    params do
      requires :email, type: String, desc: 'email'
      requires :password, type: String, desc: 'password'
    end

    post do
      user = User.find_by_email params[:email]
      if user.present? && user.valid_password?(params[:password])
        status 200
      else
        error_msg = 'Bad Authentication Parameters'
        error!({ error: error_msg }, 401)
      end
    end
  end
end
