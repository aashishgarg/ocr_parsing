json.(bol_file, :id, :name, :status, :user_id, :extracted_at)

json.attachments do |json|
  json.array!(bol_file.attachments.sequenced) do |attachment|
    json.partial! 'api/attachments/attachment', attachment: attachment
  end
end