local s = {}
s.protocol = "swarm"
s.ids = {}

--[[Registration Functions]]
function s.register(id)
	if(s.ids[id] ~= true) then
		s.ids[id] = true
	end
end

function s.deregister(id)
	s.ids[id] = nil
end

function s.getRegistry()
	local output = {}
	for k,v in pairs(s.ids) do
		table.insert(output,k)
	end

	return output
end

function s.sendCommand(targetId,command)
	--attempt to open rednet if it isn't already
	if(not rednet.isOpen()) then
		peripheral.find("modem",rednet.open)
	end

	rednet.send(targetId,command,s.protocol)

	local id,msg = rednet.receive(s.protocol,2)
	return id,msg
end

function s.distributeCommand(idList,command)
	for i=1,#idList do
		local id,result = s.sendCommand(idList[i],command)

		if(result ~= nil) then
			io.write(id)
			io.write(":")
			
			--if we have something, unserialize it
			result = textutils.unserialize(result)
			print(result)
		else
			print("Failed to get response from "..idList[i])
		end
	end
end

function s.broadcastCommand(command)
	local responses = {}
	local coroutines = {}
	rednet.broadcast(command,s.protocol)

	for i=1,#s.ids do
		local c = coroutine.create(rednet.receive)
		table.insert(coroutines,c)
	end
end

return s