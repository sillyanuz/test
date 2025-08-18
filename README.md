# Fly Script - V3 Method Camera Rotation Fix

## Problem Fixed
The V3 method in the fly script was not properly rotating the character to follow camera direction, making flying feel unnatural compared to the V4 method.

## Solution Implemented
Updated the V3 method's BodyGyro logic to follow camera rotation using the same approach as the V4 method:

```lua
-- BEFORE (broken):
bodyGyro.CFrame = rootPart.CFrame  -- Static rotation, doesn't follow camera

-- AFTER (fixed):
local lookDirection = camera.CFrame.LookVector
bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
```

## Key Changes
1. **Added camera-following rotation** to V3 method using `workspace.CurrentCamera.CFrame.LookVector`
2. **Implemented smooth rotation** that matches the camera's look vector using `CFrame.lookAt()`
3. **Maintained all existing V3 features**:
   - Speed control via `getgenv().flySpeed`
   - Up/down movement with Space/LeftShift keys
   - TPWalk movement characteristics
   - WASD movement based on camera direction

## Technical Details
- **File**: `fly.lua`
- **Function modified**: `startFlyV3()`
- **Fix location**: Line 75-78 in the RunService.Heartbeat connection
- **Approach**: Uses same camera rotation calculation as V4 method

## Usage
```lua
-- Load the script in Roblox
loadstring(game:HttpGet("path/to/fly.lua"))()

-- Use V3 method (now with camera rotation)
getgenv().useV3Method = true
-- Press F to start flying

-- Use V4 method (reference implementation)
getgenv().useV3Method = false
-- Press F to start flying

-- Adjust speed
getgenv().flySpeed = 20
```

## Controls
- **F**: Toggle flying on/off
- **WASD**: Move forward/backward/left/right (relative to camera)
- **Space**: Move up
- **Left Shift**: Move down

## Result
Both V3 and V4 methods now provide smooth camera-following rotation while maintaining their unique movement characteristics:
- **V3**: TPWalk style with camera rotation
- **V4**: Standard flying with camera rotation

The character now properly rotates to face the direction the camera is looking in both methods, providing a consistent and intuitive flying experience.