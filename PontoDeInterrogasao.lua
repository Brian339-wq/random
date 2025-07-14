-- Remote Spy GUI v1.2
-- ✅ Interface arrastável e com opção de tamanho via Dropdown
-- Requer executor com hookmetamethod, getnamecallmethod, loadstring, setclipboard

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local remoteLogs = {}

-- Helper: formatar argumentos
local function formatArg(arg)
	if typeof(arg) == "string" then
		return string.format("%q", arg)
	elseif typeof(arg) == "Instance" then
		return "game." .. arg:GetFullName()
	elseif typeof(arg) == "Vector3" then
		return string.format("Vector3.new(%s, %s, %s)", arg.X, arg.Y, arg.Z)
	elseif typeof(arg) == "CFrame" then
		local pos = arg.Position
		return string.format("CFrame.new(%s, %s, %s)", pos.X, pos.Y, pos.Z)
	else
		return tostring(arg)
	end
end

local function generateScript(remote, method, args)
	local formattedArgs = {}
	for _, v in ipairs(args) do
		table.insert(formattedArgs, formatArg(v))
	end
	return string.format("game.%s:%s(%s)", remote:GetFullName(), method, table.concat(formattedArgs, ", "))
end

-- Função de tamanho
local function applySize(size, frame)
	if size == "Small" then
		frame.Size = UDim2.new(0, 400, 0, 280)
	elseif size == "Medium" then
		frame.Size = UDim2.new(0, 550, 0, 360)
	elseif size == "Large" then
		frame.Size = UDim2.new(0, 700, 0, 440)
	end
end

-- UI
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "RemoteSpyUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
applySize("Medium", frame)
frame.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2, 0.5, -frame.Size.Y.Offset / 2)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header (drag handle)
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.Text = " Remote Spy"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Name = "Header"
header.Active = true

-- Drag logic
local dragging, offset
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

-- Close button
local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

-- Mini botão (Open Spy)
local miniBtn = Instance.new("TextButton", gui)
miniBtn.Size = UDim2.new(0, 100, 0, 30)
miniBtn.Position = UDim2.new(0.5, -50, 0.5, -15)
miniBtn.Text = "Open Spy"
miniBtn.Visible = false
miniBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
miniBtn.TextColor3 = Color3.new(1, 1, 1)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 14
Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 6)

-- Arrastar mini botão
local draggingMini, offsetMini
miniBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = true
		offsetMini = Vector2.new(input.Position.X - miniBtn.Position.X.Offset, input.Position.Y - miniBtn.Position.Y.Offset)
	end
end)
miniBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then
		miniBtn.Position = UDim2.new(0, input.Position.X - offsetMini.X, 0, input.Position.Y - offsetMini.Y)
	end
end)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniBtn.Visible = false
end)

-- Dropdown de tamanho
local dropdown = Instance.new("TextButton", frame)
dropdown.Size = UDim2.new(0, 100, 0, 25)
dropdown.Position = UDim2.new(0, 10, 0, 35)
dropdown.Text = "Size: Medium"
dropdown.Font = Enum.Font.GothamBold
dropdown.TextSize = 12
dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
dropdown.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local sizes = {"Small", "Medium", "Large"}
local sizeIndex = 2

dropdown.MouseButton1Click:Connect(function()
	sizeIndex += 1
	if sizeIndex > #sizes then sizeIndex = 1 end
	local newSize = sizes[sizeIndex]
	dropdown.Text = "Size: " .. newSize
	applySize(newSize, frame)
	frame.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2, 0.5, -frame.Size.Y.Offset / 2)
end)

-- Texto de versão
local versionLabel = Instance.new("TextLabel", frame)
versionLabel.Size = UDim2.new(0, 100, 0, 20)
versionLabel.Position = UDim2.new(1, -105, 1, -22)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v1.2"
versionLabel.Font = Enum.Font.Gotham
versionLabel.TextSize = 12
versionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
versionLabel.TextTransparency = 0.4
versionLabel.TextXAlignment = Enum.TextXAlignment.Right
