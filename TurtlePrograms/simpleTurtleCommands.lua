local arg = { ... }

--repeatedly attempt to call a function until it returns
function repeatAttempt(numAttempts,timeInterval,func)
    local counter = 0
    while (not func() and counter<numAttempts) do
        os.sleep(timeInterval)
    end
end

function isDigit(char)
    if(char == "0" or char == "1" or char == "2" or char == "3" or char == "4" or char == "5" or char == "6" or char == "7" or char == "8" or char == "9" or char == "0") then
        return true
    else
        return false
    end
end

function aggressiveMove(numTries,moveFunc,attackFunc)
    while (not moveFunc()) and (counter < numTries) do
        attackFunc()
    end
end

function interpret(input)
    for i=1,string.len(input) do
        local tmp = string.sub(input,i,i)

        --movement functions
        if(tmp == "f") then
            turtle.forward()
        elseif(tmp == "l") then
            turtle.turnLeft()
        elseif(tmp == "r") then
            turtle.turnRight()
        elseif(tmp == "b") then
            turtle.back()
        elseif(tmp == "d") then
            turtle.down()
        elseif(tmp == "u") then
            turtle.up()

        --passive ensured movement functions
        ---will wait until whatever is in front of them moves away

        elseif(tmp == "q") then
            repeatAttempt(20,0.5,turtle.forward)
        elseif(tmp == "e") then
            repeatAttempt(20,0.5,turtle.up)
        elseif(tmp == "c") then
            repeatAttempt(20,0.5,turtle.down)

        --aggressive ensured movement functions
        ---if movement fails it will try to remove obstacles
        elseif(tmp == "Q") then
            aggressiveMove(20,turtle.forward,turtle.attack)
        elseif(tmp == "E") then
            aggressiveMove(20,turtle.up,turtle.attackUp)
        elseif(tmp == "C") then
            aggressiveMove(20,turtle.down,turtle.attackDown)

        --dig functions
        elseif(tmp == "D") then
            turtle.digDown()
        elseif(tmp == "U") then
            turtle.digUp()
        elseif(tmp == "F") then
            turtle.dig()

        --placement functions
        elseif(tmp == "P") then
            turtle.place()
        elseif(tmp == "A") then
            turtle.placeUp()
        elseif(tmp == "B") then
            turtle.placeDown()

        --inventory managemnet
        elseif(isDigit(tmp)) then
            turtle.select(tonumber(tmp))
        elseif(tmp == "!") then
            turtle.select(11)
        elseif(tmp == "@") then
            turtle.select(12)
        elseif(tmp == "#") then
            turtle.select(13)
        elseif(tmp == "$") then
            turtle.select(14)
        elseif(tmp == "%") then
            turtle.select(15)
        elseif(tmp == "^") then
            turtle.select(16)
        end
    end
end

interpret(table.concat(arg))