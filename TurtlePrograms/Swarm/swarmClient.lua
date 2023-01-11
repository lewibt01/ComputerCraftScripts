package.path = package.path..";/api/?.lua"

cmd = require("commandTranslate")

local hostId = 2
local protocol = "swarm:chunkMiner"

rednet.open("left")
local running = true

while(running) do
	local id,msg = rednet.receive(protocol,60) --large timeout to prevent infinite hang
	local result = ""

	--short circuit if told to stop
	if(msg == "stop") then
		print("Stopping...")
		running = false
		result = "stopped"
	elseif(msg == "update") then
		shell.run("/turtleSetup.lua")
	else
		if(msg ~= nil) then 
			io.write("CMD:"..msg)
			result = cmd.translate(msg)

			print("->"..tostring(result))
		end
	end

	--respond to the command
	rednet.send(hostId,result,protocol)
	io.write(".")
end