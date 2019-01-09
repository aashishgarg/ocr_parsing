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

    it 'returns non empty array of BOL Types' do
      bol_types = []
      2.times { bol_types << FactoryBot.create(:bol_type) }
      get :index, format: 'json'
      hash_body = JSON.parse(response.body).with_indifferent_access
      expect(hash_body).to match({bol_types: [{id: bol_types[0].id, name: bol_types[0].name},
                                              {id: bol_types[1].id, name: bol_types[1].name}]
                                 })
    end
  end

  context '#show' do
    before do
      @bol_type = FactoryBot.create(:bol_type)
    end

    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :show, params: {id: @bol_type.id}, format: 'application/json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :show, params: {id: @bol_type.id}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'returns BOL Type hash' do
      get :show, params: {id: @bol_type.id}, format: 'application/json'
      hash_body = JSON.parse(response.body).with_indifferent_access
      expect(hash_body.keys.include?('bol_type')).to eq(true)
      %w(id name).each {|key| expect(hash_body['bol_type'].keys.include?(key)).to eq(true)}
    end
  end
end
