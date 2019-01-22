module ParentProcessor
  extend ActiveSupport::Concern

  included do
    # Scopes: Applied for providing the Attachments in an ordered manner based on serial_no extracted from file
    scope :sequenced, -> { order(serial_no: :asc, created_at: :desc) }

    # Evaluates file name. Ex - For file name - (image1.png.001), parsed_file_name is (image1)
    def parsed_file_name
      data_file_name.split('.')[0]
    end

    # Evaluates the serial_no present in the file name like - (image1.png.001)
    def parsed_serial_no
      return data_file_name.gsub(ext, '').split('.')[1]&.to_i if !data_file_name.include?(ext) || data_file_name.end_with?(ext)

      data_file_name.split(ext)[1]&.gsub('.', '')&.to_i
    end

    # Gets file extension from content_type of file determined by paperclip
    def ext
      Rack::Mime::MIME_TYPES.invert[data_content_type]
    end

    # Fetches existing parent or creates new one
    def parent(user)
      BolFile.find_by(parent_recognizing_condition) || user.bol_files.create(parent_recognizing_condition)
    end

    # Condition to recognize the parent of file
    def parent_recognizing_condition
      { name: parsed_file_name }
    end
  end
end