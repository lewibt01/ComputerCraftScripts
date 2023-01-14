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
	locations[target] = {0,0,0}
	orientations[target] = 0
	fuelLevels[target] = 0
	inventories[target] = {}
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

function checkFuel()

end

function plumbDepth()
	local target = ids[1]
	debug(table.concat(locations[target]))

	local y = locations[target][2] - 1

	return y
end

function findNumIterations()
	local depth = plumbDepth()
	return math.floor(depth / 3)
end

--ensure the turtle has at least one free slot
function hasFreeSlot(target)
	local slotIsFree = {}
	for i=1,14 do
		run(target, "select "..i)
		slotIsFree[i] = (run(target,"getItemCount") == 0)
	end

	--check for at least one free slot, 
	local hasFreeSlot = false
	for i=1,#slotIsFree do
		if(slotIsFree[i]) then
			hasFreeSlot = true
		end
	end

	return hasFreeSlot
end

function dumpInventory()
	select(16) --reserved slot for dump chest
	placeUp() --place dump chest above

	for i=1,14 do
		select(i)
		dropUp()
	end

	select(16)
	digUp()
	select(1)
end

--digging steps
function digDownStep()
	digDown()
	down()
	digDown()
	down()
	--adding a third makes the quarry more efficient, but makes it less resilient to falling blocks
end

function digFowrardStep()
	for i=1,16 do
		dig()
		digUp()
		digDown()
		forward()
	end
end

function rotateStep()
	rotateRight()
	rotateRight()
end

function main()
	print("Starting quarry")

	--determine start height, return to this height later
	local startHeight = plumbDepth(ids[1])

	--try to keep tabs on where we are,
	---this will help with fault tolerance later on
	locate()
	orient()

	--do the digging
	local iterations = findNumIterations()
	for i=1,iterations do
		print("Step:",i,"/",iterations)
		digDownStep()
		digForwardStep()
		rotateStep()
		dumpInventory()
		locate()
	end

	--return to start height
	local endHeight = plumbDepth()
	local heightToClimb = startHeight - endHeight
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