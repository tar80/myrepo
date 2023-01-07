if not nyagos then
    print("This is a script for nyagos not lua.exe")
    os.exit()
end

local stats = function()
    local path = nyagos.getwd()
    repeat
        if nyagos.access(nyagos.pathjoin(path, ".git"), 0) then
            break
        end
        path = string.match(path, "^(.+)\\")
    until not path

    if path then
        local status = nyagos.eval("git status -s -b --porcelain>nul")
        local lines = {}

        for line in string.gmatch(status, "[^\n]+") do
            table.insert(lines, line)
        end

        local branch = string.sub(lines[1], 4)
        local stage, unstage = 0, 0

        for i = 2, #lines do
            if string.find(string.sub(lines[i], 1, 1), "[MADRC]") then
                stage = stage + 1
            end
            if string.find(string.sub(lines[i], 1, 1), "[%sU]") then
                unstage = unstage + 1
            end
        end

        return {branch, " +" .. stage .. " ~" .. unstage}
    else
        return nil
    end
end

local result = stats()

if result ~= nil then
    nyagos.exec(nyagos.env["PPX_DIR"] .. "\\pptrayw.exe -c *execute C,*string i,repoBranch=" .. result[1] .. "%%:*string i,repoStats=" .. result[2] .. "%%:*color back")
end
