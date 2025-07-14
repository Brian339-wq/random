-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TouchUI"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 230)
frame.Position = UDim2.new(0.5, -175, 0.5, -115)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true
frame.Name = "MainFrame"

-- UI Corner
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.Name = "Shadow"
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ImageTransparency = 0.5
shadow.ZIndex = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Touch Loop Tool"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Close Button
local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 20
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

-- Input Box (Path)
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9, 0, 0, 30)
input.Position = UDim2.new(0.05, 0, 0, 40)
input.PlaceholderText = "path"
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.ClearTextOnFocus = false
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

-- Delay Box
local delayBox = Instance.new("TextBox", frame)
delayBox.Size = UDim2.new(0.4, 0, 0, 25)
delayBox.Position = UDim2.new(0.05, 0, 0, 75)
delayBox.PlaceholderText = "Delay (e.g. 0.5)"
delayBox.Font = Enum.Font.Gotham
delayBox.TextSize = 14
delayBox.TextColor3 = Color3.new(1, 1, 1)
delayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
delayBox.ClearTextOnFocus = false
Instance.new("UICorner", delayBox).CornerRadius = UDim.new(0, 6)

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, 105)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "Status: Idle"

-- Toggle Loop Button
local toggleButton = Instance.new("TextButton", frame)
toggleButton.Size = UDim2.new(0.9, -5, 0, 35)
toggleButton.Position = UDim2.new(0.05, 0, 0, 130)
toggleButton.Text = "Start Touch Loop"
toggleButton.Font = Enum.Font.GothamBold
toggleButton.TextSize = 16
toggleButton.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", toggleButton).CornerRadius = UDim.new(0, 8)

-- Touch Once Button
local touchOnceButton = Instance.new("TextButton", frame)
touchOnceButton.Size = UDim2.new(0.9, 0, 0, 30)
touchOnceButton.Position = UDim2.new(0.05, 0, 0, 175)
touchOnceButton.Text = "Touch Once"
touchOnceButton.Font = Enum.Font.GothamBold
touchOnceButton.TextSize = 14
touchOnceButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
touchOnceButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", touchOnceButton).CornerRadius = UDim.new(0, 8)

-- Variables
local looping = false
local delayValue = 0.5

-- Update delay when user finishes typing
delayBox.FocusLost:Connect(function()
	local num = tonumber(delayBox.Text)
	if num and num > 0 then
		delayValue = num
		status.Text = "Status: Delay set to " .. num
	else
		status.Text = "Status: Invalid delay, using " .. delayValue
	end
end)

-- Function to get part from path
local function getPartFromPath(path)
	local success, result = pcall(function()
		return loadstring("return " .. path)()
	end)
	if success and typeof(result) == "Instance" and result:IsA("BasePart") then
		return result
	end
	return nil
end

-- Loop
task.spawn(function()
	while true do
		task.wait(delayValue)
		if looping then
			local char = player.Character or player.CharacterAdded:Wait()
			local root = char:FindFirstChild("HumanoidRootPart")
			local part = getPartFromPath(input.Text)

			if root and part then
				firetouchinterest(root, part, 0)
				task.wait(0.1)
				firetouchinterest(root, part, 1)
			end
		end
	end
end)

-- Toggle loop button click
toggleButton.MouseButton1Click:Connect(function()
	local part = getPartFromPath(input.Text)
	if not part then
		status.Text = "Status: Invalid path or part not found"
		return
	end

	looping = not looping
	if looping then
		toggleButton.Text = "Stop Touch Loop"
		toggleButton.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
		status.Text = "Status: Looping..."
	else
		toggleButton.Text = "Start Touch Loop"
		toggleButton.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
		status.Text = "Status: Idle"
	end
end)

-- Touch once button click
touchOnceButton.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local root = char:FindFirstChild("HumanoidRootPart")
	local part

	if input.Text == "" or input.Text == nil then
		part = root
	else
		part = getPartFromPath(input.Text)
	end

	if root and part then
		firetouchinterest(root, part, 0)
		task.wait(0.1)
		firetouchinterest(root, part, 1)
		status.Text = "Status: Touched once!"
	else
		status.Text = "Status: Invalid path or part not found"
	end
end)

-- Dragging only by title bar
local UIS = game:GetService("UserInputService")
local dragging, dragInput, mousePos, framePos

local function update(input)
	local delta = input.Position - mousePos
	frame.Position = UDim2.new(
		framePos.X.Scale,
		framePos.X.Offset + delta.X,
		framePos.Y.Scale,
		framePos.Y.Offset + delta.Y
	)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		mousePos = input.Position
		framePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)
