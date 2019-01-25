class ProcessFilesJob < ApplicationJob
  queue_as :ocr_queue

  def perform(attachment, current_user)
    Ocr::ProcessFiles.new(attachment, current_user).send_to_ocr
  end
end