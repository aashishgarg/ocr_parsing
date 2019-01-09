require 'rails_helper'
require 'jwt'

RSpec.describe Api::BolTypesController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @token = JWT.encode({id: @user.id}, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers.merge!('Authorization' => "Bearer #{@token}")
    request.headers.merge!('content-type' => 'application/json')
    request.headers.merge!('Accept' => 'application/json')
  end
  context '#index' do
    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :index, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :index, format: 'json'
      expect(response.status).to eq 200
    end

    it 'returns empty array of BOL Types' do
      get :index, format: 'json'
      hash_body = JSON.parse(response.body).with_indifferent_access
      expect(hash_body).to match({bol_types: []})
    end
  end

  context '#show' do
    before do
      @bol_type = FactoryBot.create(:bol_type)
    end
    it 'returns http success' do
      get :show, params: {id: @bol_type.id}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :show, params: {id: @bol_type.id}, format: 'application/json'
      expect(response.status).to eq 401
    end
  end
end
