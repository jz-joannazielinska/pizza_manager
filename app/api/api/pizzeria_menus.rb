# frozen_string_literal: true

class PizzeriaMenus < Grape::API
  format :json
  desc 'Endpoint for handling pizzeria place menu'

  namespace :pizzeria_menu do
    desc 'Get pizzas list for restaurant'
    params do
      requires :pizzeria_place_id, type: String, desc: 'Uuid of pizzeria'
    end

    get do
      pizza_ids = PizzeriaMenu.where(pizzeria_place_id: params[:pizzeria_place_id]).to_a
                              .map(&:pizza_id)
      Pizza.where(id: pizza_ids).to_json
    end

    desc 'Add pizza to pizzeria menu'
    params do
      requires :pizzeria_place_id, type: String, description: 'uuid of pizzeria'
      requires :pizza_id, type: String, description: 'uuid of pizza'
    end

    post do
      PizzeriaMenu.create!(
        {
          pizzeria_place_id: params[:pizzeria_place_id],
          pizza_id: params[:pizza_id]
        }
      )
      status 200
    end

    desc 'Remove pizza from menu'
    params do
      requires :pizzeria_place_id, type: String, description: 'uuid of pizzeria'
      requires :pizza_id, type: String, description: 'uuid of pizza'
    end

    delete do
      record = PizzeriaMenu.find_by(
        pizzeria_place_id: params[:pizzeria_place_id],
        pizza_id: params[:pizza_id]
      )
      error!({ error: 'Record not found' }, 400) if record.nil?

      record.destroy!
      status 200
    end
  end
end
