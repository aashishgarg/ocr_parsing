Paperclip::DataUriAdapter.register

Paperclip.interpolates :parameterize_file_name do |attachment, style|
  "#{sanitize_filename(attachment.original_filename)}_www.foo.com"
end