module Paperclip
  class Ocr < Processor
    def initialize(file, options = {}, attachment = nil)
      super
      @file           = file
      @attachment     = attachment
      @current_format = File.extname(@file.path)
      @format         = options[:format] ? ".#{options[:format]}" : ''
      @basename       = File.basename(@file.path, @current_format)
    end

    def make
      temp_file = Tempfile.new([@basename, @format])
      temp_file.binmode
      run_string = "convert #{from_file} #{to_file(temp_file)}"
      system("convert #{from_file} #{to_file(temp_file)}")
      Paperclip.run(run_string)
      temp_file
    end

    def from_file
      File.expand_path(@file.path)
    end

    def to_file(destination)
      File.expand_path(destination.path)
    end
  end
end
