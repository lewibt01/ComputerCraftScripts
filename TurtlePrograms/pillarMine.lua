local arg = {...}

function checkFuel(length, width, depth)
	numMoves = (depth*2) * length * width
	fuelLvl = turtle.getFuelLevel()
	if(fuelLvl < numMoves) then
		print("Insufficient fuel: "..fuelLvl.."/"..numMoves)
		return false
	end

	return true
end

function drillDown(depth)
	local actualDepth = 0
	for i=1,depth do
		turtle.digDown()
		
		if(turtle.down()) then
			actualDepth = actualDepth + 1
		end
	end
	for i=1,actualDepth do
		turtle.up()
	end

	print("Drilled "..actualDepth.." blocks down")
end

function digIfPresent()
	if(turtle.detect()) then
		return turtle.dig()
	end

	return false
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
	if(checkFuel(length,width,depth)) then
		local currentTurnDirection = 1
		for i=1,w do
			for j=1,l do
				drillDown(d)
				
				digIfPresent()
				turtle.forward()
			end

			--turn direction must be alternated to ensure going in one direction
			turn(currentTurnDirection)

			digIfPresent()
			turtle.forward()

			turn(currentTurnDirection)

			--flip the direction
			currentTurnDirection = currentTurnDirection * -1
		end
	end
end

--[[Argument Input]]
length = 0
if(arg[1] == nil) then
	print("No length provided, assuming 4")
	arg[1] = "4"
	depth = tonumber(arg[1])
end

width = 0
if(arg[2] == nil) then
	print("No width provided, assuming 4")
	arg[2] = "4"
else
	width = tonumber(arg[2])
end

depth = 0
if(arg[3] == nil) then
	print("No depth argument provided, assuming 100")
	arg[3] = "100"
else
	length = tonumber(arg[3])
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