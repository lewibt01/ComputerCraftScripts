local arg = {...}

function digStep()
	turtle.dig()
	turtle.forward()
	turtle.digUp()
	turtle.up()
	turtle.digUp()
end