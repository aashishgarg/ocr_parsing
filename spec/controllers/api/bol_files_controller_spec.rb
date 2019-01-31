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

    context '#FilterParameter' do
      it 'filter_column without filter_value raise error' do
        get :index, params: { filter_column: ['name'] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body).to eq('errors' => %w[FilterColumnOrValuesNotArray])
      end

      it 'filter_column with non array value raises error' do
        get :index, params: { filter_column: 'name', filter_value: '1' }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body).to eq('errors' => %w[FilterColumnOrValuesNotArray])
      end

      it 'filter_column and filter_value with different parameter counts raises error' do
        get :index, params: { filter_column: ['name,status'], filter_value: %w[value] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body).to eq('errors' => %w[FilterColumnAndValuesNotSame])
      end

      it 'filter_column with invalid column name raises error' do
        get :index, params: { filter_column: ['invalidColumn'], filter_value: %w[value] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body).to eq('errors' => %w[ColumnNotValid])
      end

      it 'valid filter_column and filter_value does not raise error' do
        get :index, params: { filter_column: ['name'], filter_value: %w[value] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body.key?('errors')).to eq(false)
      end

      it 'provides page_details' do
        get :index, params: { filter_column: ['name'], filter_value: %w[value] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body.key?('page_details')).to eq(true)
      end

      %w[total_records total_pages page_number].each do |key|
        it "provides page_details[:#{key}]" do
          get :index, params: { filter_column: ['name'], filter_value: %w[value] }, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
          expect(@body['page_details'].key?(key)).to eq(true)
        end
      end

      it 'does not provide counts' do
        get :index, params: { filter_column: ['name'], filter_value: %w[value] }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body.key?('counts')).to eq(false)
      end
    end

    context '#Dashboard' do
      it 'has counts in response' do
        get :index, params: { dashboard: true }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body.key?('counts')).to eq(true)
      end

      it 'provides page_details' do
        get :index, params: { dashboard: true }, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body.key?('page_details')).to eq(true)
      end

      %w[total_records total_pages page_number].each do |key|
        it "provides page_details[:#{key}]" do
          get :index, params: { dashboard: true }, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
          expect(@body['page_details'].key?(key)).to eq(true)
        end
      end

      %w[ocr_done qa_rejected qa_approved released].each do |key|
        it "provides counts[:#{key}]" do
          get :index, params: { dashboard: true }, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
          expect(@body['counts'].key?(key)).to eq(true)
        end
      end
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

    # ==== create [Attachments upload] ======================== #
    context 'single Attachment upload' do
      it 'type [PNG] provides same urls' do
        file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/488118.001.png",
                                            'multipart/form-data')
        @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
        post :create, params: @params, format: 'json'
        @body = JSON.parse(response.body).with_indifferent_access
        expect(@body['bol_files'][0]['attachments'][0]['original_url']).not_to eq(nil)
        expect(@body['bol_files'][0]['attachments'][0]['original_url'])
          .to eq(@body['bol_files'][0]['attachments'][0]['processed_url'])
      end

      context '[448118]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118')
        end
        it 'sets attachment [serial_no] = nil' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(0)
        end
      end

      context '[448118.001]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.001",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.001' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.001')
        end
        it 'sets attachment [serial_no] = 1' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(1)
        end
      end

      context '[448118.002]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.002",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.002' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.002')
        end
        it 'sets attachment [serial_no] = 2' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(2)
        end
      end

      context '[448118.tiff.001]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.tiff.001",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.tiff.001' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.tiff.001')
        end
        it 'sets attachment [serial_no] = 1' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(1)
        end
      end

      context '[448118.tiff.002]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.tiff.002",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.tiff.002' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.tiff.002')
        end
        it 'sets attachment [serial_no] = 2' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(2)
        end
      end

      context '[448118.001.tiff]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.001.tiff",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.001.tiff' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.001.tiff')
        end
        it 'sets attachment [serial_no] = 1' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(1)
        end
      end

      context '[448118.002.tiff]' do
        before do
          file = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.002.tiff",
                                              'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '0' => { data: file } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'sets bol_file name 448118' do
          expect(@body['bol_files'][0]['name']).to eq('448118')
        end
        it 'sets attachment [data_file_name] = 448118.002.tiff' do
          expect(@body['bol_files'][0]['attachments'][0]['data_file_name']).to eq('448118.002.tiff')
        end
        it 'sets attachment [serial_no] = 2' do
          expect(@body['bol_files'][0]['attachments'][0]['serial_no']).to eq(2)
        end
      end
    end

    context 'multiple attachments upload' do
      context 'with files 448118.001 and 448118.002' do
        before do
          file1 = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.001",
                                               'multipart/form-data')
          file2 = Rack::Test::UploadedFile.new("#{Rails.root}/spec/support/attachments/bol_files/448118.002",
                                               'multipart/form-data')
          @params = { bol_file: { attachments_attributes: { '1' => { data: file1 }, '2' => { data: file2 } } } }
          post :create, params: @params, format: 'json'
          @body = JSON.parse(response.body).with_indifferent_access
        end
        it 'creates single bol_file' do
          expect(@body['bol_files'].count).to eq(1)
        end
        it 'creates two attachments under same bol file' do
          expect(@body['bol_files'][0]['attachments'].count).to eq(2)
        end
        it 'creates attachments with serial numbers 1, 2' do
          attach = @body['bol_files'][0]['attachments']
          expect([attach[0]['serial_no'], attach[1]['serial_no']].sort).to eq([1, 2])
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
