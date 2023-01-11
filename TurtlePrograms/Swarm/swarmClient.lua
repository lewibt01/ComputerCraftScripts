package.path = package.path..";/api/?.lua"

cmd = require("commandTranslate")

local hostId = 2
local protocol = "swarm:chunkMiner"

rednet.open("left")

while(true) do
	local id,msg = rednet.receive(protocol,5) --5 second timeout
	local result = ""

	if(msg == "stop") then 
		break
	else
		result = cmd.translate(msg)
	end

	rednet.send(hostId,result)
end