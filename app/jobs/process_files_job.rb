class ProcessFilesJob < ApplicationJob
  queue_as :file_queue

  def perform(bol_file_object)
    Ocr::ProcessFiles.new(bol_file_object).process_s3_file
  end
end
