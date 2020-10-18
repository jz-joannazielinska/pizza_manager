# frozen_string_literal: true

describe 'pizzeria_menus' do
  let(:response_body) { JSON.parse(response.body) }

  describe 'get /api/pizzeria_menu' do
    let(:api_call) { get '/api/pizzeria_menu', params: params }

    describe 'failure' do
      context 'when pizzeria_place_id param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing'
      end
    end

    describe 'success' do
      let(:user) { create :user }
      let(:pizzeria_place) { create :pizzeria_place, user_id: user.id }
      let(:params) { { pizzeria_place_id: pizzeria_place.id } }

      context 'when there are no pizzas in menu' do
        it_behaves_like 'returns http status', status: 200

        it 'returns empty result' do
          api_call
          expect(response_body).to eq([].to_json)
        end
      end

      context 'when there are pizzas in menu' do
        let(:pizza) { create :pizza }
        let(:expected_result) do
          [
            {
              id: pizza.id,
              name: pizza.name,
              price: pizza.price,
              ingridients: pizza.ingridients,
              created_at: pizza.created_at,
              updated_at: pizza.updated_at
            }.stringify_keys
          ].to_json
        end

        before { PizzeriaMenu.create!(pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id) }

        it_behaves_like 'returns http status', status: 200
        it 'returns pizzas' do
          api_call
          expect(response_body).to eq(expected_result)
        end
      end
    end
  end

  describe 'post /api/pizzeria_menu' do
    let(:api_call) { post '/api/pizzeria_menu', params: params }
    let(:user) { create :user }
    let(:pizzeria_place) { create :pizzeria_place, user_id: user.id }
    let(:pizza) { create :pizza }
    let(:params) { { pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id } }

    describe 'failure' do
      context 'when params are empty' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing, pizza_id is missing'
      end

      context 'when record already exists' do
        before { PizzeriaMenu.create(pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id) }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Validation failed: Pizzeria place has already been taken'
      end
    end

    describe 'success' do
      it_behaves_like 'returns http status', status: 200

      it 'creates a new record' do
        expect { api_call }.to change { PizzeriaMenu.count }.by(1)
      end

      context 'when there are are already some pizzas in menu' do
        let(:new_pizza) { create(:pizza) }
        let(:params) { { pizzeria_place_id: pizzeria_place.id, pizza_id: new_pizza.id } }

        before { PizzeriaMenu.create(pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id) }

        it_behaves_like 'returns http status', status: 200

        it 'creates a new record' do
          expect { api_call }.to change { PizzeriaMenu.count }.by(1)
        end
      end
    end
  end

  describe 'delete /api/pizzeria_menu' do
    let(:api_call) { delete '/api/pizzeria_menu', params: params }
    let(:user) { create :user }
    let(:pizzeria_place) { create :pizzeria_place, user_id: user.id }
    let(:pizza) { create :pizza }
    let(:params) { { pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id } }

    describe 'failure' do
      context 'when params are empty' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing, pizza_id is missing'
      end

      context 'when record does not exist' do
        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      before { PizzeriaMenu.create(pizzeria_place_id: pizzeria_place.id, pizza_id: pizza.id) }

      it_behaves_like 'returns http status', status: 200

      it 'removes the record' do
        expect { api_call }.to change { PizzeriaMenu.count }.from(1).to(0)
      end
    end
  end
end
