local Window = {}

function Window.setup(width, height, settings)
    local flags = settings or {}
    flags.resizable = flags.resizable or false
    flags.vsync = flags.vsync or 1
    flags.fullscreentype = "desktop" -- Always use desktop for better scaling
    love.window.setMode(width or 800, height or 600, flags)
end

function Window.setTitle(title)
    love.window.setTitle(title or "Big Run Pulse Engine")
end

function Window.toggleFullscreen()
    love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
end

-- Восстановленный VSync
function Window.setVSync(enable)
    local w, h, flags = love.window.getMode()
    flags.vsync = enable and 1 or 0
    love.window.setMode(w, h, flags)
end

function Window.setBackground(r, g, b) love.graphics.clear(r or 0, g or 0, b or 0) end
function Window.getArea() return love.graphics.getWidth(), love.graphics.getHeight() end
function Window.exit() love.event.quit() end

return Window
