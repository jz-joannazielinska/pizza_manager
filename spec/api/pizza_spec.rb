# frozen_string_literal: true

describe 'pizzas' do
  let(:response_body) { JSON.parse(response.body) }

  describe '/api/pizzas' do
    let(:api_call) { get '/api/pizzas', params: params }

    describe 'failure' do
      context 'when pizzeria_place_id param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing'
      end
    end

    describe 'success' do
      let(:user) { create(:user) }
      let(:pizzeria_place) { create(:pizzeria_place, user_id: user.id) }
      let(:pizza) { create(:pizza) }
      let(:params) { { pizzeria_place_id: pizzeria_place.id } }

      context 'when there are no pizzas in pizzeria menu' do
        it 'returns empty json' do
          api_call
          expect(response_body).to eq([].to_json)
        end
      end

      context 'when there are pizzas in pizzeria menu' do
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

        it 'returns pizzas' do
          api_call
          expect(response_body).to eq(expected_result)
        end
      end
    end
  end

  describe 'get /api/pizza' do
    let(:api_call) { get '/api/pizza', params: params }

    describe 'failure' do
      context 'when param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizza_id is missing'
      end

      context 'when pizza does not exist' do
        let(:params) { { pizza_id: SecureRandom.uuid } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      let(:pizza) { create(:pizza) }
      let(:params) { { pizza_id: pizza.id } }
      let(:expected_result) do
        {
          id: pizza.id,
          name: pizza.name,
          price: pizza.price,
          ingridients: pizza.ingridients,
          created_at: pizza.created_at,
          updated_at: pizza.updated_at
        }.stringify_keys.to_json
      end

      it 'returns pizza data' do
        api_call
        expect(response_body).to eq(expected_result)
      end
    end
  end

  describe 'post /api/pizza' do
    let(:api_call) { post '/api/pizza', params: params }

    describe 'failure' do
      context 'when params are missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'name is missing, price is missing, ingridients is missing'
      end

      context 'when some params are missing' do
        let(:params) { { name: 'Margharita', price: 45.00 } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'ingridients is missing'
      end

      context 'when pizza already exists' do
        let(:pizza) { create :pizza }
        let(:params) { { name: pizza.name, price: pizza.price, ingridients: pizza.ingridients } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Validation failed: Name has already been taken'
      end
    end

    describe 'success' do
      let(:params) do
        {
          name: 'pizza',
          price: 15.0,
          ingridients: 'tomato, basil, cheese'
        }
      end

      it 'creates a new pizza' do
        expect{ api_call }.to change{ Pizza.count }.by(1)
      end
    end
  end

  describe 'put /api/pizza' do
    let(:api_call) { put '/api/pizza', params: params }

    describe 'failure' do
      context 'when params are missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizza_id is missing'
      end

      context 'when pizza does not exist' do
        let(:pizza_id) { SecureRandom.uuid }
        let(:params) { { pizza_id: pizza_id, price: 25.00 } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      context 'when price param is present' do
        let(:pizza) { create :pizza }
        let(:params) { { pizza_id: pizza.id, price: 33.00 } }

        it 'updates a pizza' do
          api_call
          expect(pizza.reload.price).to eq(33.00)
        end
      end
    end
  end

  describe 'delete /api/pizza' do
    let(:api_call) { delete '/api/pizza', params: params }

    describe 'failure' do
      context 'when params are missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizza_id is missing'
      end

      context 'when pizza with given id does not exists' do
        let(:params) { { pizza_id: SecureRandom.uuid } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      let!(:pizza) { create :pizza }
      let(:params) { { pizza_id: pizza.id } }

      it 'removes a pizza' do
        expect { api_call }.to change{ Pizza.count }.by(-1)
      end
    end
  end
end