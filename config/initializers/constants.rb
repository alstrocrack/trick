class ErrorCode
  E1001 = 1001
  E1002 = 1002
  E1003 = 1003
  E1004 = 1004
  E1005 = 1005
  E1006 = 1006
end
class ErrorMessage
  Param = "Invalid params." #1001
  From = "Invalid From." #1002
  LimitRequetsExceeds = "The maximum number of requests that can be registered has been reached." #1003
  LackOfParameters = "Please enter both email and password." #1004
  NonExistentUsers = "User not found." #1005
  InvalidPassword = "This is invalid password. Please check your password and try again." #1006
end
class UserSessionStatus
  Enable = 1
  Disable = 2
end
