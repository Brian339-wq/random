local player = game.Players.LocalPlayer

-- GUI setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ClickLoopUI"
gui.ResetOnSpawn = false

-- Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 350, 0, 200)
frame.Position = UDim2.new(0.5, -175, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Active = true
frame.Draggable = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Shadow
local shadow = Instance.new("ImageLabel", frame)
shadow.BackgroundTransparency = 1
shadow.Position = UDim2.new(0, -15, 0, -15)
shadow.Size = UDim2.new(1, 30, 1, 30)
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.5
shadow.ImageColor3 = Color3.new(0, 0, 0)
shadow.ZIndex = 0

-- Header (draggable part)
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.Text = " Click Loop Tool"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Name = "Header"
header.Active = true

-- Drag logic
local UserInputService = game:GetService("UserInputService")
local dragging = false
local offset

header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = Vector2.new(input.Position.X - frame.Position.X.Offset, input.Position.Y - frame.Position.Y.Offset)
	end
end)

header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		frame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
	end
end)

-- TextBox (Path)
local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.9, 0, 0, 30)
input.Position = UDim2.new(0.05, 0, 0, 50)
input.PlaceholderText = "path"
input.Text = ""
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
input.ClearTextOnFocus = false
Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

-- Wait time box
local waitBox = Instance.new("TextBox", frame)
waitBox.Size = UDim2.new(0.4, 0, 0, 25)
waitBox.Position = UDim2.new(0.05, 0, 0, 90)
waitBox.PlaceholderText = "Delay (e.g. 0.2)"
waitBox.Text = ""
waitBox.Font = Enum.Font.Gotham
waitBox.TextSize = 14
waitBox.TextColor3 = Color3.new(1, 1, 1)
waitBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
waitBox.ClearTextOnFocus = false
Instance.new("UICorner", waitBox).CornerRadius = UDim.new(0, 8)

-- Status label
local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(0.5, 0, 0, 25)
status.Position = UDim2.new(0.5, 0, 0, 90)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 13
status.TextColor3 = Color3.fromRGB(200, 200, 200)
status.Text = "Status: Idle"

-- Start button
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 40)
button.Position = UDim2.new(0.05, 0, 0, 130)
button.Text = "Start Click Loop"
button.Font = Enum.Font.GothamBold
button.TextSize = 16
button.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

-- Mini botão flutuante
local miniButton = Instance.new("TextButton", gui)
miniButton.Size = UDim2.new(0, 100, 0, 30)
miniButton.Position = UDim2.new(0.5, -50, 0.5, -15)
miniButton.Text = "Open UI"
miniButton.Visible = false
miniButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
miniButton.TextColor3 = Color3.new(1, 1, 1)
miniButton.Font = Enum.Font.GothamBold
miniButton.TextSize = 13
Instance.new("UICorner", miniButton).CornerRadius = UDim.new(0, 8)

-- Mini botão arrastável
local draggingMini = false
local miniOffset
miniButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = true
		miniOffset = Vector2.new(input.Position.X - miniButton.Position.X.Offset, input.Position.Y - miniButton.Position.Y.Offset)
	end
end)
miniButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then
		miniButton.Position = UDim2.new(0, input.Position.X - miniOffset.X, 0, input.Position.Y - miniOffset.Y)
	end
end)

-- Close / Open
local closeButton = Instance.new("TextButton", header)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)

closeButton.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniButton.Visible = true
end)
miniButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniButton.Visible = false
end)

-- Função: pegar parte do caminho
local function getPartFromPath(path)
	local success, result = pcall(function()
		return loadstring("return " .. path)()
	end)
	if success and typeof(result) == "Instance" and result:FindFirstChildOfClass("ClickDetector") then
		return result:FindFirstChildOfClass("ClickDetector")
	end
	return nil
end

-- Loop
local looping = false
task.spawn(function()
	while true do
		task.wait(0.1)
		if looping then
			local cd = getPartFromPath(input.Text)
			if cd then
				fireclickdetector(cd)
			end
			local delay = tonumber(waitBox.Text)
			task.wait(delay or 0.3)
		end
	end
end)

-- Botão de ativar
button.MouseButton1Click:Connect(function()
	local cd = getPartFromPath(input.Text)
	if not cd then
		status.Text = "Status: Invalid path / no ClickDetector"
		return
	end
	looping = not looping
	if looping then
		button.Text = "Stop Click Loop"
		button.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
		status.Text = "Status: Looping..."
	else
		button.Text = "Start Click Loop"
		button.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
		status.Text = "Status: Idle"
	end
end)
