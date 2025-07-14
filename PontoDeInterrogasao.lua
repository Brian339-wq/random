-- Remote Spy Avançado com UI Reabrível e Cabeçalho Arrastável

-- ⚠️ Requer executor avançado com hookmetamethod, getnamecallmethod e setclipboard
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local remoteLogs = {}

-- === FUNÇÕES DE FORMATAÇÃO === --
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

-- === GUI SETUP === --
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "RemoteSpyUI"
gui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 550, 0, 340)
frame.Position = UDim2.new(0.5, -275, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

-- Header (para arrastar)
local header = Instance.new("TextLabel", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
header.Text = " Remote Spy"
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.TextColor3 = Color3.fromRGB(255, 255, 255)
header.TextXAlignment = Enum.TextXAlignment.Left
header.Name = "Header"

-- Drag apenas pela parte de cima
local dragging, offset
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		offset = input.Position - frame.Position
	end
end)
header.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		frame.Position = UDim2.new(0, input.Position.X - offset.X, 0, input.Position.Y - offset.Y)
	end
end)

-- Botão fechar
local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -30, 0, 0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

-- Botão mini reabrível
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

miniBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	miniBtn.Visible = false
end)

-- Tornar botão mini arrastável
local draggingMini, offsetMini
miniBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = true
		offsetMini = input.Position - miniBtn.Position
	end
end)
miniBtn.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingMini = false
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if draggingMini and input.UserInputType == Enum.UserInputType.MouseMovement then
		miniBtn.Position = UDim2.new(0, input.Position.X - offsetMini.X, 0, input.Position.Y - offsetMini.Y)
	end
end)

close.MouseButton1Click:Connect(function()
	frame.Visible = false
	miniBtn.Visible = true
end)

-- Filtro
local filter = Instance.new("TextBox", frame)
filter.Size = UDim2.new(0, 150, 0, 25)
filter.Position = UDim2.new(0, 10, 0, 35)
filter.PlaceholderText = "Filter: Fire / Invoke / All"
filter.Text = ""
filter.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
filter.TextColor3 = Color3.new(1, 1, 1)
filter.Font = Enum.Font.Gotham
filter.TextSize = 13
Instance.new("UICorner", filter).CornerRadius = UDim.new(0, 6)

-- Lista de remotes
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(0, 200, 1, -80)
listFrame.Position = UDim2.new(0, 10, 0, 70)
listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Visualizador de código
local codeBox = Instance.new("TextBox", frame)
codeBox.Size = UDim2.new(1, -230, 1, -110)
codeBox.Position = UDim2.new(0, 220, 0, 70)
codeBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
codeBox.TextColor3 = Color3.fromRGB(180, 255, 180)
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.TextEditable = false
codeBox.ClearTextOnFocus = false
codeBox.TextWrapped = false
codeBox.MultiLine = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 13
codeBox.Text = "-- Select a remote"
codeBox.AutomaticSize = Enum.AutomaticSize.Y

-- Copiar botão
local copy = Instance.new("TextButton", frame)
copy.Size = UDim2.new(0, 100, 0, 25)
copy.Position = UDim2.new(0, 220, 1, -35)
copy.Text = "Copy Code"
copy.Font = Enum.Font.GothamBold
copy.TextSize = 13
copy.BackgroundColor3 = Color3.fromRGB(50, 150, 75)
copy.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 6)

copy.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(codeBox.Text)
	end
end)

-- Atualizar lista
local function refreshList()
	for _, c in ipairs(listFrame:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	local y = 0
	for id, data in pairs(remoteLogs) do
		if filter.Text == "" or filter.Text:lower() == "all" or data.Method:lower():find(filter.Text:lower()) then
			local btn = Instance.new("TextButton", listFrame)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Position = UDim2.new(0, 5, 0, y)
			btn.Text = data.Remote.Name
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 13
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
				codeBox.Text = "-- " .. data.Method .. "\n" .. data.Script
			end)

			y += 35
		end
	end
	listFrame.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

filter.FocusLost:Connect(refreshList)

-- Hook de chamada remota
local mt = getrawmetatable(game)
setreadonly(mt, false)
local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
	local method = getnamecallmethod()
	if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
		local args = {...}
		local id = self:GetFullName() .. "|" .. method
		if not remoteLogs[id] then
			remoteLogs[id] = {
				Remote = self,
				Method = method,
				Script = generateScript(self, method, args)
			}
			refreshList()
		end
	end
	return old(self, ...)
end)

setreadonly(mt, true)
