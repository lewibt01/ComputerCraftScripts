package.path = package.path..";/api/?.lua"

s = require("swarm")
t = require("tableUtils")

local debugFlag = false
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

local protocol = "swarm:chunkMiner"
local ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
local locations = {}
local orientations = {}

--init dictionaries
for i=1,#ids do
	locations[ids[i]] = {0,0,0}
	orientations[ids[i]] = 0
end

--set protocol
s.protocol = protocol

--open rednet
rednet.open("top")

--run the commands
s.distributeCommand(ids,"forward")