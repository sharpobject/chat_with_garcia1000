require("socket")

local socket = socket.tcp()
socket:settimeout(1)
if not socket:connect("localhost", 49929) then
  error("please start server")
end

while true do
  local input = io.read("*l")
  print(socket:send(input.."\n"))
  print(socket:receive("*l"))
end