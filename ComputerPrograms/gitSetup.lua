--Package everything into one file so we don't have to rely on imports.

--[[BEGIN STRINGUTILS API]]
function splitStr(inputStr,delim)
    local pieces = {}
    for str in string.gmatch(inputStr,"([^"..delim.."]+)") do
        table.insert(pieces,str)
    end
    return pieces
end

--[[BEGIN FILEUTILS API]]
function exists(path)
    return fs.exists(path)
end

function writeString(data,path)
    local file = io.open(path,"w")
    file:write(tostring(data))
    file:close()
end

function createFile(path)
    local pieces = splitStr(path,"/")
    local appended = ""
    for i=1,#pieces-1 do
        appended = appended..pieces[i].."/" 
    end
    if not (fs.exists(appended)) then
        fs.makeDir(appended)
    end
    writeString("",path)
end

function readString(path)
    local file = io.open(path,"r")
    data = file:read("*a")
    file:close()
    return data
end

--[[BEGIN GITHUB API]]
local baseURL = "https://raw.githubusercontent.com/lewibt01/ComputerCraftScripts/master/"

function requestFile(name)
    local handle = http.get(baseURL..name)
    local result = ""

    if(handle) then
        result = handle.readAll()
    end

    return result
end

function pull(name,dest)
    local data = requestFile(name)
    createFile(dest)
    local file = io.open(dest,"w")
    file:write(data)
    file:close()
end

--[[BEGIN PROPERTIES API]]
local props = {}
local propFilePath = "/usr/apis.prop"

function getAll()
    local propFile = readString(propFilePath)
    
    --make sure the property file wasn't empty
    if(propFile == "") then return {} end

    local lines = splitStr(propFile,"\n")

    local propTable = {}
    for i=1,#lines do
        local pair = splitStr(lines[i],":")
        propTable[pair[1]] = pair[2]
    end
    return propTable
end

--[[BEGIN EXECUTION]]
--get programs file
print("Retrieving programs...")
pull("PropertyFiles/programs.prop",propFilePath)

--programs will be in the format <git url>:<destination path>
local programs = getAll()
if(exists(propFilePath)) then
    print(#programs)
    --pull down all the programs into their respective folders, overwrite existing files
    for k,v in pairs(programs) do
        print("Downloading "..k.." to "..v)
        pull(k,v)
    end

    print("Rebooting")
    os.sleep(2)
    os.reboot()
else
    print(propFilePath.." is missing.") 
end