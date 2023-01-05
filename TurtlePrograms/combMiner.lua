local arg = {...}

function trunkStep()
	turtle.dig() --clear the first block
	turtle.forward() --move into the newly created space
	turtle.digUp() --clear the block above
	
	--move up and clear the left two blocks
	turtle.up()
	turtle.turnLeft()
	turtle.dig()
	turtle.down()
	turtle.dig()

	--return turtle to original orientation
	turtle.turnRight()
end

function combStep()
	turtle.dig()
	turtle.forward()
	turtle.digUp()
end

function tunnel(trunkLength,toothLength)
	local currentTrunkLength = 0
	while currentTrunkLength < trunkLength do
		--start the trunk tunnel
		for i=1,3 do
			if(currentTrunkLength < trunkLength) then
				trunkStep()
				currentTrunkLength = currentTrunkLength + 1
			end
		end

		--ensure the trunk length hasn't been exceeded. 
		if(currentTrunkLength <= trunkLength) then
			--turn to face the right wall, we should already be next to it
			turtle.turnRight()

			--excavate a comb "tooth"
			for i= 1,toothLength do
				combStep()
			end

			--back up to the main tunnel
			for i=1,toothLength do
				turtle.back()
			end

			--re-face the trunk tunnel
			turtle.turnLeft()
		end
	end

	--return to start position
	for i=1,currentTrunkLength do
		turtle.back()
	end

	print("Done. Tunnel is "..currentTrunkLength.." blocks in length")
end

tunnel(tonumber(arg[1]),tonumber(arg[2]))
