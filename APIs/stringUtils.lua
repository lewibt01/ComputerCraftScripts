package.path = package.path..";/api/?.lua"

local addons = {}

function addons.splitStr(inputStr,delim)
    local pieces = {}
    for str in string.gmatch(inputStr,"([^"..delim.."]+)") do
        table.insert(pieces,str)
    end
    return pieces
end

function addons.isDigit(char)
    if(char=="0") then return true
    elseif(char=="1") then return true
    elseif(char=="2") then return true
    elseif(char=="3") then return true
    elseif(char=="4") then return true
    elseif(char=="5") then return true
    elseif(char=="6") then return true
    elseif(char=="7") then return true
    elseif(char=="8") then return true
    elseif(char=="9") then return true
    else 
        return false
    end
end

function addons.isBoolean(inputStr)
    if(inputStr == "true") then return true
    elseif(inputStr == "false") then return true
    else
        return false
    end
end

return addons