local Engine2D = { entities = {} }
Engine2D.__index = Engine2D

function Engine2D.spawnFrame(x, y, size, shape)
    local self = setmetatable({
        x = x or 0, y = y or 0, size = size or 50,
        shape = shape or "rect", rotation = 0,
        color = {1, 1, 1, 1}, active = true
    }, Engine2D)
    table.insert(Engine2D.entities, self)
    return self
end

function Engine2D.spawnFrame(x, y, size, shape)
    local self = setmetatable({
        x = x or 0, y = y or 0, size = size or 50,
        shape = shape or "rect", rotation = 0,
        color = {1, 1, 1, 1}, active = true,
        vx = 0, vy = 0,
        gx = 0, gy = 0,
        drag = 0,    
        mass = 1     
    }, Engine2D)
    table.insert(Engine2D.entities, self)
    return self
end

function Engine2D.updateAll(dt)
    for i = #Engine2D.entities, 1, -1 do
        local e = Engine2D.entities[i]
        if not e.active then
            table.remove(Engine2D.entities, i)
        else
            -- Применяем сопротивление (замедление скорости)
            if e.drag > 0 then
                -- Умножаем скорость на фактор меньше единицы
                local friction = math.max(0, 1 - e.drag * dt)
                e.vx = e.vx * friction
                e.vy = e.vy * friction
            end

            e.vx = e.vx + e.gx * dt
            e.vy = e.vy + e.gy * dt
            e.x = e.x + e.vx * dt
            e.y = e.y + e.vy * dt
        end
    end
end

function Engine2D.drawAll()
    for _, e in ipairs(Engine2D.entities) do
        e:draw()
    end
end

-- [ ENTITY METHODS ]
function Engine2D:pos(x, y) self.x, self.y = x or self.x, y or self.y; return self end
function Engine2D:rotate(angle) self.rotation = self.rotation + (angle or 0); return self end
function Engine2D:setColor(r, g, b, a) self.color = {r or 1, g or 1, b or 1, a or 1}; return self end
function Engine2D:scale(factor) self.size = (self.size or 50) * (factor or 1); return self end
function Engine2D:destroy() self.active = false; return self end

function Engine2D:collidesWith(other)
    if not other or not self.active or not other.active then return false end
    local s, o = (self.size or 50)/2, (other.size or 50)/2
    return self.x+s > other.x-o and self.x-s < other.x+o and self.y+s > other.y-o and self.y-s < other.y+o
end

function Engine2D.print(text, x, y, r, g, b, a)
    love.graphics.setColor(r or 1, g or 1, b or 1, a or 1)
    love.graphics.print(text or "", x or 0, y or 0)
end


function Engine2D:draw()
    if not self.active then return end
    love.graphics.push()
    love.graphics.translate(self.x, self.y)
    love.graphics.rotate(self.rotation)
    love.graphics.setColor(self.color)
    local offset = -(self.size or 50) / 2
    if self.shape == "circle" then love.graphics.circle("fill", 0, 0, self.size/2)
    else love.graphics.rectangle("fill", offset, offset, self.size, self.size) end
    love.graphics.pop()
end

-- Aliases
Engine2D.new = Engine2D.spawnFrame

return Engine2D
