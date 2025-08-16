local Version = 1.0 -- Começa na versão 1.0, aumenta +0.1 a cada update manual

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealGui"
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 200)
Frame.Position = UDim2.new(0.5, -150, 0.5, -100)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true -- permite arrastar o Frame segurando ele

-- Versão Label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = Color3.new(1, 1, 1)
VersionLabel.Font = Enum.Font.SourceSansBold
VersionLabel.TextSize = 18
VersionLabel.Text = "Version: ".. tostring(Version)
VersionLabel.Parent = Frame

-- Base TextBox
local BaseLabel = Instance.new("TextLabel")
BaseLabel.Size = UDim2.new(0, 70, 0, 20)
BaseLabel.Position = UDim2.new(0, 10, 0, 30)
BaseLabel.BackgroundTransparency = 1
BaseLabel.TextColor3 = Color3.new(1, 1, 1)
BaseLabel.Font = Enum.Font.SourceSans
BaseLabel.TextSize = 16
BaseLabel.Text = "Base:"
BaseLabel.Parent = Frame

local BaseTextBox = Instance.new("TextBox")
BaseTextBox.Size = UDim2.new(0, 150, 0, 25)
BaseTextBox.Position = UDim2.new(0, 80, 0, 30)
BaseTextBox.Text = ""
BaseTextBox.PlaceholderText = "e.g. Base1"
BaseTextBox.ClearTextOnFocus = false
BaseTextBox.Parent = Frame

-- Character TextBox
local CharacterLabel = Instance.new("TextLabel")
CharacterLabel.Size = UDim2.new(0, 70, 0, 20)
CharacterLabel.Position = UDim2.new(0, 10, 0, 65)
CharacterLabel.BackgroundTransparency = 1
CharacterLabel.TextColor3 = Color3.new(1, 1, 1)
CharacterLabel.Font = Enum.Font.SourceSans
CharacterLabel.TextSize = 16
CharacterLabel.Text = "Character:"
CharacterLabel.Parent = Frame

local CharacterTextBox = Instance.new("TextBox")
CharacterTextBox.Size = UDim2.new(0, 150, 0, 25)
CharacterTextBox.Position = UDim2.new(0, 80, 0, 65)
CharacterTextBox.Text = ""
CharacterTextBox.PlaceholderText = "e.g. NPC_1"
CharacterTextBox.ClearTextOnFocus = false
CharacterTextBox.Parent = Frame

-- Steal Button
local StealButton = Instance.new("TextButton")
StealButton.Size = UDim2.new(0, 100, 0, 30)
StealButton.Position = UDim2.new(0, 100, 0, 110)
StealButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
StealButton.TextColor3 = Color3.new(1, 1, 1)
StealButton.Font = Enum.Font.SourceSansBold
StealButton.TextSize = 20
StealButton.Text = "Steal"
StealButton.Parent = Frame

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 24
CloseButton.Text = "X"
CloseButton.Parent = Frame

CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

-- Função do botão Steal
StealButton.MouseButton1Click:Connect(function()
	local baseName = BaseTextBox.Text
	local charName = CharacterTextBox.Text

	if baseName == "" or charName == "" then
		warn("Please fill both Base and Character.")
		return
	end

	local args = {
		"Grab",
		game.Workspace:WaitForChild(baseName):WaitForChild(charName),
		false,
		true
	}
	game:GetService("ReplicatedStorage"):WaitForChild("RemoveEvents"):WaitForChild("NPCDecision"):FireServer(unpack(args))
end)
