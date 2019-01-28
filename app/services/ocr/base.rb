module Ocr
  class Base
    # Exception
    def report_exception(e, object)
      ExceptionNotifier.notify_exception(e, data: { attachment: object.attachment,
                                                    bol_file: object.attachment.attachable,
                                                    current_user: object.current_user,
                                                    message: e.message,
                                                    json_parser: object.json_parser,
                                                    processor: object })
    end
  end
end