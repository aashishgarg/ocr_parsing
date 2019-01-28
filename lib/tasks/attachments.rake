namespace :attachments do
  desc 'Migrate attachments data as per newly added statues - (failed_at_ocr -> 2, failed_in_response_parsing -> 3)'
  task migrate_statuses: :environment do
    Attachment.where('status in (?)', 2).update_all(status: 'ocr_done')
  end
end
