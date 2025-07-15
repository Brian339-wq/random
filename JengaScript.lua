local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Jenga / Knock The Blocks",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Please wait",
    ConfigurationSaving = {
        Enabled = false
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", nil)

-- TELEPORT LOCATIONS
local teleportLocations = {
    ["Jenga"] = CFrame.new(-3.70082521, 233.313232, 7.93368149, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Destroyer"] = CFrame.new(0, 90.9980011, -458.5, -1, 0, 0, 0, 1, 0, 0, 0, -1),
    ["Spawn"] = CFrame.new(
        0.0252015963, 277.497986, -206.636627,
        -0.99917084, -7.82007419e-08, -0.0407137387,
        -7.82829304e-08, 1, 4.243986e-10,
        0.0407137387, 3.61123753e-09, -0.99917084
    )
}

local selectedLocation = teleportLocations["Spawn"]

Tab:CreateDropdown({
    Name = "Select Teleport Location",
    Options = {"Jenga", "Destroyer", "Spawn"},
    CurrentOption = "Spawn",
    Callback = function(option)
        selectedLocation = teleportLocations[option]
    end,
})

Tab:CreateButton({
    Name = "Teleport",
    Callback = function()
        local player = game.Players.LocalPlayer
        if selectedLocation and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character:SetPrimaryPartCFrame(selectedLocation)
        end
    end,
})

-- DEATH SOUND DROPDOWN
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local deathSoundsFolder = ReplicatedStorage:WaitForChild("DeathSounds")
local soundOptions = {}
for _, sound in ipairs(deathSoundsFolder:GetChildren()) do
    if sound:IsA("Sound") then
        table.insert(soundOptions, sound.Name)
    end
end

Tab:CreateDropdown({
    Name = "Select Death Sound",
    Options = soundOptions,
    CurrentOption = soundOptions[1] or "None",
    Callback = function(selectedSound)
        local player = game.Players.LocalPlayer
        local args = {
            player.Character:WaitForChild("HumanoidRootPart"),
            deathSoundsFolder:WaitForChild(selectedSound)
        }
        ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("ChangeDeathSound"):FireServer(unpack(args))
    end,
})

-- TOUCH FLING BUTTON
local hiddenfling = false
local flingThread

Tab:CreateButton({
    Name = "Toggle Fling",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer

        hiddenfling = not hiddenfling
        Rayfield:Notify({
            Title = "Touch Fling",
            Content = hiddenfling and "Fling ON" or "Fling OFF",
            Duration = 3,
            Image = nil,
        })

        if hiddenfling then
            if not ReplicatedStorage:FindFirstChild("juisdfj0i32i0eidsuf0iok") then
                local detection = Instance.new("Decal")
                detection.Name = "juisdfj0i32i0eidsuf0iok"
                detection.Parent = ReplicatedStorage
            end

            flingThread = coroutine.create(function()
                local c, hrp, vel, movel = nil, nil, nil, 0.1

                while hiddenfling do
                    RunService.Heartbeat:Wait()
                    c = player.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")

                    if hrp then
                        vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        RunService.RenderStepped:Wait()
                        hrp.Velocity = vel
                        RunService.Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
            end)

            coroutine.resume(flingThread)
        end
    end,
})

-- AUTO FLING TOGGLE
local autoFlingActive = false

Tab:CreateToggle({
    Name = "Auto Fling (TP + Fling)",
    CurrentValue = false,
    Callback = function(state)
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer

        autoFlingActive = state
        hiddenfling = state

        if state then
            -- TP to given CFrame
            local targetCFrame = CFrame.new(
                -3.63086557, 93.4504166, -0.964744866,
                -0.394804865, 4.1857156e-08, -0.918765008,
                -6.75298608e-08, 1, 7.45764979e-08,
                0.918765008, 9.14872373e-08, -0.394804865
            )

            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:SetPrimaryPartCFrame(targetCFrame)
            end

            Rayfield:Notify({
                Title = "Auto Fling",
                Content = "Teleported and Fling Activated!",
                Duration = 3,
                Image = nil,
            })

            -- Start fling
            flingThread = coroutine.create(function()
                local c, hrp, vel, movel = nil, nil, nil, 0.1

                while autoFlingActive do
                    RunService.Heartbeat:Wait()
                    c = player.Character
                    hrp = c and c:FindFirstChild("HumanoidRootPart")

                    if hrp then
                        vel = hrp.Velocity
                        hrp.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        RunService.RenderStepped:Wait()
                        hrp.Velocity = vel
                        RunService.Stepped:Wait()
                        hrp.Velocity = vel + Vector3.new(0, movel, 0)
                        movel = -movel
                    end
                end
            end)

            coroutine.resume(flingThread)
        else
            Rayfield:Notify({
                Title = "Auto Fling",
                Content = "Fling Deactivated",
                Duration = 3,
                Image = nil,
            })
        end
    end
})
