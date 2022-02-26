if not nyagos then
    print("This is a script for nyagos not lua.exe")
    os.exit()
end

local opt = arg[1] == nil and "" or arg[1]
local sb = string.match(nyagos.eval("git stash list | peco"), "^stash@{%d*}")

if sb == "" then
    return nil
end

nyagos.exec("git stash apply "..opt.." "..sb)
