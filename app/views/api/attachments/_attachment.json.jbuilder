json.(attachment, :id, :status, :serial_no, :data_file_name, :data_content_type, :data_file_size, :data_updated_at, :ocr_parsed_data, :processed_data, :created_at, :updated_at)
json.original_url attachment.signed_original_url
json.processed_url attachment.signed_processed_url