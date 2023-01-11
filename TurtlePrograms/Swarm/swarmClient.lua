package.path = package.path..";/api/?.lua"

cmd = require("commandTranslate")

local hostId = 2
local protocol = "swarm:chunkMiner"

rednet.open("left")

while(true) do
	local id,msg = rednet.receive(protocol,2) --couple second timeout
	local result = ""

	if(msg == "stop") then
		break
	else
		if(msg ~= nil) then 
			io.write("CMD:"..msg)
			result = cmd.translate(msg)

			io.write("->"..tostring(result))
			rednet.send(hostId,result,protocol)

			print(".")
		end
	end
end