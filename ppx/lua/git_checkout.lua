if not nyagos then
    print("This is a script for nyagos not lua.exe")
    os.exit()
end

-- if #arg < 2 then
    -- nyagos.msgbox("Error: Not enough arguments", "nyagos")
    -- os.exit()
-- end

local sb = nyagos.eval("git branch | peco")
if sb == "" then
    return nil
end

local gc = nyagos.exec("git checkout -q "..sb)
if gc == 0 then
    function Get_si()
        local u = ""
        if sb ~= "" then
            -- u = "*execute C,*string i,gitBranch"..arg[2].."=" .. sb
            u = "*execute C,*string i,uBranch=" .. sb
        end
        return u
    end

    local si = Get_si()
    nyagos.exec(arg[1] .. "PPBW.EXE -c " .. si)

    os.exit()
else
    nyagos.exec(arg[1] .. "PPBW.EXE -c *execute C,*linemessage error: git checkout Aborting")
end

