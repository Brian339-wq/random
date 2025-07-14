-- Remote Spy GUI v1.2
-- Interface arrastável, botão mini arrastável, tamanho ajustável via dropdown
-- Requer executor com suporte a hookmetamethod, getnamecallmethod, loadstring, setclipboard

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local remoteLogs = {}

-- Helper: formatar argumentos para string Lua
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

-- Aplica tamanho na frame principal
local function applySize(size, frame)
	if size == "Small" then
		frame.Size = UDim2.new(0, 400, 0, 280)
	elseif size == "Medium" then
		frame.Size = UDim2.new(0, 550, 0, 360)
	elseif size == "Large" then
		frame.Size = UDim2.new(0, 700, 0, 440)
	end
end

-- Cria GUI
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

-- Drag logic UI
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

local function applySize(size)
	if size == "Small" then
		frame.Size = UDim2.new(0, 400, 0, 280)
	elseif size == "Medium" then
		frame.Size = UDim2.new(0, 550, 0, 360)
	elseif size == "Large" then
		frame.Size = UDim2.new(0, 700, 0, 440)
	end
	-- Recentralizar depois da mudança
	frame.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2, 0.5, -frame.Size.Y.Offset / 2)
end

dropdown.MouseButton1Click:Connect(function()
	sizeIndex += 1
	if sizeIndex > #sizes then sizeIndex = 1 end
	local newSize = sizes[sizeIndex]
	dropdown.Text = "Size: " .. newSize
	applySize(newSize)
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

-- Filter box
local filter = Instance.new("TextBox", frame)
filter.Size = UDim2.new(0, 150, 0, 25)
filter.Position = UDim2.new(0, 120, 0, 35)
filter.PlaceholderText = "Filter: Fire / Invoke / All"
filter.Text = ""
filter.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
filter.TextColor3 = Color3.new(1, 1, 1)
filter.Font = Enum.Font.Gotham
filter.TextSize = 13
Instance.new("UICorner", filter).CornerRadius = UDim.new(0, 6)

-- List frame (remotes)
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(0, 200, 1, -90)
listFrame.Position = UDim2.new(0, 10, 0, 70)
listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listFrame.ScrollBarThickness = 6
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Container para código com scrollbar
local codeScroll = Instance.new("ScrollingFrame", frame)
codeScroll.Size = UDim2.new(1, -230, 1, -130)
codeScroll.Position = UDim2.new(0, 220, 0, 70)
codeScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
codeScroll.BorderSizePixel = 0
codeScroll.CanvasSize = UDim2.new(0, 0, 10, 0) -- altura grande para scroll
codeScroll.ScrollBarThickness = 8
codeScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- TextBox para mostrar código dentro do ScrollingFrame
local codeBox = Instance.new("TextBox", codeScroll)
codeBox.Size = UDim2.new(1, 0, 0, 600) -- altura fixa (pode ajustar)
codeBox.Position = UDim2.new(0, 0, 0, 0)
codeBox.BackgroundTransparency = 1
codeBox.TextColor3 = Color3.fromRGB(180, 255, 180)
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.TextEditable = false
codeBox.ClearTextOnFocus = false
codeBox.TextWrapped = true -- quebra de linha ativada
codeBox.MultiLine = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 13
codeBox.Text = "-- Select a remote"

-- Copy button
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

-- Execute button
local runBtn = Instance.new("TextButton", frame)
runBtn.Size = UDim2.new(0, 100, 0, 25)
runBtn.Position = UDim2.new(0, 330, 1, -35)
runBtn.Text = "Execute"
runBtn.Font = Enum.Font.GothamBold
runBtn.TextSize = 13
runBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
runBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 6)
runBtn.MouseButton1Click:Connect(function()
	local code = codeBox.Text
	if code and code:match("game") and loadstring then
		pcall(function()
			loadstring(code)()
		end)
	end
end)

-- Atualiza lista de remotes com filtro
local function refreshList()
	for _, c in ipairs(listFrame:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end

	local y = 0
	for id, data in pairs(remoteLogs) do
		-- filtro: vazio, all, fire, invoke
		local filterText = filter.Text:lower()
		if filterText == "" or filterText == "all" or data.Method:lower():find(filterText) then
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

-- Hook __namecall para capturar remotes
local mt = getrawmetatable(game)
setreadonly(mt, false)
local oldNamecall = mt.__namecall

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
	return oldNamecall(self, ...)
end)

setreadonly(mt, true)
