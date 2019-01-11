require 'rails_helper'
require 'jwt'

RSpec.describe Api::UsersController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @user.add_role :admin
    @token = JWT.encode({ id: @user.id }, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers['Authorization'] = "Bearer #{@token}"
    request.headers['content-type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
  end

  context '#update' do
    it 'returns http Unauthorized' do
      request.headers['Authorization'] = "Bearer #{@token}111111"
      put :update, params: { user: { name: 'TestName' } }, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http Forbidden for user with no role' do
      @user.roles.delete(Role.all)
      @user.roles.each { |role| @user.roles.delete(role) }
      put :update, params: { user: { name: 'TestName' } }, format: 'json'
      expect(response.status).to eq 403
    end

    it 'returns http Forbidden for user with non admin role' do
      @user.roles.delete(Role.find_by(name: 'admin'))
      @user.add_role :customer
      @user.add_role :support
      put :update, params: { user: { name: 'TestName' } }, format: 'json'
      expect(response.status).to eq 403
      expect(response.content_type).to eq 'application/json'
      expect(response.body).to eq ''
    end

    it 'returns http success' do
      @user.add_role :admin
      put :update, params: { user: { name: 'TestName' } }, format: 'json'
      expect(response.status).to eq 200
      expect(response.content_type).to eq 'application/json'
    end
  end

  context '#show' do
    it 'returns http Unauthorized' do
      request.headers['Authorization'] = "Bearer #{@token}111111"
      get :show, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :show, format: 'json'
      expect(response.status).to eq 200
    end

    it 'returns user details' do
      get :show, format: 'json'
      hash_body = JSON.parse(response.body).with_indifferent_access
      expect(hash_body.keys.include?('user')).to eq true
      %w(id email first_name last_name company phone fax token).each do |key|
        expect(hash_body['user'].keys.include?(key)).to eq true
      end
    end
  end
end
