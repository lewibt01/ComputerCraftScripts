--designed to be a tester for turtle scripts

local t = {}

t.position = {0,0,0} --3d coordinates displaying current position
t.orientation = 0 --north,east,south,west

function t.forward() return true end
function t.back() return true end
function t.turnRight() return true end
function t.turnLeft() return true end
function t.up() return true end
function t.down() return true end
function t.dig() return true end
function t.digDown() return true end
function t.digUp() return true end
function t.place() return true end
function t.placeDown() return true end
function t.placeUp() return true end
function t.drop() return true end
function t.dropUp() return true end
function t.dropDown() return true end
function t.detect() return true end
function t.detectUp() return true end
function t.detectDown() return true end
function t.compare() return true end
function t.compareUp() return true end
function t.compareDown() return true end
function t.suck() return true end
function t.suckUp() return true end
function t.suckDown() return true end

function t.refuel() return true end
function t.getFuelLevel() return 100 end
function t.getFuelLimit() return 100000 end

function t.select() return true end
function t.getSelectedSlot() return 1 end

function t.equipLeft() return true end
function t.equipRight() return true end

function t.inspect() return true end
function t.inspectUp() return true end
function t.inspectDown() return true end


return t