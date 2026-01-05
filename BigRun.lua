local path = "BigRunPulse.components."
local BigRun = {
    Diagnostic = require(path .. "Diagnostic"),
    Window     = require(path .. "Window"),
    Input      = require(path .. "Input"),
    Engine2D   = require(path .. "Engine2D"),
    Physics    = require(path.. "Physics"),
}

-- Global Shortcuts (Aliases)
BigRun.spawn = BigRun.Engine2D.spawnFrame
BigRun.print = BigRun.Engine2D.print

return BigRun
