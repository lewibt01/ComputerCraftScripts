package.path = package.path..";/api/?.lua"

local s = {}
s.protocol = "swarm"
s.ids = {}
s.responseTimeout = 5

l = require("logging")
local logFileName = "swarmAPI.txt"
l.wipe(logFileName) --ensure log file is fresh

--[[Registration Functions]]
function s.register(id)
	l.debug("register("..tostring(id)..")",logFileName)
	if(s.ids[id] ~= true) then
		s.ids[id] = true
	end
end

function s.deregister(id)
	l.debug("deregister("..tostring(id)..")",logFileName)
	s.ids[id] = nil
end

function s.getRegistry()
	l.debug("getRegistry()",logFileName)
	local output = {}
	for k,v in pairs(s.ids) do
		table.insert(output,k)
	end

	return output
end

function s.sendCommand(targetId,command)
	l.debug("sendCommand("..tostring(targetId)..","..command..")",logFileName)
	--attempt to open rednet if it isn't already
	if(not rednet.isOpen()) then
		peripheral.find("modem",rednet.open)
	end

	rednet.send(targetId,command,s.protocol)

	local id,msg = rednet.receive(s.protocol,s.responseTimeout)
	l.debug("raw msg:"..tostring(msg),logFileName)

	--deserialize the response from the client (msg)
	msg = textutils.unserialize(msg)
	if(type(msg) == "table") then
		l.debug("deserialized msg:{"..table.concat(msg,",").."}",logFileName)
	else
		l.debug("deserialized msg:"..tostring(msg),logFileName)
	end

	return id,msg
end

function s.distributeCommand(idList,command)
	l.debug("distributeCommand({"..table.concat(idList,",").."},"..command..")",logFileName)
	for i=1,#idList do
		local id,result = s.sendCommand(idList[i],command)

		if(result ~= nil) then
			io.write(id,":")
			
			--if we have something, unserialize it
			-- result = textutils.unserialize(result) --this should already be unserialized in sendCommand()

			if(type(result) == "table") then
				print(table.concat(result,","))
			else
				print(result)
			end
		else
			l.error("Failed to get repsonse from "..idList[i],logFileName)
			print("Failed to get response from "..idList[i])
		end
	end
end

function s.broadcastCommand(command)
	l.debug("broadcastCommand("..command..")",logFileName)
	local responses = {}
	local coroutines = {}
	rednet.broadcast(command,s.protocol)

	for i=1,#s.ids do
		local c = coroutine.create(rednet.receive)
		table.insert(coroutines,c)
	end
end

return s