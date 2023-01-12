local arg = {...}
local protocol = "swarm:chunkMiner"

ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}

s = require("swarm")

--register the computer IDs
for i=1,#ids do
	s.register(ids[i])
end

rednet.open("top")

function broadcastTest(command)
	s.broadcastCommand(command)

	local results = {}
	for i=1,#s.ids do
		local id,msg = rednet.receive(s.protocol)
		results[id] = msg
	end
end

broadcastTest(arg[1])

rednet.close("top")