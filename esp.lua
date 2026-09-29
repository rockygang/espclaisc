local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable de control
local espEnabled = false

-- Crear la Interfaz
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Crear el Botón
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ESPButton"
toggleButton.Size = UDim2.new(0, 150, 0, 50)
toggleButton.Position = UDim2.new(0.05, 0, 0.4, 0)
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Rojo (Desactivado)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "ESP: OFF"
toggleButton.Parent = screenGui

-- Función para agregar Highlight a un personaje
local function applyESP(character)
    if character and not character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Color interior
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Color del borde
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end
end

-- Función para remover Highlight de un personaje
local function removeESP(character)
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

-- Actualizar el estado de todos los jugadores
local function updateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if espEnabled then
                applyESP(player.Character)
            else
                removeESP(player.Character)
            end
        end
    end
end

-- Manejar eventos de aparición de jugadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled and player ~= LocalPlayer then
            character:WaitForChild("HumanoidRootPart")
            applyESP(character)
        end
    end)
end)

-- Evento de clic en el botón
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        toggleButton.Text = "ESP: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50) -- Verde (Activado)
    else
        toggleButton.Text = "ESP: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50) -- Rojo (Desactivado)
    end
    
    updateESP()
end)
