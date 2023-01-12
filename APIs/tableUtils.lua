t = {}

function t.shallowCopy(orig)
	local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function t.deepCopy(orig)
	local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

--initialize a table with <numSlots> instances of <initVal>
function t.initTable(initVal,numSlots)
    local result = {}
    for i=1,numSlots do
        table.insert(initVal)
    end
end

--split a table into two, 
---left table runs until the index, 
---right table includes the index and the rest of the original table
function t.split(orig, index)
    r1 = {}
    r2 = {}
    for i=1,index do
        table.insert(r1,orig[i])
    end
    for i=index,#orig do
        table.insert(r2,orig[i])
    end

    return r1,r2
end

--attempt to convert numeric string members to numbers, leave other values as they are
function t.convertToNumbers(stringArgs)
    local legalChars = "0123456789"
    local numberArgs = {}
    for i=1,#stringArgs do
        local arg = stringArgs[i]
        local isNumber = true
        for j=1,#arg do
            local c = string.sub(arg,j,j)
            if(string.find(legalChars,c) == nil) then
                isNumber = false
                break
            end
        end
        if(isNumber) then
            numberArgs[i] = tonumber(arg)
        else
            numberArgs[i] = arg
        end
    end

    return numberArgs
end

return t