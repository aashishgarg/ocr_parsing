json.(bol_file, :id, :name, :shipper_name, :status, :user_id,:qa_approved_at, :released_at, :extracted_at)

json.attachments do |json|
  json.array!(bol_file.attachments.sequenced) do |attachment|
    json.partial! 'api/attachments/attachment', attachment: attachment
  end
end