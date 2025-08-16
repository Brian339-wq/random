local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local PlaceItem = ReplicatedStorage:WaitForChild("RemoveEvents"):WaitForChild("PlaceItem")

-- Evita múltiplas interfaces
if player.PlayerGui:FindFirstChild("ItemPlacerUI") then
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ItemPlacerUI"
screenGui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Parent = screenGui

local function createLabel(text, position)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(0, 140, 0, 20)
	label.Position = position
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Text = text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = frame
	return label
end

local nomeInput = Instance.new("TextBox")
nomeInput.Size = UDim2.new(0, 140, 0, 25)
nomeInput.Position = UDim2.new(0, 150, 0, 10)
nomeInput.PlaceholderText = "Nome do objeto"
nomeInput.ClearTextOnFocus = false
nomeInput.Parent = frame

createLabel("Posição 1 (ex: -1, 1)", UDim2.new(0, 10, 0, 45))
local pos1Input = Instance.new("TextBox")
pos1Input.Size = UDim2.new(0, 140, 0, 25)
pos1Input.Position = UDim2.new(0, 150, 0, 45)
pos1Input.PlaceholderText = "-1, 1"
pos1Input.ClearTextOnFocus = false
pos1Input.Parent = frame

createLabel("Posição 2 (ex: 2, 0)", UDim2.new(0, 10, 0, 80))
local pos2Input = Instance.new("TextBox")
pos2Input.Size = UDim2.new(0, 140, 0, 25)
pos2Input.Position = UDim2.new(0, 150, 0, 80)
pos2Input.PlaceholderText = "2, 0"
pos2Input.ClearTextOnFocus = false
pos2Input.Parent = frame

createLabel("Rotação (number)", UDim2.new(0, 10, 0, 115))
local rotInput = Instance.new("TextBox")
rotInput.Size = UDim2.new(0, 140, 0, 25)
rotInput.Position = UDim2.new(0, 150, 0, 115)
rotInput.PlaceholderText = "Ex: 90"
rotInput.ClearTextOnFocus = false
rotInput.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 280, 0, 40)
button.Position = UDim2.new(0, 10, 0, 160)
button.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Executar e Rejoin"
button.Parent = frame

button.MouseButton1Click:Connect(function()
	local nome = nomeInput.Text
	local pos1 = pos1Input.Text
	local pos2 = pos2Input.Text
	local rot = tonumber(rotInput.Text) or 0
	
	if nome == "" or pos1 == "" or pos2 == "" then
		warn("Preencha todos os campos!")
		return
	end
	
	local args = {nome, pos1, pos2, rot}
	PlaceItem:FireServer(unpack(args))
	
	button.Text = "Executando..."
	button.Active = false
	button.AutoButtonColor = false
	
	task.delay(2, function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
end)
