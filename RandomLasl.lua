local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealNPCGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 320)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Text = "NPC Stealer"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Dragging Logic
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
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

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Base Input
local baseLabel = Instance.new("TextLabel")
baseLabel.Text = "Base:"
baseLabel.Size = UDim2.new(0, 50, 0, 25)
baseLabel.Position = UDim2.new(0, 10, 0, 40)
baseLabel.BackgroundTransparency = 1
baseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
baseLabel.Font = Enum.Font.SourceSans
baseLabel.TextSize = 16
baseLabel.Parent = mainFrame

local baseInput = Instance.new("TextBox")
baseInput.Size = UDim2.new(0, 200, 0, 25)
baseInput.Position = UDim2.new(0, 60, 0, 40)
baseInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
baseInput.TextColor3 = Color3.fromRGB(255, 255, 255)
baseInput.Font = Enum.Font.SourceSans
baseInput.TextSize = 16
baseInput.PlaceholderText = "e.g., Base1"
baseInput.ClearTextOnFocus = false
baseInput.Parent = mainFrame

-- Character Input
local charLabel = Instance.new("TextLabel")
charLabel.Text = "Character:"
charLabel.Size = UDim2.new(0, 80, 0, 25)
charLabel.Position = UDim2.new(0, 10, 0, 75)
charLabel.BackgroundTransparency = 1
charLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
charLabel.Font = Enum.Font.SourceSans
charLabel.TextSize = 16
charLabel.Parent = mainFrame

local charInput = Instance.new("TextBox")
charInput.Size = UDim2.new(0, 180, 0, 25)
charInput.Position = UDim2.new(0, 100, 0, 75)
charInput.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
charInput.TextColor3 = Color3.fromRGB(255, 255, 255)
charInput.Font = Enum.Font.SourceSans
charInput.TextSize = 16
charInput.PlaceholderText = "Optional"
charInput.ClearTextOnFocus = false
charInput.Parent = mainFrame

-- List Characters Button
local listButton = Instance.new("TextButton")
listButton.Text = "List Characters"
listButton.Size = UDim2.new(0, 300, 0, 30)
listButton.Position = UDim2.new(0, 10, 0, 110)
listButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
listButton.TextColor3 = Color3.fromRGB(255, 255, 255)
listButton.Font = Enum.Font.SourceSansBold
listButton.TextSize = 16
listButton.Parent = mainFrame

-- NPC List Area
local npcListFrame = Instance.new("Frame")
npcListFrame.Size = UDim2.new(1, -20, 0, 150)
npcListFrame.Position = UDim2.new(0, 10, 0, 150)
npcListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
npcListFrame.Parent = mainFrame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, 0, 1, 0)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = npcListFrame

local layout = Instance.new("UIListLayout")
layout.Parent = scrollFrame
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- List Characters Logic
listButton.MouseButton1Click:Connect(function()
	local baseName = baseInput.Text
	if baseName == "" then
		warn("Please enter a base name (e.g., Base1).")
		return
	end

	local base = Workspace:FindFirstChild(baseName)
	if not base then
		warn("Base not found!")
		return
	end

	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local count = 0
	for _, npc in ipairs(base:GetChildren()) do
		if npc:IsA("Model") and npc.Name:match("^NPC_%d+") then
			count += 1

			local npcButton = Instance.new("TextButton")
			npcButton.Size = UDim2.new(1, -10, 0, 25)
			npcButton.Text = npc.Name
			npcButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			npcButton.TextColor3 = Color3.fromRGB(255, 255, 255)
			npcButton.Font = Enum.Font.SourceSans
			npcButton.TextSize = 16
			npcButton.Parent = scrollFrame

			npcButton.MouseButton1Click:Connect(function()
				local args = {
					"Grab",
					npc.Name,
					false,
					true
				}
				ReplicatedStorage:WaitForChild("RemoveEvents"):WaitForChild("NPCDecision"):FireServer(unpack(args))
			end)
		end
	end

	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, count * 30)
end)
