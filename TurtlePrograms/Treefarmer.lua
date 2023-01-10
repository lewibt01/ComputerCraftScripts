--this is designed for spruce trees, they grow the straightest
local t = turtle
local treesHarvested = 0

--make sure a log block is in slot 1, and saplings in slot 2
function checkGrowth()
    local prevSlot = t.getSelectedSlot()

    t.select(1)
    local result = t.compare()

    t.select(prevSlot)
    return result
end

function replant()
    local prevSlot = t.getSelectedSlot()
    t.select(2)
    t.place()
    t.select(prevSlot)
end

function harvest()
    while(t.compare() or turtle.detectUp()) do
        t.dig()
        t.digUp()
        t.up()
    end

    for i=1,10 do
        t.down()
    end

    treesHarvested = treesHarvested + 1

    print("Trees Harvested: "..treesHarvested)
end

function dropOff()
    for i=3,16 do
        t.select(i)
        t.dropDown()
    end

    --transfer 1 log to keep to slot 16, drop the rest
    t.select(1)
    t.transferTo(16,1)
    t.dropDown()

    --transfer the saved one back
    t.select(16)
    t.transferTo(1)
    t.select(1)
end

function main()
    print("Starting treefarm...")
    while true do
        if(checkGrowth()) then
            harvest()
            replant()
            dropOff()
        else
            os.sleep(10)
        end
    end
end

t.select(1)
main()