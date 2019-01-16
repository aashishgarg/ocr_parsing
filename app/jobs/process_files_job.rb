class ProcessFilesJob < ApplicationJob
  queue_as :ocr_queue

  def perform(bol_file, user)
    Ocr::ProcessFiles.new(bol_file, user).process_s3_file
  end
end