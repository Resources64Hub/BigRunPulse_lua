# 🚀 BigRunPulse Engine (v2.2)

**BigRunPulse** is a lightweight, modular 2D game engine framework built on top of [LÖVE](https://love2d.org). It is designed for rapid prototyping of physical simulations and games, featuring a component-based architecture for physics, rendering, and input handling.

---

## 📋 Table of Contents
- [Installation](#-installation)
- [BigRun (Entry Point)](#-bigrun-entry-point)
- [Engine2D (Core & Rendering)](#-engine2d-core--rendering)
- [Physics (Dynamics & Forces)](#-physics-dynamics--forces)
- [Window (Display Management)](#-window-display-management)
- [Input (User Interaction)](#-input-user-interaction)
- [Diagnostic (Profiling)](#-diagnostic-profiling)
- [Usage Example](#-usage-example)

---

## 🛠 Installation
Place the `BigRunPulse` folder into your project directory and require the main module in your `main.lua`:

```lua
local brp = require("BigRunPulse.BigRun")
```

---

## 📦 BigRun (Entry Point)

The central module that aliases all sub-components for cleaner syntax and easier access.

| Alias | Original Reference | 	Description |
| --- | --- | --- |
| `brp.spawn` | `Engine2D.spawnFrame` | Spawns a new entity into the scene. |
| `brp.print` | `Engine2D.print` |	Renders text to the screen using graphics. |

---

## 🎮 Engine2D (Core & Rendering)

Handles the lifecycle, transformation, and rendering of game entities.

**Global Methods**

- `Engine2D.spawnFrame(x, y, size, shape)`: Creates a tracked entity. Shapes available: `"rect"`, `"circle"`
- `Engine2D.updateAll(dt)`: Processes movement, applies drag (friction), updates velocities via gravity, and garbage-collects inactive entities.
- `Engine2D.drawAll()`: Renders all active entities based on their shape, color, and rotation.

**Entity Instance Methods**

  Supports **Fluent API** (method chaining):
  ```lua
  entity:pos(100, 100):setColor(1, 0, 0):scale(1.5)
  ```
  - `:pos(x, y)` — Sets absolute position.
  - `:rotate(angle)` — Increments the rotation angle.
  - `:setColor(r, g, b, a)` — Sets the drawing color (values from 0.0 to 1.0).
  - `:scale(factor)` — Multiplies the current size by the factor.
  - `:destroy()` — Marks the entity as inactive (it will be removed in the next update cycle).
  - `:collidesWith(other)` — Returns true if AABB bounding boxes overlap.

---

## 🍎 Physics (Dynamics & Forces)

Extends entities with Newtonian physics, collision resolution, and environmental forces.

**Kinematics Methods**

- `Physics:giveGravity(vector, strength)` — Sets constant acceleration (e.g., gravity vector).
- `Physics:giveVelocity(vector, useMass)` — Applies an instant impulse. If useMass is true, force is divided by entity mass $(v=v+f/m\)$.
- `Physics:setPhysics(drag, mass)` — Configures air resistance (drag) and weight (mass).
- `Physics:setVelocity(x, y)` — Directly overrides the current velocity vectors.
- `Physics:stop()` — Instantly cancels all movement (sets velocity to 0).

**Global Physics Logic**

- `Physics.resolveCollisions(entities)` — Static method for elastic collision response. Handles momentum transfer and positional correction (anti-stuck logic).
- `Physics.distortionGravity(entity, target, strength)` — Applies a radial pull/push force toward a target point (e.g., a magnet or black hole). Frame-rate independent via dt.

---

## 🖥 Window (Display Management)

Wraps LÖVE windowing functions for environment control.

- `Window.setup(width, height, settings)` — Initializes the window. Forced to desktop fullscreen type for better scaling.
- `Window.setTitle(title)` — Sets the OS window title.
- `Window.setBackground(r, g, b)` — Clears the screen with a specific background color.
- `Window.setVSync(enable)` — Toggles Vertical Sync (1 for ON, 0 for OFF).
- `Window.getArea()` — Returns the current width and height of the window.
- `Window.toggleFullscreen()` — Switches between windowed and fullscreen modes.
- `Window.exit()` — Properly quits the application.

---

## ⌨️ Input (User Interaction)

Simplified polling for hardware input states.

- `Input.getMousePos()` — Returns the current x, y mouse coordinates.
- `Input.isKeyDown(key)` — Returns true if the specific key is held (e.g., "w", "space", "escape").
- `Input.isMouseDown(button)` — Returns true if the mouse button (1=Left, 2=Right) is held.

---

## 📊 Diagnostic (Profiling)

Real-time performance monitoring tools for debugging.

- `Diagnostic.getFps()` — Returns current Frames Per Second.
- `Diagnostic.getMemoryUsage()` — Returns Lua RAM usage in Megabytes (MB).
- `Diagnostic.getOS()` — Returns the name of the operating system.
- `Diagnostic.draw(x, y)` — Renders a debug overlay string: `FPS | RAM | OS`.

---

## 💡 Usage Example

```lua
local brp = require("BigRunPulse.BigRun")

function love.load()
    brp.Window.setup(1280, 720, {resizable = true})
    brp.Window.setTitle("BigRunPulse Physics Test")
end

function love.update(dt)
    -- Spawn a ball at mouse position on click
    if brp.Input.isMouseDown(1) then
        local mx, my = brp.Input.getMousePos()
        local ball = brp.spawn(mx, my, 25, "circle")
        
        -- Initialize physics for the new entity
        brp.Physics.setPhysics(ball, 0.5, 2) -- (Drag, Mass)
        brp.Physics.giveGravity(ball, {x = 0, y = 9.8}, 50)
    end

    -- Run Collision Resolution
    brp.Physics.resolveCollisions(brp.Engine2D.entities)
    
    -- Update all positions and life cycles
    brp.Engine2D.updateAll(dt)
end

function love.draw()
    brp.Window.setBackground(0.05, 0.05, 0.1)
    
    -- Draw all objects
    brp.Engine2D.drawAll()
    
    -- Show Debug Info
    brp.Diagnostic.draw(10, 10)
    brp.print("Left Click to spawn physics objects", 10, 40)
end

```

---

*Documentation BigRunPulse Engine — January 2026 Alpha.*
