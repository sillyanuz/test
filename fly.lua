-- Fly Script with V3 and V4 Methods
-- V3 method uses tpwalk functionality
-- V4 method uses standard flying with proper camera rotation

-- Configuration
getgenv().useV3Method = getgenv().useV3Method or false
getgenv().flySpeed = getgenv().flySpeed or 16
getgenv().isFlying = false

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables for fly system
local bodyVelocity, bodyGyro
local connection
local keys = {}

-- V3 Method: TPWalk with camera rotation (FIXED)
function startFlyV3()
    if getgenv().isFlying then return end
    getgenv().isFlying = true
    
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyGyro for rotation (FIXED - now follows camera)
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    -- FIXED: This now uses camera direction for proper rotation
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart
    
    -- Movement loop for V3 (tpwalk style)
    connection = RunService.Heartbeat:Connect(function()
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        -- Calculate movement based on input
        if keys.W then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if keys.S then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if keys.A then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if keys.D then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if keys.Space then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if keys.LeftShift then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        -- Apply movement with speed
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * getgenv().flySpeed
        end
        bodyVelocity.Velocity = moveVector
        
        -- FIX: Update BodyGyro to follow camera direction like V4 method
        -- Use camera's look vector to properly rotate character with camera movement
        local lookDirection = camera.CFrame.LookVector
        bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
    end)
end

-- V4 Method: Standard flying with proper camera rotation (working correctly)
function startFlyV4()
    if getgenv().isFlying then return end
    getgenv().isFlying = true
    
    -- Create BodyVelocity for movement
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Create BodyGyro for rotation (WORKING - follows camera)
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.P = 3000
    bodyGyro.D = 500
    bodyGyro.Parent = rootPart
    
    -- Movement loop for V4
    connection = RunService.Heartbeat:Connect(function()
        local camera = workspace.CurrentCamera
        local moveVector = Vector3.new(0, 0, 0)
        
        -- Calculate movement based on input
        if keys.W then
            moveVector = moveVector + camera.CFrame.LookVector
        end
        if keys.S then
            moveVector = moveVector - camera.CFrame.LookVector
        end
        if keys.A then
            moveVector = moveVector - camera.CFrame.RightVector
        end
        if keys.D then
            moveVector = moveVector + camera.CFrame.RightVector
        end
        if keys.Space then
            moveVector = moveVector + Vector3.new(0, 1, 0)
        end
        if keys.LeftShift then
            moveVector = moveVector - Vector3.new(0, 1, 0)
        end
        
        -- Apply movement with speed
        if moveVector.Magnitude > 0 then
            moveVector = moveVector.Unit * getgenv().flySpeed
        end
        bodyVelocity.Velocity = moveVector
        
        -- CORRECT: BodyGyro follows camera direction
        local lookDirection = camera.CFrame.LookVector
        bodyGyro.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + lookDirection)
    end)
end

-- Stop flying
function stopFly()
    if not getgenv().isFlying then return end
    getgenv().isFlying = false
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode.Name
    if key == "W" or key == "A" or key == "S" or key == "D" or key == "Space" or key == "LeftShift" then
        keys[key] = true
    end
    
    if key == "F" then -- Toggle fly
        if getgenv().isFlying then
            stopFly()
        else
            if getgenv().useV3Method then
                startFlyV3()
            else
                startFlyV4()
            end
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    local key = input.KeyCode.Name
    if key == "W" or key == "A" or key == "S" or key == "D" or key == "Space" or key == "LeftShift" then
        keys[key] = false
    end
end)

-- Clean up when character respawns
player.CharacterAdded:Connect(function(newCharacter)
    stopFly()
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
end)

print("Fly script loaded!")
print("Press F to toggle flying")
print("Use getgenv().useV3Method = true to use V3 method (tpwalk with camera rotation)")
print("Use getgenv().useV3Method = false to use V4 method (standard flying with camera rotation)")
print("Use getgenv().flySpeed = number to change speed")