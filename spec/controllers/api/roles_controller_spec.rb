require 'rails_helper'
require 'jwt'

RSpec.describe Api::RolesController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @user.add_role :admin
    @token = JWT.encode({ id: @user.id }, ENV['DEVISE_JWT_SECRET_KEY'])
    request.headers['Authorization'] = "Bearer #{@token}"
    request.headers['content-type'] = 'application/json'
    request.headers['Accept'] = 'application/json'
  end

  # ==== INDEX ============================================== #
  context '#index' do
    it 'returns http Unauthorized for invalid token' do
      request.headers['Authorization'] = "Bearer #{@token}1111111"
      get :index, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success for valid' do
      get :index, format: 'json'
      expect(response.status).to eq 200
    end

    it 'has name in response' do
      get :index, format: 'json'
      @body = JSON.parse(response.body)[0].with_indifferent_access
      expect(@body.key?('name')).to eq(true)
    end
  end

  # ==== SHOW =============================================== #
  context '#show' do
    before do
      User.current = @user
      @role = FactoryBot.create(:role)
    end

    it 'returns http Unauthorized for invalid token' do
      request.headers['Authorization'] = "Bearer #{@token}1111111"
      get :show, params: { id: @role.id }, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success for valid token' do
      get :show, params: { id: @role.id }, format: 'json'
      expect(response.status).to eq 200
    end
  end

  # ==== DESTROY ============================================= #
  context '#destroy' do
    before do
      User.current = @user
      @role = FactoryBot.create(:role)
    end

    it 'removes role from table' do
      expect do
        delete :destroy, params: { id: @role.id }
      end.to change(Role, :count).by(-1)
      expect(response).to be_successful
    end
  end
end
