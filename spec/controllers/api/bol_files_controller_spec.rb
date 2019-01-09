require 'rails_helper'
require 'jwt'

RSpec.describe Api::BolFilesController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @token = JWT.encode({id: @user.id}, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers.merge!('Authorization' => "Bearer #{@token}")
    request.headers.merge!('Content-Type' => 'application/json')
    request.headers.merge!('Accept' => 'application/json')
    @shipper = FactoryBot.create(:shipper)
  end

  context '#index' do
    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :index, params: {shipper_id: @shipper.id}, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :index, params: {shipper_id: @shipper.id}, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#show' do
    it '' do

    end
  end
end
