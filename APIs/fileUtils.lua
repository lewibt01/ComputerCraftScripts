package.path = package.path..";/api/?.lua"

local s = require("stringUtils")

local fileOps = {}

function fileOps.exists(path)
    return fs.exists(path)
end

function fileOps.writeString(data,path)
    local file = io.open(path,"w")
    file:write(tostring(data))
    file:close()
end

function fileOps.readString(path)
    local file = io.open(path,"r")
    data = file:read("*a")
    file:close()
    return data
end

function fileOps.appendString(data,path)
    local file = io.open(path,"a")
    file:write(tostring(data))
    file:close()
end

function fileOps.createFile(path)
    local pieces = s.splitStr(path,"/")
    local appended = ""
    for i=1,#pieces-1 do
        appended = appended..pieces[i].."/" 
    end
    if not (fs.exists(appended)) then
        fs.makeDir(appended)
    end
    fileOps.writeString("",path)
end

function fileOps.listFiles(path)
    local objects = fs.list(path)
    local result = {}
    for el in table.unpack(objects) do
        if(not fs.isDirectory(el)) then
            table.insert(result,el)
        end
    end
    return result
end

function fileOps.listFolders(path)
    local objects = fs.list(path)
    local result = {}
    for el in table.unpack(objects) do
        if(fs.isDir(el)) then
            table.insert(result,el)
        end
    end
    return result
end 

return fileOps