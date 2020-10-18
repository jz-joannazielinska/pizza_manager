# frozen_string_literal: true

class PizzeriaPlaces < Grape::API
  format :json
  desc 'Endpoint for handling pizzeria places'

  namespace :pizzeria_places do
    desc 'Get list of all restaurants'
    params do
      requires :user_id, type: String, desc: 'uuid of pizzeria owner'
    end

    get do
      PizzeriaPlace.where(user_id: params[:user_id]).to_json
    end
  end

  namespace :pizzeria_place do
    desc 'Get information about pizzeria'

    params do
      requires :pizzeria_place_id, type: String, desc: 'uuid of pizzeria'
    end

    get do
      PizzeriaPlace.find(params[:pizzeria_place_id]).to_json
    end

    desc 'Create a new pizzeria'
    params do
      requires :name, type: String, desc: 'restaurant name'
      requires :address, type: String, desc: 'address'
      requires :opens_at, type: String, desc: 'opening hour'
      requires :closes_at, type: String, desc: 'closing hour'
      requires :user_id, type: String, desc: 'id of pizzeria owner'
    end

    post do
      PizzeriaPlace.create!({
        name: params[:name],
        address: params[:address],
        opens_at: Time.parse(params[:opens_at]),
        closes_at: Time.parse(params[:closes_at]),
        user_id: params[:user_id]
      })
      status 200
    end

    desc 'remove a pizzeria'
    params do
      requires :pizzeria_place_id, type: String, desc: 'uuid of pizzeria'
    end

    delete do
      PizzeriaPlace.find(params[:pizzeria_place_id]).destroy!
      status 200
    end

    desc 'update a pizzeria'
    params do
      requires :pizzeria_place_id, type: String, desc: 'uuid of pizzeria'
      optional :address, type: String, desc: 'new address'
      optional :opens_at, type: String, desc: 'new opening hour'
      optional :closes_at, type: String, desc: 'new closing hour'
    end

    put do
      pizzeria_place = PizzeriaPlace.find(params[:pizzeria_place_id])
      params.delete(:pizzeria_place_id)
      new_attributes = params.delete_if { |key, value| value.blank? }
      pizzeria_place.update!(new_attributes)
      status 200
    end
  end
end
