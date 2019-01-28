namespace :one_time do
  desc 'Migrate attachments data as per newly added statues - (failed_at_ocr -> 2, failed_in_response_parsing -> 3)'
  task migrate_statuses: :environment do

    # Updating the attachments at line level so that model callbacks remain in working.
    Attachment.where('status > (?)', 2).each do |attachment|
      status_integer = Attachment.statuses[attachment.status]
      attachment.update(status: Attachment.statuses.key(status_integer + 2))
    end
  end
end
