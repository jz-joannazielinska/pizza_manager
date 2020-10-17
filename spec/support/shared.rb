# frozen_string_literal: true

shared_examples 'returns http status' do |status:|
  it 'returns http status' do
    api_call
    expect(response.status).to eq(status)
  end
end

shared_examples 'returns error msg' do |msg:|
  it "returns error msg #{msg}" do
    api_call
    expect(response_body['error']).to eq(msg)
  end
end

shared_examples 'returns 200 http status' do
  it 'returns 200 http status' do
    api_call
    expect(response.status).to eq(200)
  end
end
