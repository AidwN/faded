--> Important Functions <--

Heartbeat:Connect(function()
    UpdateFOV()
    if Plr == nil then
        Plr = LocalPlayer
    end
    if Settings.SelectedPlayer == nil then
        Settings.SelectedPlayer = LocalPlayer
    end
-- if Settings.SelectPlayerMode == false then
-- Plr = GetNearestTarget()
-- end
end)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

UserInputService.InputBegan:connect(function(Key)
    if Key.KeyCode == getgenv().SilentAimKey and Settings.SilentAim and Settings.SelectPlayerMode then
        if Settings.isLocked then
            Settings.isLocked = false
            if Settings.WebhookMode then
                sendMessage("Puppy Ware: Unlocked")
            end
            if Settings.NotificationMode then
                notify("Faded", "Unlocked", 1)
            end
            Plr = LocalPlayer
        else
            Settings.isLocked = true
            Plr = GetNearestTarget()
            if Settings.WebhookMode then
                sendMessage("Locked Onnto: "..tostring(Plr.DisplayName).." Aka "..Plr.Name)
            end
            if Settings.NotificationMode then
                notify("Faded", "Locked Onto: "..tostring(Plr.DisplayName).."", 1)
            end
            end
        end
    end)

    function checkSilentAim()
        local checkA = (Settings.SilentAim == true and Plr ~= LocalPlayer)
        local CPlayer = Plr
        local checkB = (CPlayer.Character.BodyEffects["K.O"].Value == false or CPlayer.Character:FindFirstChild("GRABBING_CONSTRAINT") ~= nil)
        return (checkA and checkB)
    end

-- // Hook

local __index
__index = hookmetamethod(game, "__index", function(t, k)
    -- // Check if it trying to get our mouse's hit or target and see if we can use it
    if (t:IsA("Mouse") and (k == "Hit" or k == "Target") and checkSilentAim()) then
        -- // Vars
        local CPlayer = Plr
        -- // Hit/Target
        if ((k == "Hit" or k == "Target")) then
            -- // Hit to account prediction
            local Hit = CPlayer.Character[Settings.AimPart].CFrame + (CPlayer.Character[Settings.AimPart].Velocity * Settings.Prediction)

            -- // Return modded val
            return (k == "Hit" and Hit or "Head")
        end
    end

    -- // Return
    return __index(t, k)
end)

RunService.RenderStepped:Connect(function()
    if Settings.SilentAim then
    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
    local Value = tostring(ping)
    local pingValue = Value:split(" ")
    local PingNumber = pingValue[1]
    Settings.Prediction = PingNumber / 1000 + _G.PRED
    local CPlayer = Plr
    if Settings.HitAirshots and Settings.SilentAim then
    if CPlayer.Character.Humanoid.Jump == true and CPlayer.Character.Humanoid.FloorMaterial == Enum.Material.Air then
        Settings.AimPart = "RightFoot"
    else
        CPlayer.Character:WaitForChild("Humanoid").StateChanged:Connect(function(new)
            if new == Enum.HumanoidStateType.Freefall then
                Settings.AimPart = "RightFoot"
            else
                Settings.AimPart = "Head"
            end
        end)
    end
    end
    end
end)
