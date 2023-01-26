--Class designed to be full of helper functions for the gps library. 
---Should also be able to determine orientation based on movement (if we already have gps towers active)

g = {}

--wrap the gps function so it returns a table of results instead of 3 return values
function g.locate()
	-- local x, y, z = gps.locate()
	-- local result = {x,y,z}
	return {gps.locate()}
end

--determine orientation by moving and comparing the difference in the coordinates
--this function shouldn't have to be called frequently, or could even be called around another function
--turtles can't face up, so only x/z coords matter here
--returns a numerical orientation (0=north, 1=east, 2=south, 3=west)
function g.orient()
	local startPos = g.locate()

	--TODO: be somewhat smart about where we move
	turtle.forward()
	local endPos = g.locate()

	turtle.back()

	local deltas = {endPos[1] - startPos[1], endPos[2] - startPos[2], endPos[3] - startPos[3]}

	--if there was no change in the x coord, then it must have changed in the z coord
	if(deltas[1] == 0) then
		if(deltas[3] > 0) then
			return 2
		else
			return 0
		end
	else
		if(deltas[1] > 0) then
			return 1
		else
			return 3
		end
	end
end

return g