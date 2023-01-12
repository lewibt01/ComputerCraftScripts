package.path = package.path..";/api/?.lua"

local arg = {...}
local protocol = "swarm:chunkMiner"

ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}

s = require("swarm")

--register the computer IDs
for i=1,#ids do
	s.register(ids[i])
end

rednet.open("top")

-- function sendCommand(targetId,command)
-- 	rednet.send(targetId,command,protocol)

-- 	local id,msg = rednet.receive(protocol,2)
-- 	return id,msg
-- end

-- function distributeCommands(command)
-- 	for i=1,#ids do
-- 		local id,result = sendCommand(ids[i],command)

-- 		if(result ~= nil) then
-- 			io.write(id)
-- 			io.write(":")
-- 			print(result)
-- 		else
-- 			print("Failed to get response from "..ids[i])
-- 		end
-- 	end
-- end

-- s.distributeCommands(arg[1])

s.broadcastCommand(arg[1])

rednet.close("top")