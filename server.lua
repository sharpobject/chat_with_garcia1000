require("socket")

local connection_to_name = {}
local server_socket = socket.bind("*", 49929)
server_socket:settimeout(0)

while true do
  local new_conn = server_socket:accept()
  if new_conn then
     new_conn:settimeout(0)
     connection_to_name[new_conn] = "dog"
  end
  local recvt = {server_socket}
  for conn, name in pairs(connection_to_name) do
    recvt[#recvt+1] = conn
  end
  local ready = socket.select(recvt, nil, 1)
  for _,conn in ipairs(ready) do
    if conn ~= server_socket then
      local junk, err, data = conn:receive("*a")
      if (not err) or (err == "closed") then
        connection_to_name[conn] = nil
        pcall(function() conn:close() end)
      end
      if data then
        local success = conn:send(data)
        if not success then
          connection_to_name[conn] = nil
          pcall(function() conn:close() end)
        end
      end
    end
  end
end