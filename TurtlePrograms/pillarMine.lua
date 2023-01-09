local debugFlag = true
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

local arg = {...}

function checkFuel(l, w, d) --length, width, depth
	numMoves = (d*2) * l * w
	fuelLvl = turtle.getFuelLevel()
	if(fuelLvl < numMoves) then
		print("Insufficient fuel: "..fuelLvl.."/"..numMoves)
		return false
	end

	return true
end

function drillDown(d)  --depth
	local actualDepth = 0
	debug("drillDown() depth:"..d)

	for i=1,d do
		turtle.digDown()
		
		if(turtle.down()) then
			actualDepth = actualDepth + 1
		end
	end
	for i=1,actualDepth do
		ensureMoveUp()
	end

	-- print("Drilled "..actualDepth.." blocks down")
end

function digIfPresent()
	if(turtle.detect()) then
		return turtle.dig()
	end

	return false
end

function ensureMove(moveFunc,attackFunc,digFunc)
	local counter = 10
	local result = turtle.down()
	while(not result and counter > 0) do
		digFunc()
		attackFunc()
		turtle.sleep(1)
		result = moveFunc()
		counter = counter - 1
	end

	return result
end

function ensureMoveDown()
	return ensureMove(turtle.down, turtle,attackDown, turtle.digDown)
end


function ensureMoveUp()
	return ensureMove(turtle.up, turtle.attackUp, turtle.digUp)
end

function ensureMoveForward()
	return ensureMove(turtle.forward, turtle.attack, turtle.dig)
end

--this function facilitates the alternating turn direction for the quarry program
function turn(direction)
	if(direction == -1) then
		return turtle.turnLeft()
	else
		return turtle.turnRight()
	end
end

-- the main loop that iterates through 
function run(l,w,d) --length, width, depth
	if(checkFuel(l,w,d)) then
		local currentTurnDirection = 1
		debug("l:"..l..", w:"..w..", d:"..d)
		for i=1,w do
			for j=1,l do
				drillDown(d)
				
				digIfPresent()
				ensureMoveForward()
			end

			--turn direction must be alternated to avoid going in circles
			turn(currentTurnDirection)

			digIfPresent()
			ensureMoveForward()

			turn(currentTurnDirection)
			ensureMoveForward()

			--flip the direction
			currentTurnDirection = currentTurnDirection * -1
		end
	end
end

--[[Argument Input]]
debug(table.concat(arg,","))

length = 0
if(length == 0) then
	debug("arg1: "..arg[1])
	if(arg[1] == nil) then
		print("No length provided, assuming 4")
		arg[1] = "4"
	else
		length = tonumber(arg[1])
	end
end

width = 0
if(width == 0) then
	debug("arg2: "..arg[2])
	if(arg[2] == nil) then
		print("No width provided, assuming 4")
		arg[2] = "4"
	else
		width = tonumber(arg[2])
	end
end

depth = 0
if(depth == 0) then
	debug("arg3: "..arg[3])
	if(arg[3] == nil) then
		print("No depth argument provided, assuming 100")
		arg[3] = "100"
	else
		depth = tonumber(arg[3])
	end
end

-- Run main()

run(length,width,depth)

-- if(checkFuel(arg[1], arg[2], arg[3])) then
-- 	print("Place a chest behind the turtle")
-- 	drillDown(tonumber(arg[1]))

-- 	turtle.turnRight()
-- 	turtle.turnRight()

-- 	for i=1,16 do
-- 		turtle.select(i)
-- 		turtle.drop()
-- 	end

-- 	turtle.turnRight()
-- 	turtle.turnRight()
-- end