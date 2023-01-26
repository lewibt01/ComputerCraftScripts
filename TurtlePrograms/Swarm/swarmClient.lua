package.path = package.path..";/api/?.lua"

cmd = require("commandTranslate")
s = require("stringUtils")
t = require("tableUtils")

local debugFlag = false
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

local function debugIO(...)
	if(debugFlag) then
		io.write(...)
	end
end

local hostId = 19
local protocol = "swarm:chunkMiner"

rednet.open("left")
local running = true

--backup
-- while(running) do
-- 	local id,msg = rednet.receive(protocol,60) --large timeout to prevent infinite hang
-- 	local result = ""

-- 	--short circuit if told to stop
-- 	if(msg == "stop") then
-- 		print("Stopping...")
-- 		running = false
-- 		result = "stopped"
-- 	elseif(msg == "update") then
-- 		result = "updating"
-- 		rednet.send(hostId,result,protocol)
-- 		shell.run("/turtleSetup.lua")
-- 		break
-- 	else
-- 		if(msg ~= nil) then 
-- 			io.write("CMD:"..msg)
-- 			result = cmd.translate(msg)

-- 			print("->"..tostring(result))
-- 		end
-- 	end

-- 	--respond to the command
-- 	rednet.send(hostId,result,protocol)
-- 	io.write(".")
-- end

--separate the arguments out of a commandstring, returning nil for the arguments if there arent any
function processArgs(commandString)
	debug("cmdStr:",commandString)
	--if we have args...
	if(string.find(commandString," ")) then
		local pieces = s.splitStr(commandString," ")
		debug("\tpieces:",table.concat(pieces,","))
		local cmdTable,args = t.split(pieces,2)
		debug("\tcmdTable:",table.concat(cmdTable,","))
		debug("\targs:",table.concat(args,","))
		local command = cmdTable[1]

		--convert numeric arguments to numbers
		args = t.convertToNumbers(args)

		return command,args
	--otherwise...
	else
		debug("No args: ",commandString)
		return commandString,nil
	end
end

function processCommand(commandString)
	local result = ""
	local command,args = processArgs(commandString)

	if(command ~= nil and args ~= nil) then
		io.write("CMD:"..command.." "..table.concat(args," "))
		result = cmd.translate(command,table.unpack(args))
	elseif(command ~= nil and args == nil) then
		io.write("CMD:"..command)
		result = cmd.translate(command)
	else
		result = "failed to execute"..commandString
	end

	print("->"..tostring(result))
	return result
end

while(running) do
	local id,msg = rednet.receive(protocol,60) --large timeout to prevent infinite hang
	local result = ""

	if(msg ~= nil) then
		--short circuit if told to stop
		if(msg == "stop") then
			print("Stopping...")
			running = false
			result = "stopped"
			rednet.send(hostId,result,protocol)
			break

		--auto updating for ease of use
		elseif(msg == "update") then
			result = "updating"
			rednet.send(hostId,result,protocol)
			shell.run("/swarmSetup.lua")
			break

		elseif(msg == "locate") then	
			x,y,z = gps.locate()		
			result = textutils.serialize({x,y,z})
			-- result = "{"..x..","..y..","..z.."}"
			rednet.send(hostId,result,protocol)
			break

		else
			--at this point we could have potential arguments, so more processing is needed
			debug("msg:",msg)
			result = processCommand(msg)
		end

		--respond to the command
		rednet.send(hostId,textutils.serialize(result),protocol)
	end
	io.write(".") --ouptut to show heartbeat
end