require 'rails_helper'
require 'jwt'

RSpec.describe Api::UsersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @token = JWT.encode({id: @user.id}, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers.merge!('Authorization' => "Bearer #{@token}")
    request.headers.merge!('content-type' => 'application/json')
    request.headers.merge!('Accept' => 'application/json')
  end

  context '#update' do
    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :update, params: {user: {name: 'TestName'}}, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http Forbidden for user with no role' do
      request.headers.merge!('Authorization' => "Bearer #{@token}")
      get :update, params: {user: {name: 'TestName'}}, format: 'json'
      expect(response.status).to eq 403
    end

    it 'returns http Forbidden for user with non admin role' do
      @user.add_role :customer
      @user.add_role :support
      request.headers.merge!('Authorization' => "Bearer #{@token}")
      get :update, params: {user: {name: 'TestName'}}, format: 'json'
      expect(response.status).to eq 403
    end

    it 'returns http success' do
      @user.add_role :admin
      get :update, params: {user: {name: 'TestName'}}, format: 'json'
      expect(response.status).to eq 200
    end
  end
end
