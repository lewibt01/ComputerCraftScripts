package.path = package.path..";C:\\GitRepositories\\ComputerCraftScripts\\APIs\\?.lua"
package.path = package.path..";C:\\GitRepositories\\ComputerCraftScripts\\Mocks\\?.lua"
package.path = package.path..";C:\\GitRepositories\\ComputerCraftScripts\\TurtlePrograms\\?.lua"

turtle = require("turtle")
turtle.getFuelLevel = function () return 10000 end
program = require("pillarMine")