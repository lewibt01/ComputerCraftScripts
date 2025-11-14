local reactorName = "draconic_reactor_0"
-- local monitorName = "monitor_0"
local inGateName = "flow_gate_0"
local outGateName = "flow_gate_1"

function round(n, digits)
    local mult = 10^(digits or 0)
    return math.floor(n * mult + 0.5) / mult
end

function getWiredModem()
    -- Find the wired modem
    local modem = peripheral.find("modem")

    if not modem then
        error("No wired modem found!")
    end

    return modem
end

function getMonitor(modem)
    -- Get a list of connected peripherals
    local peripherals = modem.getNamesRemote()

    local monitorName = nil
    for _, name in ipairs(peripherals) do
        if peripheral.getType(name) == "monitor" then
            monitorName = name
            break
        end
    end

    if not monitorName then
        error("No remote monitor found on the wired network!")
    end

    return peripheral.wrap(monitorName)
end


--[[Monitor Printing]]
function printHorizontalBar(monitor,x,y,name,max,current)
    local width,height = monitor.getSize()
    -- get percentage...
    local percent = current / max
    local charWidth = width
    local numChars = math.ceil(percent * charWidth)

    monitor.setCursorPos(x,y)
    monitor.write(name.." ("..round(percent*100,2).."%)")
    monitor.setCursorPos(x,y+1)
    monitor.write(string.rep("|",numChars))
end

function printValue(monitor,x,y,name,value)
    monitor.setCursorPos(x,y)
    monitor.write(name..":"..value)
end

function draw(monitor,reactor,inGate,outGate)
    local info = reactor.getReactorInfo()

    --[[
        energySaturation,
        failSafe,
        fieldDrainRate,
        fieldStrength,
        fuelConversion,
        fuelConversionRate,
        generationRate,
        maxEnergySaturation,
        maxFieldStrength,
        maxFuelConversion,
        status,
        temperature
    ]]
    printHorizontalBar(monitor,1,1,"Energy Saturation",info.maxEnergySaturation,info.energySaturation)
    printHorizontalBar(monitor,1,3,"Field Strength",info.maxFieldStrength,info.fieldStrength)
    printHorizontalBar(monitor,1,5,"Fuel Conversion",info.maxFuelConversion,info.fuelConversion)
    printHorizontalBar(monitor,1,7,"Temperature",10000,info.temperature)
    printValue(monitor,1,9,"Field Drain Rate",info.fieldDrainRate)
    printValue(monitor,1,10,"Fuel Conversion Rate",info.fuelConversionRate)
    printValue(monitor,1,11,"Generation Rate",info.generationRate)
end

--[[Reactor Handling]]


--[[MAIN]]--

local modem = getWiredModem()
local mon = getMonitor(modem)

--wrap reactor
local reactor = peripheral.wrap(reactorName)
local outGate = peripheral.wrap(outGateName)
local inGate = peripheral.wrap(inGateName)

-- Configure the monitor
mon.setTextScale(1.3)
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.white)
mon.clear()

draw(mon,reactor,inGate,outGate)
