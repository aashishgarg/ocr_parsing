require 'rails_helper'

RSpec.describe ProcessFilesJob, type: :job do
  before do
    @user = FactoryBot.create(:user)
    @bol_file = FactoryBot.create(:bol_file, user: @user)
  end
  it 'matches with enqueued job' do
    ActiveJob::Base.queue_adapter = :test

    attach = @bol_file.attachments.create(data: File.open("#{Rails.root}/spec/support/attachments/bol_files/448118"))
    expect { ProcessFilesJob.perform_later(attach) }.to(have_enqueued_job(ProcessFilesJob))
    expect { ProcessFilesJob.perform_later(attach) }.to(have_enqueued_job.with { |attachment|
      expect(attachment).to eq(attach)
    })
  end

  it 'updates latest [updated_at] of all attachments in [extracted_at] of bolFile' do
    %w[448118 448118.001 448118.002].each do |name|
      ProcessFilesJob.perform_later(@bol_file.attachments.create(data: File.open("#{Rails.root}/spec/support/attachments/bol_files/#{name}")))
    end
    expect(@bol_file.extracted_at).to eq(@bol_file.attachments.collect(&:updated_at).max)
  end
end
