# frozen_string_literal: true

module API
  class Base < Grape::API
    prefix 'api'

    rescue_from ActiveRecord::RecordNotFound do |e|
      error!({ error: "Record not found" }, 400)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error!({ error: e }, 400)
    end

    mount SignIn
    mount SignUp
    mount PizzeriaPlaces
    mount Pizzas
    mount PizzeriaMenus
  end
end
