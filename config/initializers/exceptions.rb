class FilterColumnAndValuesNotSame < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end

class FilterColumnOrValuesNotArray < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end

class ColumnNotValid < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end

class FailedAtOcr < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end

class ResponseErrorAtOcr < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end

class FailedInResponseParsing < StandardError
  attr_accessor :message

  def initialize(message = nil)
    @message = message
    super(message)
  end
end
