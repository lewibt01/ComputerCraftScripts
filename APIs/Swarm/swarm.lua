local s = {}
s.protocol = "swarm"
-- s.ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
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

function s.sendCommand(targetId,command)
	--attempt to open rednet if it isn't already
	if(not rednet.isOpen()) then
		peripheral.find("modem",rednet.open)
	end

	rednet.send(targetId,command,protocol)

	local id,msg = rednet.receive(protocol,2)
	return id,msg
end

function s.distributeCommands(command,idList)
	for i=1,#idList do
		local id,result = sendCommand(idList[i],command)

		if(result ~= nil) then
			io.write(id)
			io.write(":")
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