require 'rails_helper'

RSpec.describe ProcessFilesJob, type: :job do
  before do
    @user = FactoryBot.create(:user)
    @user.add_role :admin
  end
  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test
    bol_file = FactoryBot.create(:bol_file, user: @user)
    attach = bol_file.attachments.create(data: File.open("#{Rails.root}/spec/support/attachments/bol_files/448118"))
    expect { ProcessFilesJob.perform_later(attach) }.to(have_enqueued_job(ProcessFilesJob))
    expect { ProcessFilesJob.perform_later(attach) }.to(have_enqueued_job.with { |attachment|
      expect(attachment).to eq(attach)
    })
  end
end
