module RegisteringRequest
  def self.build_registering_request_header(*args)
    Request.format_header(args)
  end
end
