package.path = package.path..";/api/?.lua"

p = require("properties")
f = require("fileUtils")

local debugFlag = false
local function debug(...)
	if(debugFlag) then
		print(...)
	end
end

local gpsMove = {}

gpsMove.propertyHeader = "gpsMove/"
gpsMove.position = {0,0,0} --using minecraft coords here, y is height, x/z is horizontal components
gpsMove.orientation = 0 --0-3, for north, east, south, west

--[[Data File Handlers]]
function saveLocation()
	--todo add code that writes to a file in /appdata/
	p.set(fs.combine(gpsMove.propertyHeader,"position"),gpsMove.position)
	p.set(fs.combine(gpsMove.propertyHeader,"orientation"),gpsMove.orientation)
end

--[[Base Functions]]
function gpsMove.reZero()
	gpsMove.position = {0,0,0}
	gpsMove.orientation = 0
end

function gpsMove.getX()
	return gpsMove.position[1]
end

function gpsMove.getY()
	return gpsMove.position[2]
end

function gpsMove.getZ()
	return gpsMove.position[3]
end

function gpsMove.setX(x)
	gpsMove.position[1] = x
	saveLocation()
end

function gpsMove.setY(y)
	gpsMove.position[2] = y
	saveLocation()
end

function gpsMove.setZ(z)
	gpsMove.position[3] = z
	saveLocation()
end

function gpsMove.getPosition()
	return gpsMove.position
end

function setOrientation(dir)
	gpsMove.orientation = dir
	saveLocation()
end

function gpsMove.getOrientation()
	return gpsMove.orientation
end

function gpsMove.forward()
	local result = turtle.forward()
	if(result) then
		if(gpsMove.orientation==0) then
			-- gpsMove.position[3] = gpsMove.position[3] - 1 --decrement z to go north
			gpsMove.setZ(gpsMove.getZ() - 1)
		elseif(gpsMove.orientation == 1) then
			-- gpsMove.position[1] = gpsMove.position[1] + 1 --increment x to go east
			gpsMove.setX(gpsMove.getX() + 1)
		elseif(gpsMove.orientation == 2) then
			-- gpsMove.position[3] = gpsMove.position[3] + 1 --increment z to go south
			gpsMove.setZ(gpsMove.getZ() + 1)
		elseif(gpsMove.orientation == 3) then
			-- gpsMove.position[1] = gpsMove.position[1] - 1 --decrement x to go west
			gpsMove.setX(gpsMove.getX() - 1)
		else
			debug("Error in gpsMove.forward()")
			return false
		end
	end
	return result
end

function gpsMove.back()
	local result = turtle.back()
	if(result) then
		if(gpsMove.orientation == 0) then
			-- gpsMove.position[3] = gpsMove.position[3] + 1
			gpsMove.setZ(gpsMove.getZ() + 1)
		elseif(gpsMove.orientation == 1) then
			-- gpsMove.position[1] = gpsMove.position[1] - 1
			gpsMove.setX(gpsMove.getX() - 1)
		elseif(gpsMove.orientation == 2) then
			-- gpsMove.position[3] = gpsMove.position[3] - 1
			gpsMove.setZ(gpsMove.getZ() - 1)
		elseif(gpsMove.orientation == 3) then
			-- gpsMove.position[1] = gpsMove.position[1] + 1
			gpsMove.setX(gpsMove.getX() + 1)
		else
			debug("Error in gpsMove.back()")
			return false
		end
	end
	return result
end

function gpsMove.up()
	local result = turtle.up()
	if(result) then
		gpsMove.position[2] = gpsMove.position[2] + 1
	end
	return result
end

function gpsMove.down()
	local result = turtle.down()
	if(result) then
		-- gpsMove.position[2] = gpsMove.position[2] - 1
		gpsMove.setY(gpsMove.getY() - 1)
	end
	return result
end

function gpsMove.turnRight()
	local result = turtle.turnRight()
	if(result) then
		gpsMove.orientation = gpsMove.orientation + 1
		gpsMove.orientation = gpsMove.orientation % 4
	end
	return result
end

function gpsMove.turnLeft()
	local result = turtle.turnLeft()
	if(result) then
		gpsMove.orientation = gpsMove.orientation - 1
		gpsMove.orientation = gpsMove.orientation % 4
	end
	return result
end

--[[Compund Functions]]
function gpsMove.turnTo(orient)
	debug("///////////////////////////////")
	debug("/    raw orient = "..orient)
	orient = orient % 4
	debug("/    orient start: "..gpsMove.orientation.." target: "..orient)
	--print("/  orienting to "..orient)
	local direction = orient-gpsMove.orientation --this will be positive/negative to denote direction of the turn, actual value does not matter, just the parity
	if(direction > 2) then
		direction = (direction*-1) % -2
	end
	debug("/    direction raw: "..orient-gpsMove.orientation.." adjusted: "..direction)
	debug("/    turning "..direction)

	local magnitude = math.abs(direction)--how many turns we will have to make, there should be no more than 2
	debug("/    magnitude raw: "..math.abs(direction).." adjusted: "..magnitude)

	local turnFunc --will store a reference to the turn function being called based on <direction> parity
	if(direction > 0) then
		turnFunc = gpsMove.turnRight
		debug("/    turnRight "..magnitude)
	elseif(direction < 0) then
		turnFunc = gpsMove.turnLeft
		debug("/    turnLeft "..magnitude)
	elseif(direction == 0) then
		--do nothing, we are 0 turns away from the desired orientation
		debug("/    No turn necessary")
	else
		debug("/    Error in turnTo()")
	end

	local result
	for i=1,magnitude do
		result = turnFunc()
	end
	return result
end

function gpsMove.moveTo(x,y,z)
	--determine oriantation vs new position, do movements 1 axis at a time, y-axis first
	local dX = x-gpsMove.position[1]
	local dY = y-gpsMove.position[2]
	local dZ = z-gpsMove.position[3]
	debug("Delta",dX,dY,dZ)

	local function moveAmnt(func,amnt)
		local result
		for i=1,math.abs(amnt) do
			result = func()
		end
		return result
	end

	local function moveVerticalAmnt(amount)
		local result
		if(amount > 0) then
			result = moveAmnt(gpsMove.up,amount)
			debug("up "..amount)
		elseif(amount < 0) then
			result = moveAmnt(gpsMove.down,amount)
			debug("down "..amount)
		end
		return result
	end

	--x coordinates: + = right, - = left
	local function moveXAmnt(amount)
		if(amount > 0) then
			gpsMove.turnTo(1)
			debug("X+ "..amount)
		elseif(amount < 0) then
			gpsMove.turnTo(3)
			debug("X- "..amount)
		end
		return moveAmnt(gpsMove.forward,amount)
	end

	--z coordinates: + = south, - = north
	local function moveZAmnt(amount)
		if(amount > 0) then
			gpsMove.turnTo(2)
			debug("Z+ "..amount)
		elseif(amount < 0) then
			gpsMove.turnTo(0)
			debug("Z- "..amount)
		end
		return moveAmnt(gpsMove.forward,amount)
	end

	--vertical axis requires no orientation adjustment
	--print("Before Y:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dY:"..dY,gpsMove.positionStr(),"Positive delta: "..tostring(dY >= 0))
	moveVerticalAmnt(dY)
	--print("After Y:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dY:"..dY,gpsMove.positionStr(),"Positive delta: "..tostring(dY >= 0))

	--East/West axis
	--print("Before X:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dX:"..dX,gpsMove.positionStr(),"Positive delta: "..tostring(dX >= 0))
	moveXAmnt(dX)
	--print("After X:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dX:"..dX,gpsMove.positionStr(),"Positive delta: "..tostring(dX >= 0))
	--print("-----")


	--North/Souch axis
	--print("Before Z:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dZ:"..dZ,gpsMove.positionStr(),"Positive delta: "..tostring(dZ >= 0))
	moveZAmnt(dZ)
	--print("After Z:",gpsMove.orientation..":"..gpsMove.orientationStr(),"dZ:"..dZ,gpsMove.positionStr(),"Positive delta: "..tostring(dZ >= 0))
end

function gpsMove.positionStr()
	return "{"..gpsMove.position[1]..","..gpsMove.position[2]..","..gpsMove.position[3].."}"
end

function gpsMove.printPosition()
	print(gpsMove.positionStr())
end

function gpsMove.orientationStr()
	local switch = {}
	switch[0] = "north"
	switch[1] = "east"
	switch[2] = "south"
	switch[3] = "west"
	return switch[gpsMove.orientation]
end

function gpsMove.printOrientation()
	print(gpsMove.orientationStr())
end

return gpsMove