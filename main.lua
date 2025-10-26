local player = game.Players.LocalPlayer
local UNDER_MAP_Y = -500
local TELEPORT_COOLDOWN = 5 
local lastTeleport = 0


local function getCharacter()
    local success, character = pcall(function()
        return player.Character or player.CharacterAdded:Wait()
    end)
    if success then
        return character
    else
        warn("Pidor ne Obnaruzen")
        return nil
    end
end


local function teleportToCandyBucket(bucket)
    if not bucket or not bucket:IsA("Model") then return end

    local sphere = bucket:FindFirstChild("Sphere")
    if not sphere or not sphere:IsA("BasePart") then
        warn("❌ TI TYPOI INVALID")
        return
    end

    local character = getCharacter()
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        warn("❌ HumanoidRootPart DIBIL ne Naiden")
        return
    end

    
    if tick() - lastTeleport < TELEPORT_COOLDOWN then return end
    lastTeleport = tick()

    
    pcall(function()
        hrp.Anchored = false
        hrp.CFrame = CFrame.new(sphere.Position + Vector3.new(0, 5, 0))
    end)

    print("✅ TELEPORT USPESHEN")
end


local function teleportUnderMap()
    local character = getCharacter()
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.Anchored = true
            hrp.CFrame = CFrame.new(0, UNDER_MAP_Y, 0)
        end)
        print("⛔ SIDI I NE RIPAISYA")
    end
end


local function unfreezeCharacter()
    local character = getCharacter()
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function()
            hrp.Anchored = false
        end)
    end
end


local platParent = workspace:WaitForChild("Platform")
local plat = platParent:WaitForChild("Plat")


local function checkCandyBuckets()
    local found = false
    for _, obj in ipairs(plat:GetChildren()) do
        if obj.Name == "CandyBucket" and obj:IsA("Model") then
            found = true
            local sphere = obj:FindFirstChild("Sphere")
            if sphere then
                unfreezeCharacter()
                teleportToCandyBucket(obj)
            end
        end
    end

    if not found then
        teleportUnderMap()
    else
        print("BEM BEM BE BE BE BEM BEM")
    end
end


checkCandyBuckets()


plat.ChildAdded:Connect(function(child)
    if child.Name == "CandyBucket" and child:IsA("Model") then
        child:WaitForChild("Sphere")
        unfreezeCharacter()
        teleportToCandyBucket(child)
    end
end)


player.CharacterAdded:Connect(function()
    task.wait(1)
    checkCandyBuckets()
end)


task.spawn(function()
    while true do
        task.wait(10)
        checkCandyBuckets()
    end
end)
