json.(bol_file, :id, :name, :shipper_name, :status, :user_id, :extracted_at, :qa_approved_at, :released_at, :bol_number, :pitt_pro)

json.attachments do |json|
  json.array!(bol_file.attachments.sequenced) do |attachment|
    json.partial! 'api/attachments/attachment', attachment: attachment
  end
end