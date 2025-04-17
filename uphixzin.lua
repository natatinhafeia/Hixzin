-- Aimbot Simples com ESP para Cabeça

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local AimbotEnabled = true  -- Aimbot ativado por padrão
local ESPEnabled = true  -- ESP ativado por padrão
local TargetPlayer = nil

-- Função para desenhar o ESP (caixa ao redor do alvo)
local function DrawESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        local screenPosition, onScreen = Camera:WorldToScreenPoint(rootPart.Position)
        if onScreen then
            -- Criar um quadrado para o ESP
            local box = Instance.new("Frame")
            box.Size = UDim2.new(0, 50, 0, 50)
            box.Position = UDim2.new(0, screenPosition.X - 25, 0, screenPosition.Y - 25)
            box.BackgroundColor3 = Color3.fromRGB(255, 0, 0)  -- Vermelho
            box.BackgroundTransparency = 0.7  -- Transparente
            box.BorderSizePixel = 2
            box.Parent = game.CoreGui

            -- Remover o ESP após um tempo
            game:GetService("Debris"):AddItem(box, 0.1)
        end
    end
end

-- Função para encontrar o melhor alvo (puxando a mira para a cabeça)
local function FindTarget()
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local target = player.Character:FindFirstChild("Head")  -- Mira para a cabeça
            if target then
                local distance = (Camera.CFrame.Position - target.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    TargetPlayer = player
                end
            end
        end
    end
end

-- Função de Aimbot para puxar a mira
local function Aimbot()
    if AimbotEnabled and TargetPlayer and TargetPlayer.Character then
        local target = TargetPlayer.Character:FindFirstChild("Head")  -- Foca na cabeça
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)  -- Mira diretamente para a cabeça
        end
    end
end

-- Loop para encontrar o alvo e ativar o Aimbot e ESP
while true do
    wait(0.1)
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                DrawESP(player)
            end
        end
    end
    FindTarget()
    Aimbot()
end
