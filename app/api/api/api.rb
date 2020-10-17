# frozen_string_literal: true

module API
  class Base < Grape::API
    prefix 'api'

    mount SignIn
    mount SignUp
  end
end