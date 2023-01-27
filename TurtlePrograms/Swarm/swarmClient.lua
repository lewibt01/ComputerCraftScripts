package.path = package.path..";/api/?.lua"

cmd = require("commandTranslate")
s = require("stringUtils")
t = require("tableUtils")
l = require("logging")
local logFileName = "swarmClient.txt"
l.wipe(logFileName) --ensure log file is fresh

-- local debugFlag = false
-- local function debug(...)
-- 	if(debugFlag) then
-- 		print(...)
-- 	end
-- end

-- local function debugIO(...)
-- 	if(debugFlag) then
-- 		io.write(...)
-- 	end
-- end

local hostId = 19
local protocol = "swarm:chunkMiner"

rednet.open("left")
local running = true

--[[Helper Functions]]
function respond(data)
	if(type(data) == "table") then
		l.debug("respond({"..table.concat(data,",").."})",logFileName)
	else
		l.debug("respond("..tostring(data)..")",logFileName)
	end
	local resp = textutils.serialize(data)
	rednet.send(hostId,resp,protocol)
end

--[[Macros]]
--make execution of the dig and digDown commands local to speed up distribution of commands
function digDownForward()
	l.debug("digDownForward()",logFileName)
	local results = {}
	table.insert(results,turtle.dig())
	table.insert(results,turtle.digDown())

	--if one of them returned true, we'll call it a success
	local result = false
	for i=1,#results do
		if(results[i]) then
			result = true
			break
		end
	end

	print("CMD:digDownForward","->",result)
	return result
end

--dump slots 1-14 into an ender chest stored in 16
function dumpInventory()
	l.debug("dumpInventory()",logFileName)

	turtle.select(16) --reserved slot for dump chest
	turtle.digUp()
	turtle.placeUp() --place dump chest above

	local verification = {}
	for i=1,14 do
		turtle.select(i)
		turtle.dropUp()
		verification[i] = turtle.getItemCount(i) == 0
	end

	turtle.select(16)
	turtle.digUp()
	turtle.select(1)

	local result = true
	for i=1,#verification do
		if(not verification[i]) then
			result = false
			break
		end
	end

	print("CMD:dumpInventory","->",result)
	return result
end

function refuelFromChest()
	l.debug("refuelFromChest()",logFileName)
	local startingFuel = turtle.getFuelLevel()
	l.info("Starting Fuel: "..tostring(startingFuel),logFileName)

	--clear the block above the turtle
	turtle.digUp()

	--place the dump chest to empty a slot for fuel
	turtle.select(16)
	turtle.placeUp()

	--dump the first slot
	turtle.select(1)
	turtle.dropUp()

	--recollect the dump chest
	turtle.select(16)
	turtle.digUp()

	--place down the fuel chest and retrieve some fuel
	turtle.select(15)
	turtle.placeUp()
	turtle.select(1)
	turtle.suckUp(4) -- pull out 4 items from the chest

	for i=1,4 do
		turtle.refuel()
	end

	local newFuel = turtle.getFuelLevel()
	l.debug("Ending Fuel:"..tostring(newFuel),logFileName)

	--retrieve the fuel chest
	turtle.select(15)
	turtle.digUp()

	--ensure we have more fuel than when we started
	result = startingFuel < newFuel

	print("CMD:refuelFromChest","->",result)
	return result
end

function locate()
	l.debug("locate()",logFileName)
	local x,y,z = gps.locate()
	local data = table.pack(x,y,z)
	print("CMD:locate","->",data)
	return data
	-- result = textutils.serialize({x,y,z})
	-- -- result = "{"..x..","..y..","..z.."}"
	-- rednet.send(hostId,result,protocol)
end

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
	l.debug("processArgs("..commandString..")",logFileName)
	--if we have args...
	if(string.find(commandString," ")) then
		local pieces = s.splitStr(commandString," ")
		l.debug("\tpieces:"..table.concat(pieces,","),logFileName)
		local cmdTable,args = t.split(pieces,2)
		l.debug("\tcmdTable:",table.concat(cmdTable,","),logFileName)
		l.debug("\targs:",table.concat(args,","))
		local command = cmdTable[1]

		--convert numeric arguments to numbers
		args = t.convertToNumbers(args)

		return command,args
	--otherwise...
	else
		l.info("No args: "..commandString)
		return commandString,nil
	end
end

function processCommand(commandString)
	l.debug("processCommand("..commandString..")",logFileName)

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

	l.debug("\t->"..tostring(result),logFileName)
	print("->"..tostring(result))
	return result
end

while(running) do
	l.debug("Begin main loop",logFileName)
	local id,msg = rednet.receive(protocol,60) --large timeout to prevent infinite hang
	l.info("Received "..tostring(msg).." from ID:"..tostring(id),logFileName)
	local result = ""

	if(msg ~= nil) then
		--short circuit if told to stop
		if(msg == "stop") then
			print("Stopping.")
			running = false
			respond("stopped")
			break

		--auto updating for ease of use
		elseif(msg == "update") then
			respond("updating")
			shell.run("/swarmSetup.lua")
			break

		elseif(msg == "locate") then
			result = locate()

		elseif(msg == "dumpInventory") then
			result = dumpInventory()

		elseif(msg == "refuelFromChest") then
			result = refuelFromChest()

		elseif(msg == "digDownForward") then
			result = digDownForward()

		else
			--at this point we could have potential arguments, so more processing is needed
			debug("msg:",msg)
			result = processCommand(msg)
		end

		--respond to the command
		-- rednet.send(hostId,textutils.serialize(result),protocol)
		respond(result)
	end
	io.write(".") --ouptut to show heartbeat
end