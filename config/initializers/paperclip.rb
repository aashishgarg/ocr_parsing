Paperclip::DataUriAdapter.register

# For allowing the File names like - (image1.png.001, image1.png.001)
# as required by our current functionality
require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
