local reactorName = "draconic_reactor_0"
-- local monitorName = "monitor_0"
local inGateName = "flow_gate_0"
local outGateName = "flow_gate_1"

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
    monitor.setCursorPos(x,y)
    monitor.write(name)
    monitor.setCursorPos(x,y+1)

    -- get percentage...
    local width,height = monitor.getSize()
    local percent = current / max
    local charWidth = width
    local numChars = math.ceil(percent * charWidth)
    monitor.write(string.rep("|",numChars))
end

--[[Reactor Handling]]
function getEnergySaturation(reactor)
    local info = reactor.getReactorInfo()
    return info.energySaturation
end

--[[MAIN]]--

local modem = getWiredModem()
local mon = getMonitor(modem)

--wrap reactor
local reactor = peripheral.wrap(reactorName)
local outGate = peripheral.wrap(outGateName)
local inGate = peripheral.wrap(inGateName)

-- Configure the monitor
mon.setTextScale(1.5)
mon.setBackgroundColor(colors.black)
mon.setTextColor(colors.white)
mon.clear()


printHorizontalBar(mon,1,1,"Energy Saturation",1000000000,getEnergySaturation(reactor))
