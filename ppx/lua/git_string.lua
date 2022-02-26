if not nyagos then
    print("This is a script for nyagos not lua.exe")
    os.exit()
end

if #arg < 2 then
    nyagos.msgbox("Error: Not enough arguments", "nyagos")
    os.exit()
end

function branch()
    return nyagos.eval("git branch | peco")
end

function commit()
    return string.match(
        nyagos.eval('git log --all --date=short --format="%h %ad *%s%d" -100 | peco'),
        "^[0-9a-zA-Z]*"
    )
end

function stash()
    return string.match(nyagos.eval("git stash list | peco"), "^stash@{%d+}")
end

local execute_cmd = {
    branch = branch,
    commit = commit,
    stash = stash
}

local res = execute_cmd[arg[2]]()

nyagos.exec(arg[1] .. "PPBW.EXE -c *execute C,*string i,git_string=" .. res)

