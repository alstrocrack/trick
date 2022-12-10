class ApplicationError < StandardError
  attr_accessor :code
  def initialize(code, msg)
    super(msg)
    @code = code
  end
end
