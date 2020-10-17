# frozen_string_literal: true

describe '/api/sign_in' do
  let(:email) { 'user@mail,com' }
  let(:password) { 'password' }
  let!(:user) { create :user, email: email, password: password }
  let(:valid_params) { { email: email, password: password } }
  let(:params) { valid_params }
  let(:response_body) { JSON.parse(response.body) }

  def api_call
    post '/api/sign_in', params: params
  end

  describe 'failure' do
    context 'when missing params' do
      context 'when email missing' do
        let(:params) { { password: password } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'email is missing'
      end

      context 'when password missing' do
        let(:params) { { email: email } }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'password is missing'
      end

      context 'when both email and password missing' do
        let(:params) { {} }

        it_behaves_like 'returns http status', status: 400
        it_behaves_like 'returns error msg', msg: 'email is missing, password is missing'
      end
    end

    context 'when invalid params' do
      context 'when password is invalid' do
        let(:params) { { email: email, password: 'invalid_password' } }

        it_behaves_like 'returns http status', status: 401
        it_behaves_like 'returns error msg', msg: 'Bad Authentication Parameters'
      end

      context 'when email is invalid' do
        let(:params) { { email: 'invalid_email', password: 'password' } }

        it_behaves_like 'returns http status', status: 401
        it_behaves_like 'returns error msg', msg: 'Bad Authentication Parameters'
      end

      context 'when email and password are invalid' do
        let(:params) { { email: 'invalid_email', password: 'invalid_password' } }

        it_behaves_like 'returns http status', status: 401
        it_behaves_like 'returns error msg', msg: 'Bad Authentication Parameters'
      end
    end
  end

  describe 'success' do
    context 'with valid params' do
      it_behaves_like 'returns http status', status: 200
    end
  end
end