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
    before do
      User.current = @user
      @bol_file = FactoryBot.create(:bol_file)
    end

    it 'returns http Unauthorized' do
      request.headers.merge!('Authorization' => "Bearer #{@token}111111")
      get :show, params: {shipper_id: @shipper.id, id: @bol_file.id}, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success' do
      get :show, params: {shipper_id: @shipper.id, id: @bol_file.id}, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#create' do
    before do
      User.current = @user
      @bol_type = FactoryBot.create(:bol_type)
    end

    it 'not allowed for user role :customer' do
      User.current.roles.delete(Role.where(name: [:admin, :support]))
      User.current.add_role :customer
      post :create, params: {shipper_id: @shipper.id, bol_file: {
                      name: 'NewTestName',
                      Shipper_id: @shipper.id,
                      bol_type_id: @bol_type.id
                  }}, format: 'json'
      expect(response.status).to eq 403
    end

    it 'allowed for user role :support' do
      User.current.roles.delete(Role.where(name: [:admin, :customer]))
      User.current.add_role :support
      post :create, params: {shipper_id: @shipper.id, bol_file: {
                      name: 'NewTestName',
                      Shipper_id: @shipper.id,
                      bol_type_id: @bol_type.id
                  }}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :admin' do
      User.current.roles.delete(Role.where(name: [:customer, :support]))
      User.current.add_role :admin
      post :create, params: {shipper_id: @shipper.id, bol_file: {
                      name: 'NewTestName',
                      Shipper_id: @shipper.id,
                      bol_type_id: @bol_type.id
                  }}, format: 'json'
      expect(response.status).to eq 200
    end
  end

  context '#update' do
    before do
      User.current = @user
      @bol_file = FactoryBot.create(:bol_file)
    end

    it 'allowed for user role :customer' do
      User.current.roles.delete(Role.where(name: [:admin, :support]))
      User.current.add_role :customer
      put :update, params: {shipper_id: @shipper.id, id: @bol_file.id, bol_file: {name: 'NewTestName'}}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :support' do
      User.current.roles.delete(Role.where(name: [:admin, :customer]))
      User.current.add_role :support
      put :update, params: {shipper_id: @shipper.id, id: @bol_file.id, bol_file: {name: 'NewTestName'}}, format: 'json'
      expect(response.status).to eq 200
    end

    it 'allowed for user role :admin' do
      User.current.roles.delete(Role.where(name: [:customer, :support]))
      User.current.add_role :admin
      put :update, params: {shipper_id: @shipper.id, id: @bol_file.id, bol_file: {name: 'NewTestName'}}, format: 'json'
      expect(response.status).to eq 200
    end
  end
end
