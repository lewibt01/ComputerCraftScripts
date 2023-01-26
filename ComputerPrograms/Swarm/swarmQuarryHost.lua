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
local criticalFuelLevel = 1000
local locations = {}
local orientations = {}
local fuelLevels = {}
local inventories = {}


--init starting data
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

--[[Aggregate Functions]]
function test()
	--init
	locate()
	orient()

	--get turtles into position
	digDown()
	down()
	digDown()
	down()

	--DEBUG: attampt to reverse other actions
	up()
	placeDown()
	up()
	placeDown()
end

-- returns whether or not fuel levels are acceptable
function checkFuel()
	--get the most up-to-date info
	getFuelLevel()

	for i=1,#ids do
		local target = ids[i]
		if(fuelLevels[target] < criticalFuelLevel) then
			return false
		end
	end

	return true
end

function plumbDepth()
	local target = ids[1]
	local y = locations[target][2] - 1
	return y
end

function findNumIterations()
	local depth = plumbDepth()
	return math.floor(depth / 2)
end

--ensure the turtle has at least one free slot
function hasFreeSlot(target)
	local slotIsFree = {}
	for i=1,14 do
		run(target, "select "..i)
		slotIsFree[i] = (run(target,"getItemCount") == 0)
	end

	--check for at least one free slot, 
	local freeSlotAvailable = false
	for i=1,#slotIsFree do
		if(slotIsFree[i]) then
			freeSlotAvailable = true
		end
	end

	return freeSlotAvailable
end

-- baked into turtle client now (as dumpInventory), kept as a backup
-- function dumpInventory()
-- 	select(16) --reserved slot for dump chest
-- 	digUp()
-- 	placeUp() --place dump chest above

-- 	for i=1,14 do
-- 		select(i)
-- 		dropUp()
-- 	end

-- 	select(16)
-- 	digUp()
-- 	select(1)
-- end

-- baked into turtle client now (as refuelAll), kept as a backup
-- function refuelStep()
-- 	--clear the block above the turtle
-- 	digUp()

-- 	--place the dump chest to empty a slot for fuel
-- 	select(16)
-- 	placeUp()

-- 	--dump the first slot
-- 	select(1)
-- 	dropUp()

-- 	--recollect the dump chest
-- 	select(16)
-- 	digUp()

-- 	--place down the fuel chest and retrieve some fuel
-- 	select(15)
-- 	placeUp()
-- 	select(1)
-- 	suckUp()

-- 	for i=1,4 do
-- 		refuel()
-- 	end

-- 	--retrieve the fuel chest
-- 	select(15)
-- 	digUp()
-- end

--refuel the turtles if they need it
function refuelStep()
	if(not checkFuel()) then
		s.distributeCommand(ids,"refuelAll")
	end
end

--digging steps
function digDownStep()
	digDown()
	down()
	digDown()
	down()
	--adding a third iteration makes the quarry more efficient, but makes it less resilient to falling blocks
end

function digForwardStep()
	for i=1,16 do
		dig()
		-- digUp()
		digDown()
		forward()
	end
end

function rotateStep()
	turnRight()
	turnRight()
end

function main()
	print("Starting quarry")

	--try to keep tabs on where we are,
	---this will help with fault tolerance later on
	locate()
	orient()

	--determine start height, return to this height later
	local startHeight = plumbDepth()

	--do the digging
	local iterations = findNumIterations()
	for i=1,iterations do
		print("Step:",i,"/",iterations)
		digDownStep()
		digForwardStep()
		rotateStep()
		dumpInventory()
		refuelStep()
		-- locate()
	end

	--return to start height
	-- local endHeight = plumbDepth()
	-- local heightToClimb = startHeight - endHeight
	local heightToClimb = startHeight --this is a workaround for the gps issue
	print("Climbing:",heightToClimb)
	for i=1,heightToClimb do
		attackUp()
		digUp()
		up()
	end

	print("Quarry finished")
end

--[[Main Execution]]
main()


--run the commands
-- s.distributeCommand(ids,"forward")