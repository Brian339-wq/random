local Version = 1.1 -- Atualize manualmente aqui para aumentar versão

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- Criando a ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Criando o Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 320, 0, 350)
Frame.Position = UDim2.new(0.5, -160, 0.5, -175)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true -- Permite arrastar o Frame

-- Versão label
local VersionLabel = Instance.new("TextLabel")
VersionLabel.Size = UDim2.new(1, 0, 0, 20)
VersionLabel.BackgroundTransparency = 1
VersionLabel.TextColor3 = Color3.new(1, 1, 1)
VersionLabel.Font = Enum.Font.SourceSansBold
VersionLabel.TextSize = 18
VersionLabel.Text = "Version: ".. tostring(Version)
VersionLabel.Parent = Frame

-- Base label e textbox
local BaseLabel = Instance.new("TextLabel")
BaseLabel.Size = UDim2.new(0, 50, 0, 25)
BaseLabel.Position = UDim2.new(0, 10, 0, 35)
BaseLabel.BackgroundTransparency = 1
BaseLabel.TextColor3 = Color3.new(1,1,1)
BaseLabel.Font = Enum.Font.SourceSans
BaseLabel.TextSize = 16
BaseLabel.Text = "Base:"
BaseLabel.Parent = Frame

local BaseTextBox = Instance.new("TextBox")
BaseTextBox.Size = UDim2.new(0, 150, 0, 25)
BaseTextBox.Position = UDim2.new(0, 70, 0, 35)
BaseTextBox.PlaceholderText = "Base1, Base2, Base3..."
BaseTextBox.ClearTextOnFocus = false
BaseTextBox.Text = ""
BaseTextBox.Parent = Frame

-- Character label e textbox
local CharacterLabel = Instance.new("TextLabel")
CharacterLabel.Size = UDim2.new(0, 70, 0, 25)
CharacterLabel.Position = UDim2.new(0, 10, 0, 70)
CharacterLabel.BackgroundTransparency = 1
CharacterLabel.TextColor3 = Color3.new(1,1,1)
CharacterLabel.Font = Enum.Font.SourceSans
CharacterLabel.TextSize = 16
CharacterLabel.Text = "Character:"
CharacterLabel.Parent = Frame

local CharacterTextBox = Instance.new("TextBox")
CharacterTextBox.Size = UDim2.new(0, 150, 0, 25)
CharacterTextBox.Position = UDim2.new(0, 90, 0, 70)
CharacterTextBox.PlaceholderText = "Select from list"
CharacterTextBox.ClearTextOnFocus = false
CharacterTextBox.Text = ""
CharacterTextBox.Parent = Frame

-- ScrollingFrame para lista dos NPCs
local NPCListFrame = Instance.new("ScrollingFrame")
NPCListFrame.Size = UDim2.new(0, 300, 0, 180)
NPCListFrame.Position = UDim2.new(0, 10, 0, 105)
NPCListFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- será atualizado depois
NPCListFrame.ScrollBarThickness = 6
NPCListFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
NPCListFrame.BorderSizePixel = 0
NPCListFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = NPCListFrame

-- Função pra preencher lista dos NPCs
local function UpdateNPCList()
	-- Limpa lista antiga
	for _, child in pairs(NPCListFrame:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	local count = 0
	for _, npc in pairs(Workspace:GetChildren()) do
		if npc.Name:match("^NPC_%d+$") then
			count = count + 1
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 18
			btn.Text = npc.Name
			btn.Parent = NPCListFrame

			btn.MouseButton1Click:Connect(function()
				CharacterTextBox.Text = npc.Name
			end)
		end
	end

	-- Atualiza tamanho do Canvas para scroll
	local totalSize = count * 34
	NPCListFrame.CanvasSize = UDim2.new(0, 0, 0, totalSize)
end

UpdateNPCList()

-- Botão Steal
local StealButton = Instance.new("TextButton")
StealButton.Size = UDim2.new(0, 100, 0, 35)
StealButton.Position = UDim2.new(0, 110, 1, -40)
StealButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
StealButton.TextColor3 = Color3.new(1,1,1)
StealButton.Font = Enum.Font.SourceSansBold
StealButton.TextSize = 20
StealButton.Text = "Steal"
StealButton.Parent = Frame

-- Botão fechar
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
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

	local base = Workspace:FindFirstChild(baseName)
	if not base then
		warn("Base '"..baseName.."' not found in Workspace.")
		return
	end

	local character = base:FindFirstChild(charName)
	if not character then
		warn("Character '"..charName.."' not found inside base '"..baseName.."'.")
		return
	end

	local args = {
		"Grab",
		character,
		false,
		true
	}
	ReplicatedStorage:WaitForChild("RemoveEvents"):WaitForChild("NPCDecision"):FireServer(unpack(args))
end)
