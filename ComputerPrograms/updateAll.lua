g = require("github")
p = require("properties")
f = require("fileUtils")

local oldPath = p.propFilePath


p.propFilePath = "/usr/programs.prop"

--programs will be in the format <git url>:<destination path>
local programs = p.getAll()
if(f.exists(p.propFilePath)) then
    print(#programs)
    --pull down all the programs into their respective folders, overwrite existing files
    for k,v in pairs(programs) do
        print("Downloading "..k.." to "..v)
        g.pull(k,v)
    end

    print("Rebooting")
    os.sleep(2)
    os.reboot()
else
    print(p.propFilePath.." is missing.")
end

--reset the api path
p.propFilePath = oldPath