cmd = {}

function cmd.translate(input,...)
    -- '...' denotes a special variable called 'arg', it stores an unknown number of arguments
    local arg = {...}

    local c = {} --commands lookup table, in lieu of a switch statement
    --robot api functions

    c["craft"] = turtle.craft

    c["forward"] = turtle.forward
    c["back"] = turtle.back
    c["up"] = turtle.up
    c["down"] = turtle.down
    c["turnLeft"] = turtle.turnLeft
    c["turnRight"] = turtle.turnRight

    c["dig"] = turtle.dig
    c["digUp"] = turtle.digUp
    c["digDown"] = turtle.digDown

    c["place"] = turtle.place
    c["placeUp"] = turtle.placeUp
    c["placeDown"] = turtle.placeDown

    c["drop"] = turtle.drop
    c["dropUp"] = turtle.dropUp
    c["dropDown"] = turtle.dropDown

    c["select"] = turtle.select
    c["selectUp"] = turtle.getItemCount
    c["selectDown"] = turtle.getItemSpace

    c["detect"] = turtle.detect
    c["detectUp"] = turtle.detectUp
    c["detectDown"] = turtle.detectDown

    c["compare"] = turtle.compare
    c["compareUp"] = turtle.compareUp
    c["compareDown"] = turtle.compareDown

    c["attack"] = turtle.attack
    c["attackUp"] = turtle.attackUp
    c["attackDown"] = turtle.attackDown

    c["suck"] = turtle.suck
    c["suckUp"] = turtle.suckUp
    c["suckDown"] = turtle.suckDown

    c["up"] = turtle.getFuelLevel
    c["refuel"] = turtle.refuel
    c["compareTo"] = turtle.compareTo

    c["getSelectedSlot"] = turtle.getSelectedSlot
    c["getFuelLimit"] = turtle.getFuelLimit
    c["equipLeft"] = turtle.equipLeft
    c["equipRight"] = turtle.equipRight

    c["inspect"] = turtle.inspect
    c["inspectUp"] = turtle.inspectUp
    c["inspectDown"] = turtle.inspectDown

    c["getItemDetail"] = turtle.getItemDetail


    
    if c[input] == nil then
        return false
    end
    if(arg ~= nil) then
        for k,v in pairs(arg) do print(k..":"..v) end
        if(#arg > 0) then
            return c[input](table.unpack(arg))
        else
            return c[input]()
        end
    else
        return c[input]()
    end
end

return cmd