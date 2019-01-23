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
  end

  # ==== SHOW =============================================== #
  context '#show' do
    before do
      User.current = @user
      @bol_file = FactoryBot.create(:bol_file, user: @user)
    end

    it 'returns http Unauthorized for invalid token' do
      request.headers['Authorization'] = "Bearer #{@token}1111111"
      get :show, params: { id: @bol_file.id }, format: 'json'
      expect(response.status).to eq 401
    end

    it 'returns http success for valid token' do
      get :show, params: { id: @bol_file.id }, format: 'json'
      expect(response.status).to eq 200
    end
  end

  # ==== create ============================================= #
  context '#create' do
    before do
      @params = {
        bol_file: {
          name: 'NewTestName',
          bol_type_id: 1
        }
      }
    end

    context '[Role Permissions]' do
      it 'allowed for user role :customer' do
        %i[admin support].each { |role| User.current.remove_role role }
        User.current.add_role :customer
        post :create, params: @params, format: 'json'
        expect(response.status).to eq 200
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

    context '[attachments #create]' do
      context 'for file type' do
        it 'png' do

        end
      end

      context 'for file name' do
        before do
          request.headers['content-type'] = 'multipart/form-data'
          @params = {
            'bol_file' => {
              'attachments_attributes' => {
                '0' => {
                  'data' => File.open('/home/ashish/Desktop/BolFiles/4/448118')
                }
              }
            }
          }
        end

        it '448118' do
          @params['bol_file']['attachments_attributes']['0']['data'] = File.open('/home/ashish/Desktop/BolFiles/4/448118')
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
          expect(response.body).to eq('')
        end

        it '448118.001 and 448118.002' do

        end

        it '448118.001.tiff and 448118.002.tiff' do

        end

        it '448118.tiff.001 and 448118.tiff.002' do

        end
      end
    end
  end

  # ==== UPDATE ============================================= #
  context '#update' do
    before do
      @bol_file = FactoryBot.create(:bol_file, user: @user)
      @params = {
        id: @bol_file.id,
        bol_file: {
          name: 'NewTestName',
          bol_type_id: 1
        }
      }
    end

    context '[Role Permissions]' do
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
end
