package.path = package.path..";/api/?.lua"

s = require("swarm")
t = require("tableUtils")
n = require("numberUtils")
l = require("logging") --hell yeah, actual logging in computercraft. In your face devs
local logFileName = "swarmQuarry.txt"
l.wipe(logFileName) --ensure the log file is fresh

-- shitty print logging aint gonna cut it... use real log files
-- local debugFlag = true
-- local function debug(...)
-- 	if(debugFlag) then
-- 		print(...)
-- 	end
-- end



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
	l.debug("run("..tostring(id)..","..command..")",logFileName)
	return s.sendCommand(id,command,s.protocol)
end

function locate()
	for i=1,#ids do
		local target = ids[i]
		local id,result = run(target,"locate")
		local x,y,z = table.unpack(result)

		if(type(result) == "table") then
			l.debug("locate(table):"..table.concat(result,","), logFileName)
		else
			l.debug("locate():"..result, logFileName)
		end
		l.debug("x:"..tostring(x)..",y:"..tostring(y)..",z:"..tostring(z),logFileName)

		locations[target] = {x,y,z} --result --run(target,"locate")
	end
end

function orient()
	l.debug("orient()",logFileName)
	for i=1,#ids do
		local target = ids[i]
		_, orientations[target] = run(target,"orient")
	end
end

function forward()
	l.debug("forward()",logFileName)
	s.distributeCommand(ids,"forward")
end

function back()
	l.debug("back()",logFileName)
	s.distributeCommand(ids,"back")
end

function up()
	l.debug("up()",logFileName)
	s.distributeCommand(ids,"up")
end

function down()
	l.debug("down()",logFileName)
	s.distributeCommand(ids,"down")
end

function turnLeft()
	l.debug("turnLeft()",logFileName)
	s.distributeCommand(ids,"turnLeft")
end

function turnRight()
	l.debug("turnRight()",logFileName)
	s.distributeCommand(ids,"turnRight")
end

function dig()
	l.debug("dig()",logFileName)
	s.distributeCommand(ids,"dig")
end

function digUp()
	l.debug("digUp()",logFileName)
	s.distributeCommand(ids,"digUp")
end

function digDown()
	l.debug("digDown()",logFileName)
	s.distributeCommand(ids,"digDown")
end

function place()
	l.debug("place()",logFileName)
	s.distributeCommand(ids,"place")
end

function placeUp()
	l.debug("placeUp()",logFileName)
	s.distributeCommand(ids,"placeUp")
end

function placeDown()
	l.debug("placeDown()",logFileName)
	s.distributeCommand(ids,"placeDown")
end

function drop()
	l.debug("drop()",logFileName)
	s.distributeCommand(ids,"drop")
end

function dropDwon()
	l.debug("dropDown()",logFileName)
	s.distributeCommand(ids,"dropDown")
end

function dropUp()
	l.debug("dropUp()",logFileName)
	s.distributeCommand(ids,"dropUp")
end

function attack()
	l.debug("attack()",logFileName)
	s.distributeCommand(ids,"attack")
end

function attackUp()
	l.debug("attackUp()",logFileName)
	s.distributeCommand(ids,"attackUp")
end

function attackDown()
	l.debug("attackDown()",logFileName)
	s.distributeCommand(ids,"attackDown")
end

function refuel()
	l.debug("refuel()",logFileName)
	s.distributeCommand(ids,"refuel")
end

function select(n)
	l.debug("select("..tostring(n)..")",logFileName)
	local tmp = n % 17 --not the most accurate but close enough
	s.distributeCommand(ids,"select "..tmp)
end

function getFuelLevel()
	l.debug("getFuelLevel()",logFileName)
	for i=1,#ids do
		local target = ids[i]
		_, fuelLevels[target] = run(target,"getFuelLevel")
	end
end

--[[Aggregate Functions]]
function test()
	l.debug("test()",logFileName)
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
	l.debug("checkFuel()",logFileName)
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
	l.debug("plumbDepth()",logFileName)

	local target = ids[1]
	l.info("target="..tostring(target),logFileName)

	--heavy debug logging
	for k,v in pairs(locations) do
		if(type(v) == "table") then
			l.debug("\t"..k..",{"..table.concat(v).."}",logFileName)
		else
			l.debug("\t"..k..","..v,logFileName)
		end
	end

	l.debug("locations[target]="..tostring(locations[target]),logFileName)

	local y = locations[target][2] - 1
	l.info("y="..tostring(y),logFileName)

	return y
end

function findNumIterations()
	l.debug("findNumIterations()",logFileName)
	local depth = plumbDepth()
	local numIters = math.floor(depth / 2)
	l.info("Will run for "..tostring(numIters).." iterations",logFileName)

	return numIters
end

--ensure the turtle has at least one free slot
function hasFreeSlot(target)
	l.debug("hasFreeSlot("..tostring(target)..")",logFileName)
	local slotIsFree = {}
	for i=1,14 do
		run(target, "select "..i)
		_, slotIsFree[i] = run(target,"getItemCount") == 0
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
	l.debug("refuelStep()",logFileName)
	if(not checkFuel()) then
		s.distributeCommand(ids,"refuelAll")
	end
end

--digging steps
function digDownStep()
	l.debug("digDownStep()",logFileName)
	digDown()
	down()
	digDown()
	down()
	--adding a third iteration makes the quarry more efficient, but makes it less resilient to falling blocks
end

function digForwardStep()
	l.debug("digForwardStep()",logFileName)
	for i=1,15 do
		dig()
		-- digUp()
		digDown()
		forward()
	end
end

function rotateStep()
	l.debug("rotateStep()",logFileName)
	turnRight()
	turnRight()
end

function main()
	print("Starting quarry")
	l.debug("main()",logFileName)

	--try to keep tabs on where we are,
	---this will help with fault tolerance later on
	locate()
	orient()

	--determine start height, return to this height later
	local startHeight = plumbDepth()
	l.info("Starting height is "..tostring(startHeight),logFileName)

	--do the digging
	local iterations = findNumIterations()
	for i=1,iterations do
		print("Step:",i,"/",iterations)
		l.info("Iteration #: "..tostring(i).."/"..tostring(iterations),logFileName)
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