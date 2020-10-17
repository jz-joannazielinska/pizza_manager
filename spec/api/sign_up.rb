# frozen_string_literal: true

describe '/api/sign_up' do
  let(:email) { 'user@mail,com' }
  let(:password) { 'password' }
  let(:valid_params) { { email: email, password: password } }
  let(:params) { valid_params }
  let(:response_body) { JSON.parse(response.body) }

  def api_call
    post '/api/sign_up', params: params
  end

  describe 'failure' do
    context 'when missing params' do
      context 'when empty params' do
        let(:params) { { password: password } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'email is missing'
      end

      context 'when email param is missing' do
        let(:params) { { password: password } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'email is missing'
      end

      context 'when password param is missing' do
        let(:params) { { email: email } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'password is missing'
      end
    end

    context 'when invalid params' do
      context 'when empty email' do
        let(:params) { { email: '', password: password } }

        it_behaves_like 'returns http status', status: 500
        it_behaves_like 'returns error msg', msg: 'Invalid email: email cannot be blank'
      end

      context 'when empty password' do
        let(:params) { { email: email, password: '' } }

        it_behaves_like 'returns http status', status: 500
        it_behaves_like 'returns error msg', msg: 'Invalid password: password cannot be blank'
      end
    end

    context 'when user already exists' do
      let!(:user) { create :user, email: email, password: password }

      it_behaves_like 'returns http status', status: 401
      it_behaves_like 'returns error msg', msg: 'User already exists'
    end
  end

  describe 'success' do
    it_behaves_like 'returns http status', status: 200

    it 'creates a new user' do
      expect { api_call }.to change{ User.count }.by(1)
    end
  end
end