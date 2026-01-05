local Physics = { entities = {} }
Physics.__index = Physics
-- [ PHYSICS METHODS ]

-- Sets a constant acceleration (gravity). vector: {x, y}, strength: multiplier
function Physics:giveGravity(vector, strength)
    local s = strength or 1
    self.gx = (vector.x or 0) * s
    self.gy = (vector.y or 0) * s
    return self
end

-- Completely removes gravity/acceleration forces
function Physics:noGravity()
    self.gx, self.gy = 0, 0
    return self
end

-- Applies an instantaneous impulse (velocity change)
-- If useMass is true, the force is divided by the entity's mass
function Physics:giveVelocity(vector, useMass)
    local m = (useMass == false) and 1 or (self.mass or 1)
    if vector.x then self.vx = self.vx + (vector.x / m) end
    if vector.y then self.vy = self.vy + (vector.y / m) end
    return self
end

-- Sets the physical properties of the entity
-- drag: resistance to movement (slows down over time)
-- mass: determines how much force is needed to move the entity
function Physics:setPhysics(drag, mass)
    self.drag = drag or self.drag
    self.mass = mass or self.mass
    return self
end

-- Instantly stops all movement by zeroing velocity
function Physics:stop()
    self.vx, self.vy = 0, 0
    return self
end

-- Directly sets the velocity vectors, ignoring mass and current speed
function Physics:setVelocity(x, y)
    self.vx = x or self.vx
    self.vy = y or self.vy
    return self
end

-- Physics resolution for BigRunPulse
-- Physics resolution with proper momentum transfer
function Physics.resolveCollisions(entities)
    for i = 1, #entities do
        for j = i + 1, #entities do
            local a = entities[i]
            local b = entities[j]

            if a.active and b.active and a:collidesWith(b) then
                -- 1. Calculate normal vector (direction of collision)
                local dx = b.x - a.x
                local dy = b.y - a.y
                local distance = math.sqrt(dx*dx + dy*dy)
                if distance == 0 then distance = 0.1 end -- Prevent division by zero
                
                local nx = dx / distance -- Normal X
                local ny = dy / distance -- Normal Y

                -- 2. Relative velocity
                local rvx = b.vx - a.vx
                local rvy = b.vy - a.vy

                -- 3. Velocity along the normal (dot product)
                local velAlongNormal = rvx * nx + rvy * ny

                -- Do not resolve if velocities are separating
                if velAlongNormal < 0 then
                    -- 4. Calculate Impulse strength
                    local restitution = 0.8 -- Bounciness (0.1 to 1.0)
                    local j_impulse = -(1 + restitution) * velAlongNormal
                    j_impulse = j_impulse / (1/a.mass + 1/b.mass)

                    -- 5. Apply impulse to each body based on mass
                    local impulseX = j_impulse * nx
                    local impulseY = j_impulse * ny

                    a.vx = a.vx - (1/a.mass) * impulseX
                    a.vy = a.vy - (1/a.mass) * impulseY
                    b.vx = b.vx + (1/b.mass) * impulseX
                    b.vy = b.vy + (1/b.mass) * impulseY
                end

                -- 6. Anti-stuck (Positional Correction)
                -- Prevents balls from merging into each other
                local overlap = ( (a.size + b.size)/2 ) - distance
                if overlap > 0 then
                    local percent = 0.5 -- overlap relaxation
                    local slop = 0.01   -- penetration allowance
                    local correction = math.max(overlap - slop, 0) / (1/a.mass + 1/b.mass) * percent
                    local cx, cy = correction * nx, correction * ny
                    a.x = a.x - (1/a.mass) * cx
                    a.y = a.y - (1/a.mass) * cy
                    b.x = b.x + (1/b.mass) * cx
                    b.y = b.y + (1/b.mass) * cy
                end
            end
        end
    end
end

-- Physics.lua

-- Applies a pull force towards a specific point (like a black hole or magnet)
-- target: {x, y} table, usually mouse position
-- strength: how powerful the pull is
function Physics.distortionGravity(entity, target, strength)
    if not entity.active then return end
    
    local s = strength or 100
    
    -- Calculate vector to target
    local dx = target.x - entity.x
    local dy = target.y - entity.y
    local distance = math.sqrt(dx*dx + dy*dy)
    
    -- Avoid division by zero and extreme forces when very close
    if distance > 5 then
        -- Normalize and apply force
        -- We divide by distance to make the pull smoother or 
        -- remove the division to make it stronger at a distance
        local forceX = (dx / distance) * s
        local forceY = (dy / distance) * s
        
        -- Apply as continuous acceleration (gravity-like)
        entity.vx = entity.vx + forceX * love.timer.getDelta()
        entity.vy = entity.vy + forceY * love.timer.getDelta()
    end
end




return Physics