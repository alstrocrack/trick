module Api
  class ApiController < ApplicationController
    def get
      render plain: "got!"
    end

    def post
      render plain: "posted!"
    end
  end
end
