class ProcessFilesJob < ApplicationJob
  queue_as :ocr_queue

  def perform(attachment)
    Ocr::ProcessFiles.new(attachment).process_s3_file
  end
end