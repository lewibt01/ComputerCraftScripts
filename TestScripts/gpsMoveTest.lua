package.path = package.path..";C:\\GitRepositories\\ComputerCraftScripts\\APIs\\?.lua"
package.path = package.path..";C:\\GitRepositories\\ComputerCraftScripts\\Mocks\\?.lua"

gpsMove = require("gpsMove")
turtle = require("turtle")

function printInfo()
	io.write("# ")
	gpsMove.printPosition()
	io.write("# ")
	gpsMove.printOrientation()
end

function test(x,y,z)
	print("#######################")
	print("#	"..gpsMove.positionStr().." -> {"..x..","..y..","..z.."}")
	gpsMove.moveTo(x,y,z)
	io.write("#	")
	gpsMove.printOrientation()
end

gpsMove.reZero()
--printInfo()

test(0,1,3)
test(3,1,0)
test(8,2,4)
test(4,1,2)
test(0,0,0)
