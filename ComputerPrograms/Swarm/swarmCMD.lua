package.path = package.path..";/api/?.lua"

l = require("logging")
local logFileName = "swarmCMD.txt"
l.wipe(logFileName) --ensure log file is fresh

-- local debugFlag = false
-- local function debug(...)
-- 	if(debugFlag) then
-- 		print(...)
-- 	end
-- end

local arg = {...}
local protocol = "swarm:chunkMiner"

ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}

s = require("swarm")
s.protocol = protocol

--register the computer IDs
for i=1,#ids do
	s.register(ids[i])
end

peripheral.find("modem",rednet.open)

l.debug("Sending:\""..table.concat(arg).."\" to "..table.concat(ids,","),logFileName)

--run the command
s.distributeCommand(ids,arg[1])

peripheral.find("modem",rednet.close)