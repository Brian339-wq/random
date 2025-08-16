local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptGeneratorGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 220)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Dragging functionality
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

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

-- Base label + input
local baseLabel = Instance.new("TextLabel")
baseLabel.Size = UDim2.new(1, -20, 0, 25)
baseLabel.Position = UDim2.new(0, 10, 0, 40)
baseLabel.BackgroundTransparency = 1
baseLabel.Text = "Base (Base1 to Base4):"
baseLabel.TextColor3 = Color3.new(1, 1, 1)
baseLabel.TextXAlignment = Enum.TextXAlignment.Left
baseLabel.Parent = mainFrame

local baseInput = Instance.new("TextBox")
baseInput.Size = UDim2.new(1, -20, 0, 30)
baseInput.Position = UDim2.new(0, 10, 0, 65)
baseInput.ClearTextOnFocus = false
baseInput.Text = "Base1"
baseInput.Parent = mainFrame

-- Character label + input
local charLabel = Instance.new("TextLabel")
charLabel.Size = UDim2.new(1, -20, 0, 25)
charLabel.Position = UDim2.new(0, 10, 0, 105)
charLabel.BackgroundTransparency = 1
charLabel.Text = "Character (NPC ID):"
charLabel.TextColor3 = Color3.new(1, 1, 1)
charLabel.TextXAlignment = Enum.TextXAlignment.Left
charLabel.Parent = mainFrame

local charInput = Instance.new("TextBox")
charInput.Size = UDim2.new(1, -20, 0, 30)
charInput.Position = UDim2.new(0, 10, 0, 130)
charInput.ClearTextOnFocus = false
charInput.Text = "1"
charInput.Parent = mainFrame

-- Button to copy script
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(1, -20, 0, 40)
copyButton.Position = UDim2.new(0, 10, 1, -50)
copyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
copyButton.Text = "Copy Script"
copyButton.TextColor3 = Color3.new(1, 1, 1)
copyButton.Parent = mainFrame

-- Function to generate and copy the script string
copyButton.MouseButton1Click:Connect(function()
	local baseName = baseInput.Text
	local npcId = charInput.Text

	local scriptString = [[
local args = {
	workspace:WaitForChild("]] .. baseName .. [["):WaitForChild("NPC_]] .. npcId .. [[")
}
game:GetService("ReplicatedStorage"):WaitForChild("RemoveEvents"):WaitForChild("Drop"):FireServer(unpack(args))
]]

	-- Copiar para área de transferência
	local success, err = pcall(function()
		setclipboard(scriptString)
	end)

	if success then
		copyButton.Text = "Copied!"
		task.delay(2, function()
			copyButton.Text = "Copy Script"
		end)
	else
		copyButton.Text = "Failed to copy"
		warn("Clipboard error:", err)
	end
end)
