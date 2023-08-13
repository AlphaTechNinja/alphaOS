--the terminal object WARNING THIS IS A CORE FILE
local term = {}
local graphics = require("graphics")
term._x,term._y = 1,1
term._blink = false
term._blinkCycle = 0
term._blinkdeadline = 0
function term.write(str)
    local leny,lenx = graphics.write(sterm._x,term._y,str,true)
    term._y = term._y + leny - 1
    term._x = lenx
end
function term.newLine()
    term._y,termn._x = term._y + 1,1
end
function term.feedLine()
    term._y = term._y + 1
end
function term.beep(n)
    computer.beep(n * 10,0.5)
end
function term.print(str)
    term.write(str)
    term.newLine()
end
--cursor options
function term.setCursor(x,y)
    term._x,term._y = x,y 
end
function term.getCursor()
    return term._x,term._y
end
--blink
function term.cycle()
    if term.blink and computer.uptime() > term._blinkdeadline then
        term._blinkdeadline = computer.uptime() + 1
        term._blinkCycle = 0 - term._blinkCycle
        --flip bg and fg of charactor
        local c,bg,fg = graphics.gpu.get(term.getCursor())
        graphics.gpu.setBackground(bg)
        graphics.gpu.setForeground(fg)
        graphics.gpu.set(term._x,term._y,c)
    end
end
return term
