class Request < ApplicationRecord
  def self.valid?(input)
    raise ApplicationError.new(ErrorCode::E1002, ErrorMessage::From) if input[:from].blank?
    return true
  end
end
