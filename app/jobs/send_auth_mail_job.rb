require "sendgrid-ruby"
include SendGrid

class SendAuthMailJob < ApplicationJob
  queue_as :default

  def perform(to, name)
    begin
      from = SendGrid::Email.new(email: ENV["ADMIN_MAILADDRESS"])
      to = SendGrid::Email.new(email: to)
      subject = "Thank you for starting to use Trick"
      content = SendGrid::Content.new(type: "text/plain", value: "Dear #{name}, \nThanks!\nBegin here!")
      mail = SendGrid::Mail.new(from, subject, to, content)
      sendgrid = SendGrid::API.new(api_key: ENV["SENDGRID_API_KEY"])
      response = sendgrid.client.mail._("send").post(request_body: mail.to_json)
    rescue => e
      raise e
    end
  end
end
