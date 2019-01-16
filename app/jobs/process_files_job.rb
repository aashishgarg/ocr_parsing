class ProcessFilesJob < ApplicationJob
  queue_as :ocr_queue

  def perform(bol_file)
    Ocr::ProcessFiles.new(bol_file).process_s3_file
  end
end