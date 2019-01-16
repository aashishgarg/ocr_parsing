json.(bol_file, :id, :name, :status, :user_id)

json.attachments do |json|
  json.array!(bol_file.attachments) do |attachment|
    json.partial! 'api/attachments/attachment', attachment: attachment
  end
end