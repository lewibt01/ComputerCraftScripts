package.path = package.path..";/api/?.lua"

local arg = {...}
local protocol = "swarm:chunkMiner"

ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}

s = require("swarm")
s.protocol = protocol

--register the computer IDs
for i=1,#ids do
	s.register(ids[i])
end

rednet.open("top")

--function factory for parallel api, pass in a metatable for each function's output
--returns a list of functions to be called by the parallel api
function factory(numCalls,output)
	local funcs = {}
	function write(id,msg)
		output[id] = msg
	end

	function receive()
		local id,msg = rednet.receive(s.protocol)
		write(id,msg)
	end

	for i=1,#s.ids do
		table.insert(funcs,receive)
	end

	return funcs
end

function broadcastTest(command)
	s.broadcastCommand(command)

	--function table
	local f = factory(#s.ids)
	local fResults = {} --results of the above functions, linked by index

	parallel.waitForAll(table.unpack(f))

	for k,v in pairs(fResults) do
		print(k,v)
	end
end

--gather and print output
broadcastTest(arg[1])
for i=1,#s.ids do
	print(output[s.ids[i]])
end

rednet.close("top")