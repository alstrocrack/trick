module ErrorCode
  E1001 = 1001
  E1002 = 1002
  E1003 = 1003
  E1004 = 1004
  E1005 = 1005
  E1006 = 1006
  E1007 = 1007
  E1008 = 1008
  E1009 = 1009
  E1010 = 1010
  E1011 = 1011
  E1012 = 1012
  E1013 = 1013
  E1014 = 1014
end

module ErrorMessage
  Param = "Invalid params." #1001
  Email = "That address is already in use." #1002
  LimitRequetsExceeds = "The maximum number of requests that can be registered has been reached." #1003
  LackOfParameters = "Please enter both email and password." #1004
  NonExistentUsers = "User not found." #1005
  InvalidPassword = "This is invalid password. Please check your password and try again." #1006
  InvalidUserSession = "Invalid Session." #1007
  UserName = "That name is already in use." #1008
  InvalidRequestName = "That request name is invalid." #1009
  NotFoundRequest = "That Request was not found." #1010
  LackOfParametersWithName = "Please enter your name, email address, and password all." #1011
  NotLoggedIn = "Not logged in yet." #1012
  InvalidStatusCode = "Invalid status code." #1013
  InvalidHeaderKey = "Invalid header key." #1013
end

module UserSessionStatus
  Enable = 1
  Disable = 2
  Temporary = 3 # We can set it to "Disable" when you log in, but as long as the session continues, guest user can continue to use it without logging in.
end

module RequestCounts
  Max = 5
end
