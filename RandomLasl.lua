-- Criar GUI
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Função para arrastar a GUI
local dragging = false
local dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Botão fechar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Label e TextBox para Base
local baseLabel = Instance.new("TextLabel")
baseLabel.Size = UDim2.new(1, -20, 0, 25)
baseLabel.Position = UDim2.new(0, 10, 0, 40)
baseLabel.BackgroundTransparency = 1
baseLabel.Text = "Base (Base1 to Base4):"
baseLabel.TextColor3 = Color3.new(1,1,1)
baseLabel.TextXAlignment = Enum.TextXAlignment.Left
baseLabel.Parent = mainFrame

local baseInput = Instance.new("TextBox")
baseInput.Size = UDim2.new(1, -20, 0, 30)
baseInput.Position = UDim2.new(0, 10, 0, 65)
baseInput.ClearTextOnFocus = false
baseInput.Text = "Base1"
baseInput.Parent = mainFrame

-- Label e TextBox para Character (personagem)
local charLabel = Instance.new("TextLabel")
charLabel.Size = UDim2.new(1, -20, 0, 25)
charLabel.Position = UDim2.new(0, 10, 0, 105)
charLabel.BackgroundTransparency = 1
charLabel.Text = "Character (NPC ID):"
charLabel.TextColor3 = Color3.new(1,1,1)
charLabel.TextXAlignment = Enum.TextXAlignment.Left
charLabel.Parent = mainFrame

local charInput = Instance.new("TextBox")
charInput.Size = UDim2.new(1, -20, 0, 30)
charInput.Position = UDim2.new(0, 10, 0, 130)
charInput.ClearTextOnFocus = false
charInput.Text = "1"
charInput.Parent = mainFrame

-- Frame para lista de NPCs
local npcListFrame = Instance.new("ScrollingFrame")
npcListFrame.Size = UDim2.new(1, -20, 0, 150)
npcListFrame.Position = UDim2.new(0, 10, 0, 175)
npcListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
npcListFrame.ScrollBarThickness = 6
npcListFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
npcListFrame.BorderSizePixel = 0
npcListFrame.Parent = mainFrame

-- UIListLayout para NPCs
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = npcListFrame

-- Botão Steal
local stealButton = Instance.new("TextButton")
stealButton.Size = UDim2.new(1, -20, 0, 40)
stealButton.Position = UDim2.new(0, 10, 1, -50)
stealButton.Text = "Steal"
stealButton.TextColor3 = Color3.new(1,1,1)
stealButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
stealButton.Parent = mainFrame

-- Função para atualizar a lista de NPCs da base selecionada
local function updateNPCList()
    -- Limpar lista antiga
    for _, child in ipairs(npcListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local baseName = baseInput.Text
    local base = workspace:FindFirstChild(baseName)

    if base then
        -- Procurar NPCs no formato NPC_[id]
        for _, npc in ipairs(base:GetChildren()) do
            if npc.Name:match("^NPC_%d+$") then
                local npcButton = Instance.new("TextButton")
                npcButton.Size = UDim2.new(1, -10, 0, 30)
                npcButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                npcButton.TextColor3 = Color3.new(1,1,1)
                npcButton.Text = npc.Name
                npcButton.Parent = npcListFrame

                npcButton.MouseButton1Click:Connect(function()
                    -- Atualizar o campo character com o ID do NPC clicado
                    local id = npc.Name:match("^NPC_(%d+)$")
                    if id then
                        charInput.Text = id
                    end
                end)
            end
        end

        -- Atualizar o CanvasSize para scroll funcionar
        local contentHeight = listLayout.AbsoluteContentSize.Y
        npcListFrame.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    else
        -- Se base não encontrada
        local noBaseLabel = Instance.new("TextLabel")
        noBaseLabel.Size = UDim2.new(1, -10, 0, 30)
        noBaseLabel.BackgroundTransparency = 1
        noBaseLabel.TextColor3 = Color3.fromRGB(200, 50, 50)
        noBaseLabel.Text = "Base not found!"
        noBaseLabel.Parent = npcListFrame
    end
end

-- Atualiza lista quando o texto da base mudar (perda de foco)
baseInput.FocusLost:Connect(updateNPCList)

-- Atualiza a lista ao abrir
updateNPCList()

-- Função do botão Steal
stealButton.MouseButton1Click:Connect(function()
    local baseName = baseInput.Text
    local charId = charInput.Text
    local npcName = "NPC_" .. charId

    local args = {
        "Grab",
        npcName,
        false,
        true
    }

    local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoveEvents"):WaitForChild("NPCDecision")
    remote:FireServer(unpack(args))
end)
