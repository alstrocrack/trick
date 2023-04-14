class Request < ApplicationRecord
  def validate_request
    if self.status_code.present? && self.status_code.to_s !~ /^[12345]\d{2}$/
      raise ApplicationError.new(ErrorCode::E1013, ErrorMessage::InvalidStatusCode)
    end
    raise ApplicationError.new(ErrorCode::E1009, ErrorMessage::InvalidRequestName) unless self.name.present?
    self.response_body = nil if self.response_body.blank?
  end

  # An exception is raised if value exists but key does not
  # @param [Array] examle: key1, key2, key3, val1, val2, val3
  # @note Arguments need to be set as in the array above
  def self.validate_header(count, args)
    count.times { |n| raise ApplicationError.new(ErrorCode::E1014, ErrorMessage::InvalidHeaderKey) if args[n + count].present? && args[n].blank? }
  end

  # Returns the input key-value pairs in a formatted format
  # @param [String] examle: key1, key2, key3, val1, val2, val3
  # @return [String] example: "key1:val1, key2:val2, key3:val3"
  def self.format_header(*args)
    count = args.size / 2 # a number of key-value pairs
    self.validate_header(count, args) # Exec validation
    arr = []
    count.times do |n|
      next if args.slice(n).blank?
      key, value = args.slice(n), args.slice(n + 3)
      arr << "#{key}:#{value}"
    end
    return arr.join(",")
  end
end
