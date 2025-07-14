-- Coloque este script em StarterPlayerScripts

-- Tenta carregar Rayfield com segurança
local Rayfield
local success, result = pcall(function()
    return loadstring(game:HttpGet("https://sirius.menu/rayfield"))
end)

if success and typeof(result) == "function" then
    Rayfield = result()
else
    warn("Failed to load Rayfield UI.")
    return
end

-- Variáveis
local isLooping = false
local partPath = ""

-- Cria interface
local Window = Rayfield:CreateWindow({
    Name = "Touch Tool",
    LoadingTitle = "Loading...",
    ConfigurationSaving = {
        Enabled = false,
    },
})

local MainTab = Window:CreateTab("Main", 0)

-- Input: Caminho da parte
MainTab:CreateInput({
    Name = "Part Path",
    PlaceholderText = "Example: workspace.PartName",
    RemoveTextAfterFocusLost = false,
    Callback = function(input)
        partPath = input
    end,
})

-- Função para buscar parte
local function GetPart(path)
    local ok, result = pcall(function()
        return loadstring("return " .. path)()
    end)
    if ok and typeof(result) == "Instance" and result:IsA("BasePart") then
        return result
    end
    return nil
end

-- Loop de toque
task.spawn(function()
    while true do
        task.wait(0.5)
        if isLooping then
            local player = game.Players.LocalPlayer
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local target = GetPart(partPath)

            if root and target then
                firetouchinterest(root, target, 0)
                task.wait(0.1)
                firetouchinterest(root, target, 1)
            end
        end
    end
end)

-- Toggle para ativar/desativar
MainTab:CreateToggle({
    Name = "Enable Touch Loop",
    CurrentValue = false,
    Callback = function(state)
        local part = GetPart(partPath)
        if state and part then
            isLooping = true
            Rayfield:Notify({Title = "Touch Tool", Content = "Touch loop started.", Duration = 3})
        else
            isLooping = false
            Rayfield:Notify({Title = "Touch Tool", Content = "Touch loop stopped or part not found.", Duration = 3})
        end
    end,
})
