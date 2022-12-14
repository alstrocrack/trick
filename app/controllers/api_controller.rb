class ApiController < ApplicationController
  def index
    data = Request.find_by(id: 4)
    puts "IP: #{request.remote_ip}"
    if request.remote_ip == data.from_address
      render json: JSON.generate(data.response_body), status: data.status_code
    else
      render plain: "OKOKOK"
    end
  end
end
