local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlaceItemGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Make frame draggable by TitleBar
local dragInput, dragStart, startPos
local function updatePosition(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Place Item GUI"
titleLabel.Size = UDim2.new(1, -140, 1, 0)  -- deixa espaço pros botões à direita
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Parent = titleBar

-- Drag functionality
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragStart = nil
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragStart then
        updatePosition(input)
    end
end)

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Text = "X"
closeButton.Size = UDim2.new(0, 30, 1, 0)
closeButton.Position = UDim2.new(1, -35, 0, 0) -- ajustei pra não colar no limite
closeButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = titleBar

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- List Button (à esquerda do título)
local listButton = Instance.new("TextButton")
listButton.Size = UDim2.new(0, 80, 0, 25)
listButton.Position = UDim2.new(0, 5, 0, 2)
listButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
listButton.Text = "List"
listButton.TextColor3 = Color3.fromRGB(255, 255, 255)
listButton.Font = Enum.Font.SourceSansBold
listButton.TextSize = 18
listButton.Parent = titleBar

-- Helper to create labeled textbox
local function createLabeledTextBox(parent, labelText, pos)
    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.Size = UDim2.new(0, 120, 0, 25)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(0, 200, 0, 25)
    textBox.Position = pos + UDim2.new(0, 130, 0, 0)
    textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.Font = Enum.Font.SourceSans
    textBox.TextSize = 16
    textBox.ClearTextOnFocus = false
    textBox.Parent = parent

    return textBox
end

-- Input Fields
local nameBox = createLabeledTextBox(mainFrame, "Object Name:", UDim2.new(0, 10, 0, 40))
local pos1Box = createLabeledTextBox(mainFrame, "Position 1:", UDim2.new(0, 10, 0, 75))
local pos2Box = createLabeledTextBox(mainFrame, "Position 2:", UDim2.new(0, 10, 0, 110))
local rotBox = createLabeledTextBox(mainFrame, "Rotation:", UDim2.new(0, 10, 0, 145))

-- Execute Button
local execButton = Instance.new("TextButton")
execButton.Text = "Execute"
execButton.Size = UDim2.new(0, 120, 0, 35)
execButton.Position = UDim2.new(0, 10, 0, 180)
execButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
execButton.TextColor3 = Color3.fromRGB(255, 255, 255)
execButton.Font = Enum.Font.SourceSansBold
execButton.TextSize = 18
execButton.Parent = mainFrame

-- List Frame (hidden by default)
local listFrame = Instance.new("Frame")
listFrame.Size = UDim2.new(0, 330, 0, 120)
listFrame.Position = UDim2.new(0, 10, 0, 185)
listFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
listFrame.BorderSizePixel = 0
listFrame.Visible = false
listFrame.Parent = mainFrame

local listScroll = Instance.new("ScrollingFrame")
listScroll.Size = UDim2.new(1, 0, 1, 0)
listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
listScroll.ScrollBarThickness = 6
listScroll.BackgroundTransparency = 1
listScroll.Parent = listFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = listScroll

-- Populate the list with FactoryPieces
local function populateList()
    -- Clear previous entries
    for _, child in ipairs(listScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    local factoryPiecesFolder = ReplicatedStorage:FindFirstChild("Storage") 
        and ReplicatedStorage.Storage:FindFirstChild("FactoryPieces")
    if not factoryPiecesFolder then
        warn("FactoryPieces folder not found!")
        return
    end

    for _, obj in ipairs(factoryPiecesFolder:GetChildren()) do
        if obj:IsA("Instance") then
            local itemButton = Instance.new("TextButton")
            itemButton.Size = UDim2.new(1, -10, 0, 25)
            itemButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            itemButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            itemButton.Font = Enum.Font.SourceSans
            itemButton.TextSize = 16
            itemButton.Text = obj.Name
            itemButton.Parent = listScroll

            itemButton.MouseButton1Click:Connect(function()
                nameBox.Text = obj.Name
                listFrame.Visible = false
            end)
        end
    end

    -- Update canvas size to fit all buttons
    listScroll.CanvasSize = UDim2.new(0, 0, 0, #factoryPiecesFolder:GetChildren() * 30)
end

listButton.MouseButton1Click:Connect(function()
    if listFrame.Visible then
        listFrame.Visible = false
    else
        populateList()
        listFrame.Visible = true
    end
end)

-- Execute action (without rejoin)
execButton.MouseButton1Click:Connect(function()
    local name = nameBox.Text
    local pos1 = pos1Box.Text
    local pos2 = pos2Box.Text
    local rot = tonumber(rotBox.Text) or 0

    if name == "" or pos1 == "" or pos2 == "" then
        warn("Please fill all fields!")
        return
    end

    local args = {
        name,
        pos1,
        pos2,
        rot
    }

    local removeEvents = ReplicatedStorage:WaitForChild("RemoveEvents")
    local placeItemEvent = removeEvents:WaitForChild("PlaceItem")

    placeItemEvent:FireServer(unpack(args))

    -- Feedback
    execButton.Text = "Executed!"
    execButton.Active = false
    task.delay(2, function()
        execButton.Text = "Execute"
        execButton.Active = true
    end)
end)
