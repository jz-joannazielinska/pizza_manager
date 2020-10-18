# frozen_string_literal: true

describe 'pizzeria_places' do # rubocop:disable Metrics/BlockLength
  let(:response_body) { JSON.parse(response.body) }

  describe 'get /api/pizzeria_places' do # rubocop:disable Metrics/BlockLength
    let(:api_call) { get '/api/pizzeria_places', params: params }

    describe 'failure' do # rubocop:disbale Metrics/BlockLength
      context 'when user_id param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'user_id is missing'
      end
    end

    describe 'success' do # rubocop:disable Metrics/BlockLength
      let(:user) { create :user }
      let(:params) { { user_id: user.id } }

      context 'when user does not have any pizzerias' do
        it 'returns an empty json' do
          api_call
          expect(response_body).to eq([].to_json)
        end
      end

      context 'when user does have pizzeria places' do
        let!(:pizzeria_place) { create :pizzeria_place, user_id: user.id }
        let(:expected_result) do
          [
            {
              id: pizzeria_place.id,
              name: pizzeria_place.name,
              address: pizzeria_place.address,
              opens_at: pizzeria_place.opens_at,
              closes_at: pizzeria_place.closes_at,
              created_at: pizzeria_place.created_at,
              updated_at: pizzeria_place.updated_at,
              user_id: pizzeria_place.user_id
            }.stringify_keys
          ].to_json
        end

        it 'returns all pizzeria places' do
          api_call
          expect(response_body).to eq(expected_result)
        end
      end
    end
  end

  describe 'get /api/pizzeria_place' do # rubocop:disable Metrics/BlockLength
    let(:api_call) { get '/api/pizzeria_place', params: params }

    describe 'failure' do
      context 'when pizzeria_place_id param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing'
      end

      context 'when pizzeria place by given id does not exist' do
        let(:params) { { pizzeria_place_id: SecureRandom.uuid } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      let(:user) { create(:user) }
      let(:pizzeria_place) { create(:pizzeria_place, user_id: user.id) }
      let(:params) { { pizzeria_place_id: pizzeria_place.id } }
      let(:expected_result) do
        {
          id: pizzeria_place.id,
          name: pizzeria_place.name,
          address: pizzeria_place.address,
          opens_at: pizzeria_place.opens_at,
          closes_at: pizzeria_place.closes_at,
          created_at: pizzeria_place.created_at,
          updated_at: pizzeria_place.updated_at,
          user_id: pizzeria_place.user_id
        }.stringify_keys.to_json
      end

      it_behaves_like 'returns http status', status: 200

      it 'returns information about pizzeria place' do
        api_call
        expect(response_body).to eq(expected_result)
      end
    end
  end

  describe 'post /api/pizzeria_place' do # rubocop:disable Metrics/BlockLength
    let(:api_call) { post '/api/pizzeria_place', params: params }

    describe 'failure' do
      context 'when params are missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg',
          msg: 'name is missing, address is missing, opens_at is missing, closes_at is missing, user_id is missing'
      end

      context 'when pizzeria with provided params already exists' do
        let(:user) { create :user }
        let(:pizzeria_place) { create :pizzeria_place, user_id: user.id }
        let(:params) do
          {
            name: pizzeria_place.name,
            address: pizzeria_place.address,
            opens_at: pizzeria_place.opens_at,
            closes_at: pizzeria_place.closes_at,
            user_id: pizzeria_place.user_id
          }
        end

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Validation failed: Name has already been taken'
      end
    end

    describe 'success' do
      let(:user) { create :user }
      let(:params) do
        {
          name: 'name',
          address: 'address',
          opens_at: '10:00',
          closes_at: '20.00',
          user_id: user.id
        }
      end

      it_behaves_like 'returns http status', status: 200

      it 'creates a new pizzeria place' do
        expect { api_call }.to change { PizzeriaPlace.count }.by(1)
      end
    end
  end

  describe 'put /api/pizzeria_place' do # rubocop:disable Metrics/BlockLength
    let(:api_call) { put '/api/pizzeria_place', params: params }

    describe 'failure' do
      context 'when pizzeria_place_id param is missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing'
      end

      context 'when pizzeria by given id does not exist' do
        let(:params) { { pizzeria_place_id: SecureRandom.uuid } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      let(:user) { create :user }
      let(:pizzeria_place) { create :pizzeria_place, user_id: user.id }

      context 'when updating address' do
        context 'when new adrees is empty string' do
          let(:params) { { pizzeria_place_id: pizzeria_place.id, address: '' } }

          it_behaves_like 'returns http status', status: 200

          it 'does not update address' do
            api_call
            expect(pizzeria_place.reload.address).to eq(pizzeria_place.address)
          end
        end

        context 'when new address is valid' do
          let(:params) { { pizzeria_place_id: pizzeria_place.id, address: 'new address' } }

          it_behaves_like 'returns http status', status: 200

          it 'updates the address' do
            api_call
            expect(pizzeria_place.reload.address).to eq('new address')
          end
        end
      end
    end
  end

  describe 'delete /api/pizzeria_place' do
    let(:api_call) { delete '/api/pizzeria_place', params: params }

    describe 'failure' do
      context 'when missing params' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'pizzeria_place_id is missing'
      end

      context 'when pizzeria place by given id does not exist' do
        let(:params) { { pizzeria_place_id: SecureRandom.uuid } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'Record not found'
      end
    end

    describe 'success' do
      let(:user) { create :user }
      let!(:pizzeria_place) { create(:pizzeria_place, user_id: user.id) }
      let(:params) { { pizzeria_place_id: pizzeria_place.id } }

      it_behaves_like 'returns http status', status: 200

      it 'removes pizzeria place' do
        expect { api_call }.to change { PizzeriaPlace.count }.by(-1)
      end
    end
  end
end
