local arg = {...}
local t = turtle

for i=1,arg[1] do
	t.dig()
	t.forward()
	t.digUp()
end

t.turnLeft()
t.turnLeft()

for i=1,arg[1] do
	t.forward()
end

--dump found resources
t.turnRight()
t.select(16)
t.place()

for i=1,15 do
	t.select(i)
	t.drop()
end

--reorient the turtle
t.turnRight()
