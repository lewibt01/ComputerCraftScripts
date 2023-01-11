local sendChannel, receiveChannel = 4555,4556
local protocol = "swarm:chunkMiner"

ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}

rednet.open("top")

function sendCommand(id,command)
	rednet.send(id,command,protocol)

	local id,msg = rednet.receive(protocol,2)
	return id,msg
end

for i=1,#ids do
	local id,result = sendCommand(ids[i],"forward")
	if(result) then 
		print(id[i]..":"..result)
	else
		print("Failed to get response from "..ids[i])
	end
end

