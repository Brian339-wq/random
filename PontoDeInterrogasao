-- Remote Spy Avançado com Interface Completa
-- Requer executor com hookmetamethod, getnamecallmethod e setclipboard
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local remoteLogs = {}

-- Interface
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "RemoteSpyUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 700, 0, 420)
frame.Position = UDim2.new(0.5, -350, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -100, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Remote Spy"
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1

-- Fechar
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -35, 0, 0)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Filtro
local filter = Instance.new("TextBox", frame)
filter.Size = UDim2.new(0, 100, 0, 25)
filter.Position = UDim2.new(0, 10, 0, 35)
filter.PlaceholderText = "Filter: All / Fire / Invoke"
filter.Text = ""
filter.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
filter.TextColor3 = Color3.fromRGB(255, 255, 255)
filter.Font = Enum.Font.Gotham
filter.TextSize = 14
Instance.new("UICorner", filter).CornerRadius = UDim.new(0, 6)

-- Lista de remotes (scrolling)
local listFrame = Instance.new("ScrollingFrame", frame)
listFrame.Size = UDim2.new(0, 220, 1, -70)
listFrame.Position = UDim2.new(0, 10, 0, 70)
listFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
listFrame.BorderSizePixel = 0
listFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
listFrame.ScrollBarThickness = 8
listFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
listFrame.CanvasPosition = Vector2.new(0, 0)

-- Visualizador de código (scrolling)
local codeBox = Instance.new("TextBox", frame)
codeBox.Size = UDim2.new(1, -250, 1, -110)
codeBox.Position = UDim2.new(0, 240, 0, 70)
codeBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
codeBox.TextColor3 = Color3.fromRGB(200, 255, 200)
codeBox.TextXAlignment = Enum.TextXAlignment.Left
codeBox.TextYAlignment = Enum.TextYAlignment.Top
codeBox.TextWrapped = false
codeBox.TextEditable = false
codeBox.MultiLine = true
codeBox.Font = Enum.Font.Code
codeBox.TextSize = 14
codeBox.ClearTextOnFocus = false
codeBox.Text = "-- Select a remote from the list"
codeBox.AutomaticSize = Enum.AutomaticSize.Y

-- Botão copiar código
local copyButton = Instance.new("TextButton", frame)
copyButton.Size = UDim2.new(0, 100, 0, 30)
copyButton.Position = UDim2.new(0, 240, 1, -35)
copyButton.Text = "Copy Code"
copyButton.Font = Enum.Font.GothamBold
copyButton.TextSize = 14
copyButton.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", copyButton).CornerRadius = UDim.new(0, 6)

copyButton.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(codeBox.Text)
	end
end)

-- Formatador
local function formatArg(arg)
	if typeof(arg) == "string" then
		return string.format("%q", arg)
	elseif typeof(arg) == "Instance" then
		return string.format("game.%s", arg:GetFullName())
	elseif typeof(arg) == "Vector3" then
		return string.format("Vector3.new(%s,%s,%s)", arg.X, arg.Y, arg.Z)
	elseif typeof(arg) == "CFrame" then
		return string.format("CFrame.new(%s,%s,%s)", arg.Position.X, arg.Position.Y, arg.Position.Z)
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

local function clearList()
	for _, child in ipairs(listFrame:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
end

local function refreshList()
	clearList()
	local y = 0
	for id, data in pairs(remoteLogs) do
		if filter.Text == "" or
		   (filter.Text:lower() == "fire" and data.Method == "FireServer") or
		   (filter.Text:lower() == "invoke" and data.Method == "InvokeServer") or
		   (filter.Text:lower() == "all") then

			local btn = Instance.new("TextButton", listFrame)
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.Position = UDim2.new(0, 5, 0, y)
			btn.Text = data.Remote.Name
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.TextXAlignment = Enum.TextXAlignment.Left
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

			btn.MouseButton1Click:Connect(function()
				codeBox.Text = "-- " .. data.Remote.Name .. "\n" .. data.Script
			end)

			y += 35
		end
	end
	listFrame.CanvasSize = UDim2.new(0, 0, 0, y + 10)
end

filter.FocusLost:Connect(refreshList)

-- Hook
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
