--Class designed to be full of helper functions for the gps library. 
---Should also be able to determine orientation based on movement (if we already have gps towers active)

g = {}

--wrap the gps function so it returns a table of results instead of 3 return values
function g.locate()
	return {gps.locate()}
end

--determine orientation by moving and comparing the difference in the coordinates
--this function shouldn't have to be called frequently, or could even be called around another function
--turtles can't face up, so only x/z coords matter here
--returns a numerical orientation (0=north, 1=east, 2=south, 3=west)
function g.orient()
	local startPos = g.locate()

	--be somewhat smart about where we move
	turtle.forward()
	local endPos = g.locate()

	local deltas = {endPos[1] - startPos[1], endPos[2] - startPos[2], endPos[3] - startPos[3]}

	if(deltas[1] == 0) then

	else
		if()
	end
end

return g