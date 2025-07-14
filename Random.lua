-- LocalScript (StarterPlayerScripts)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "TouchUI"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"

-- UI Corner
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

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

-- Input Box
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9, 0, 0, 30)
input.Position = UDim2.new(0.05, 0, 0, 50)
input.PlaceholderText = "Enter part path (e.g. workspace.Part)"
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.ClearTextOnFocus = false
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

-- Status Label
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.9, 0, 0, 20)
status.Position = UDim2.new(0.05, 0, 0, 90)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "Status: Idle"

-- Toggle Button
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.new(0.05, 0, 0, 120)
button.Text = "Start Touch Loop"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Touch Logic
local looping = false

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
		task.wait(0.5)
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

-- Botão de ativação
button.MouseButton1Click:Connect(function()
	local part = getPartFromPath(input.Text)
	if not part then
		status.Text = "Status: Invalid path or part not found"
		return
	end

	looping = not looping
	if looping then
		button.Text = "Stop Touch Loop"
		button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
		status.Text = "Status: Looping..."
	else
		button.Text = "Start Touch Loop"
		button.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
		status.Text = "Status: Idle"
	end
end)
