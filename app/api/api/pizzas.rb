# frozen_string_literal: true

class Pizzas < Grape::API
  format :json
  desc 'Endpoint for handling pizzeria places'

  namespace :pizzas do
    desc 'Get list of all pizzas'
    params do
      requires :pizzeria_place_id, type: String, desc: 'uuid of pizzeria'
    end

    get do
      ids = PizzeriaMenu.where(pizzeria_place_id: params[:pizzeria_place_id]).to_a
                        .map(&:pizza_id)
      Pizza.where(id: ids).to_json
    end
  end

  namespace :pizza do # rubocop:disable Metrics/BlockLength
    desc 'Get information about specific pizza'
    params do
      requires :pizza_id, type: String, desc: 'uuid of pizza'
    end

    get do
      Pizza.find(params[:pizza_id]).to_json
    end

    desc 'Create a new pizza'
    params do
      requires :name, type: String, desc: 'name of pizza'
      requires :price, type: Float, desc: 'pizza price'
      requires :ingridients, type: String, desc: 'description of ingridients'
    end

    post do
      Pizza.create!(
        {
          name: params[:name],
          price: params[:price],
          ingridients: params[:ingridients]
        }
      )

      status 200
    end

    desc 'Update a pizza'
    params do
      requires :pizza_id, type: String, desc: 'Uuid of pizza to be updated'
      optional :price, type: Float, desc: 'New price'
    end

    put do
      pizza = Pizza.find(params[:pizza_id])
      pizza.update!(price: params[:price]) unless params[:price].nil?
      status 200
    end

    desc 'Delete a pizza'
    params do
      requires :pizza_id, type: String, desc: 'Uuid of pizza to be updated'
    end

    delete do
      Pizza.find(params[:pizza_id]).destroy!
      status 200
    end
  end
end
