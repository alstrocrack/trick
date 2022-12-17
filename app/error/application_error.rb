class ApplicationError < StandardError
  attr_reader :code, :msg
  def initialize(code, msg)
    @msg = msg
    @code = code
  end
end
