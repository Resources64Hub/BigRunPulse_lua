local Diagnostic = {}

function Diagnostic.getFps() return love.timer.getFPS() end
function Diagnostic.getDelta() return love.timer.getDelta() end
function Diagnostic.getMemoryUsage() return collectgarbage("count") / 1024 end
function Diagnostic.getOS() return love.system.getOS() end

function Diagnostic.draw(x, y)
    love.graphics.print(string.format("FPS: %d | RAM: %.2fMB | OS: %s", 
        Diagnostic.getFps(), Diagnostic.getMemoryUsage(), Diagnostic.getOS()), x, y, 0, 1, 0)
end

return Diagnostic
