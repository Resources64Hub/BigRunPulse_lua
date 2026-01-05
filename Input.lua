local Input = {}

function Input.getMousePos() return love.mouse.getX(), love.mouse.getY() end
function Input.isKeyDown(key) return love.keyboard.isDown(key or "") end
function Input.isMouseDown(button) return love.mouse.isDown(button or 1) end

-- Aliases for compatibility
Input.isDown = Input.isKeyDown

return Input
