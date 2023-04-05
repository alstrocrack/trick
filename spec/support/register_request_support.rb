module RegisterRequestSupport
  def register_request_with(name, status, header, body)
    fill_in "home[name]", with: name
    fill_in "home[status]", with: status
    fill_in "home[header]", with: header
    fill_in "home[body]", with: body
    click_button "Register Request"
  end
end
