--[[
beat a gubby
]]


-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- PlayerData
local PlayerData = ReplicatedStorage:WaitForChild("PlayerData"):WaitForChild(LocalPlayer.Name)
local NumOfGubbies = PlayerData.Settings.NumOfGubbies
local ZeroGravity = PlayerData.Settings.ZeroGravity

-- Remotes
local VoidDamage = ReplicatedStorage.Networking.Server.RemoteEvents.DamageEvents.VoidDamage
local GasUse = ReplicatedStorage.Networking.Server.RemoteEvents.AmmoEvents.GasUse

-- Guardar função original do GasUse
local OriginalFireServer = GasUse.FireServer

-- Variável para controle do bloqueio
local GasUseBlocked = false

-- Função BlockRemote segura para GasUse
local function BlockGasUse(block)
    GasUseBlocked = block
    if GasUseBlocked then
        GasUse.FireServer = function(...)
            pcall(function()
                warn("Bloqueado: alguém tentou usar GasUse!")
            end)
        end
    else
        GasUse.FireServer = OriginalFireServer
    end
end

-- Rayfield
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
   Name = "Beat a Gubby",
   LoadingTitle = "Loading...",
   LoadingSubtitle = "",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "BAG",
      FileName = "Beat A Gubby"
   }
})

-- Aba principal
local Tab = Window:CreateTab("Main", nil)

-- Seção PlayerData
Tab:CreateSection("PlayerData")

-- Input editável para NumOfGubbies
Tab:CreateInput({
    Name = "Num Of Gubbies",
    PlaceholderText = tostring(NumOfGubbies.Value),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local Numero = tonumber(Text)
        if Numero then
            NumOfGubbies.Value = Numero
        end
    end,
})

-- Toggle editável para ZeroGravity
Tab:CreateToggle({
    Name = "Zero Gravity",
    CurrentValue = ZeroGravity.Value,
    Flag = "ZeroGravityToggle",
    Callback = function(Value)
        ZeroGravity.Value = Value
    end,
})

-- Variáveis de controle
local FarmAtivo = false

-- Toggle Farm
Tab:CreateToggle({
   Name = "Farm (void Type)",
   CurrentValue = false,
   Flag = "FarmVoid",
   Callback = function(Value)
      FarmAtivo = Value
      if FarmAtivo then
         task.spawn(function()
            while FarmAtivo do
               local args = {
                  Vector3.new(-6.938813209533691, 3.093212842941284, -0.00042029828182421625)
               }
               VoidDamage:FireServer(unpack(args))
               task.wait() -- executa a cada frame
            end
         end)
      end
   end,
})

-- Toggle AntigasUsage (BlockRemote seguro)
Tab:CreateToggle({
   Name = "Anti Gas Usage (RemoteBlock)",
   CurrentValue = false,
   Flag = "GasToggle",
   Callback = function(Value)
      pcall(function()
          BlockGasUse(Value)
      end)
   end,
})
