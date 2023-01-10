local debugFlag = true
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

local arg = {...}

function checkFuel(l, d) --length, width, depth
	numMoves = ((d*2) * l) + l
	fuelLvl = turtle.getFuelLevel()
	if(fuelLvl < numMoves) then
		print("Insufficient fuel: "..fuelLvl.."/"..numMoves)
		return false
	end

	return true
end

function drill(d)  --depth
	local actualDepth = 0
	debug("drilled down "..d.." blocks")

	for i=1,d do
		turtle.digDown()
		
		if(turtle.down()) then
			actualDepth = actualDepth + 1
		end
	end

	turtle.dig()
	turtle.forward()

	for i=1,actualDepth do
		turtle.digUp()
		turtle.up()
	end
	debug("Moved up "..actualDepth.." blocks")
end

function ensureMove(moveFunc,attackFunc,digFunc)
	local counter = 10
	local result = turtle.down()
	while(not result and counter > 0) do
		digFunc()
		attackFunc()
		os.sleep(1)
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

-- the main loop that iterates through 
function run(l,d) --length, depth
	if(checkFuel(l,d)) then
		for j=1,l do
			drill(d)	
		end
	end
end

--[[Argument Input]]
debug(table.concat(arg,","))

length = 0
if(length == 0) then
	if(arg[1] == nil) then
		debug("No length provided, assuming 4")
		arg[1] = "4"
	else
		length = tonumber(arg[1])
	end
end

depth = 0
if(depth == 0) then
	if(arg[2] == nil) then
		debug("No depth argument provided, assuming 100")
		arg[2] = "100"
	else
		depth = tonumber(arg[2])
	end
end

-- Run main()

run(length,depth)
