module LoginSupport
  def sign_in_with(email, password)
    visit root_path
    click_link "Login"
    fill_in "login[email]", with: email
    fill_in "login[password]", with: password
    click_button "Login"
  end
end
