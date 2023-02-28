class ApiController < ApplicationController
  def index
    ip = request.remote_ip || request.ip
    # render json:
    render plain: "#{ip}\n"
  end
end
