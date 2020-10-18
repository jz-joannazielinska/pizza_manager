# frozen_string_literal: true

class SignUp < Grape::API
  format :json
  desc 'Endpoint for sign up'
  namespace :sign_up do
    desc 'Sign up using email and password'
    params do
      requires :email, type: String, desc: 'email'
      requires :password, type: String, desc: 'password'
    end

    helpers do
      def email
        params[:email]
      end

      def password
        params[:password]
      end

      def check_if_params_present
        error!({ error: 'Invalid request: params missing' }) if params.nil?
        error!({ error: 'Invalid request: email param missing' }) if email.nil?
        error!({ error: 'Invalid request: password param missing' }) unless password.nil?
      end

      def check_if_params_valid
        error!({ error: 'Invalid email: email cannot be blank' }) if email.blank?
        error!({ error: 'Invalid password: password cannot be blank' }) if password.blank?
      end
    end

    post do
      check_if_params_valid
      user = User.find_by_email(email)
      error!({ 'error' => 'User already exists' }, 401) if user.present?

      User.create!(email: email, password: password)
      status 200
    end
  end
end
