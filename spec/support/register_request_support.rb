module RegisterRequestSupport
  def register_request_with(from, status, header, body)
    fill_in "home[from]", with: from
    fill_in "home[status]", with: status
    fill_in "home[header]", with: header
    fill_in "home[body]", with: body
    click_button "Register Request"
  end
end
