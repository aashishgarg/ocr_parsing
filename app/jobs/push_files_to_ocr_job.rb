class PushFilesToOcrJob < ApplicationJob
  queue_as :ocr_queue

  def perform(bol_file_object, file_path)
    Ocr::ProcessFiles.new(bol_file_object).push_file(file_path)
  end
end