require 'rails_helper'
require 'jwt'

RSpec.describe Api::BolTypesController do
  before do
    @user = FactoryBot.create(:user)
    @token = JWT.encode({id: @user.id}, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers.merge!('Authorization' => "Bearer #{@token}")
    request.headers.merge!('Content-Type' => 'application/json')
  end
  context '#index' do
    it 'responds with a 200 status' do
      get :index, format: 'json'
      expect(response.status).to eq 200
    end

    it 'responds with a 401 status' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :index, format: 'json'
      expect(response.status).to eq 401
    end
  end

  context '#show' do
    before do
      @bol_type = FactoryBot.create(:bol_type)
    end
    it 'responds with a 200 status' do
      get :show, params: {id: @bol_type.id}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'responds with a 401 status' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :show, params: {id: @bol_type.id}, format: 'json'
      expect(response.status).to eq 401
    end
  end
end
