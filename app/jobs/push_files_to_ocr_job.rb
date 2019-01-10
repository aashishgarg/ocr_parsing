class PushFilesToOcrJob < ApplicationJob
  queue_as :ocr_queue

  def perform(bol_file_object)
    Ocr::ProcessFiles.new(bol_file_object).process_s3_file
  end
end