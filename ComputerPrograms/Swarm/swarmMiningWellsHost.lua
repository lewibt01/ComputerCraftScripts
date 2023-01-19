package.path = package.path..";/api/?.lua"

s = require("swarm")
t = require("tableUtils")
n = require("numberUtils")

local debugFlag = false
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

--[[Setup]]
local protocol = "swarm:chunkMiner"
local ids = {3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18}
local locations = {}
local orientations = {}
local fuelLevels = {}
local inventories = {}

--init location data
for i=1,#ids do
	local t = ids[i]
	locations[t] = {0,70,0} --undo this hardcoding later once gps decides to work
	orientations[t] = 0
	fuelLevels[t] = 0
	inventories[t] = {}
end

--set protocol
s.protocol = protocol

--open rednet
peripheral.find("modem",rednet.open)

--[[Functions]]
function run(id,command)
	return s.sendCommand(id,command,s.protocol)
end

function locate()
	for i=1,#ids do
		local target = ids[i]
		locations[target] = run(target,"locate")
	end
end

function orient()
	for i=1,#ids do
		local target = ids[i]
		orientations[target] = run(target,"orient")
	end
end

function forward()
	s.distributeCommand(ids,"forward")
end

function back()
	s.distributeCommand(ids,"back")
end

function up()
	s.distributeCommand(ids,"up")
end

function down()
	s.distributeCommand(ids,"down")
end

function turnLeft()
	s.distributeCommand(ids,"turnLeft")
end

function turnRight()
	s.distributeCommand(ids,"turnRight")
end

function dig()
	s.distributeCommand(ids,"dig")
end

function digUp()
	s.distributeCommand(ids,"digUp")
end

function digDown()
	s.distributeCommand(ids,"digDown")
end

function place()
	s.distributeCommand(ids,"place")
end

function placeUp()
	s.distributeCommand(ids,"placeUp")
end

function placeDown()
	s.distributeCommand(ids,"placeDown")
end

function drop()
	s.distributeCommand(ids,"drop")
end

function dropDwon()
	s.distributeCommand(ids,"dropDown")
end

function dropUp()
	s.distributeCommand(ids,"dropUp")
end

function attack()
	s.distributeCommand(ids,"attack")
end

function attackUp()
	s.distributeCommand(ids,"attackUp")
end

function attackDown()
	s.distributeCommand(ids,"attackDown")
end

function refuel()
	s.distributeCommand(ids,"refuel")
end

function select(n)
	local tmp = n % 17 --not the most accurate but close enough
	s.distributeCommand(ids,"select "..tmp)
end

function getFuelLevel()
	for i=1,#ids do
		local target = ids[i]
		fuelLevels[target] = run(target,"getFuelLevel")
	end
end

--[[Aggregate functions]]
function refuelStep()
	--clear the block above the turtle
	digUp()

	--place the dump chest to empty a slot for fuel
	select(16)
	placeUp()

	--dump the first slot
	select(1)
	dropUp()

	--recollect the dump chest
	select(16)
	digUp()

	--place down the fuel chest and retrieve some fuel
	select(15)
	placeUp()
	select(1)
	suckUp()

	for i=1,4 do
		refuel()
	end

	--put the excess fuel back
	dropUp()

	--retrieve the fuel chest
	select(15)
	digUp()
end

function dumpInventory()
	select(16) --reserved slot for dump chest
	digUp()
	placeUp() --place dump chest above

	for i=1,14 do
		select(i)
		dropUp()
	end

	select(16)
	digUp()
	select(1)
end

function setupMiningWell()
	--place dump chest
	up()
	select(16)
	place()

	--place mining well
	down()
	select(15)
	place()

	--place power cell
	back()
	select(14)
	place()
end

--meant to be called immediately after setup
function teardownMiningWell()
	--reclaim power cell
	select(14)
	dig()

	--reclaim mining well
	select(15)
	forward()
	dig()

	--reclaim dump chest
	select(16)
	up()
	dig()

	--return to original state
	down()
end

--[[Main Execution]]

function main()
	orient()

	for i=1,1000 do
		print("Iteration",i)
		setupMiningWell()
		os.sleep(5)
		teardownMiningWell()
		forward()
		turtle.forward() --move the host forward with the swarm
	end
end