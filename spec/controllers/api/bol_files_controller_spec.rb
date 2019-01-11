require 'rails_helper'
require 'jwt'

RSpec.describe Api::BolFilesController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @user.add_role :admin
    @token = JWT.encode({ id: @user.id }, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers['Authorization'] = "Bearer #{@token}"
    request.headers['content-type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
    @shipper = FactoryBot.create(:shipper)
  end

  context '#index' do
    it 'returns http Unauthorized' do
      request.headers['Authorization'] = "Bearer #{@token}1111111"
      get :index, params: { shipper_id: @shipper.id }, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :index, params: { shipper_id: @shipper.id }, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#show' do
    before do
      User.current = @user
      @bol_file = FactoryBot.create(:bol_file)
    end

    it 'returns http Unauthorized' do
      request.headers['Authorization'] = "Bearer #{@token}1111111"
      get :show, params: { shipper_id: @shipper.id, id: @bol_file.id }, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :show, params: { shipper_id: @shipper.id, id: @bol_file.id }, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#create' do
    before do
      User.current = @user
      @bol_type = FactoryBot.create(:bol_type)
      @params = {
        shipper_id: @shipper.id,
        bol_file: {
          name: 'NewTestName',
          Shipper_id: @shipper.id,
          bol_type_id: @bol_type.id
        }
      }
    end

    it 'not allowed for user role :customer' do
      %i[admin support].each { |role| User.current.remove_role role }
      User.current.add_role :customer
      post :create, params: @params, format: 'json'
      expect(response.status).to eq 403
    end

    it 'allowed for user role :support' do
      %i[admin customer].each { |role| User.current.remove_role role }
      User.current.add_role :support
      post :create, params: @params, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :admin' do
      %i[support customer].each { |role| User.current.remove_role role }
      User.current.add_role :admin
      post :create, params: @params, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#update' do
    before do
      User.current = @user
      @bol_file = FactoryBot.create(:bol_file)
      @params = {
        shipper_id: @shipper.id,
        id: @bol_file.id,
        bol_file: {
          name: 'NewTestName'
        }
      }
    end

    it 'allowed for user role :customer' do
      %i[support admin].each { |role| User.current.remove_role role }
      User.current.add_role :customer
      put :update, params: @params, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :support' do
      %i[admin customer].each { |role| User.current.remove_role role }
      User.current.add_role :support
      put :update, params: @params, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :admin' do
      %i[support customer].each { |role| User.current.remove_role role }
      User.current.add_role :admin
      put :update, params: @params, format: 'json'
      expect(response.status).to eq 200
    end
  end
end
