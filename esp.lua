local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Variable de estado del ESP
local espEnabled = false

-- 1. Crear la Interfaz (ScreenGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESPGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- 2. Crear el Recuadro Contenedor (Arriba en el centro)
local topContainer = Instance.new("Frame")
topContainer.Name = "TopContainer"
topContainer.Size = UDim2.new(0, 160, 0, 50)
topContainer.Position = UDim2.new(0.5, -80, 0, 10) -- Centrado arriba
topContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topContainer.BorderSizePixel = 0
topContainer.Parent = screenGui

-- Bordes redondeados para el recuadro
local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = topContainer

-- 3. Crear el Botón Verde Chico dentro del recuadro
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ESPToggleButton"
toggleButton.Size = UDim2.new(0, 140, 0, 34)
toggleButton.Position = UDim2.new(0, 10, 0, 8)
toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Color verde
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.Text = "ESP: OFF"
toggleButton.Parent = topContainer

-- Bordes redondeados para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 6)
buttonCorner.Parent = toggleButton

-- 4. Funciones para aplicar y quitar el ESP (Highlight)
local function applyESP(character)
    if character and not character:FindFirstChild("ESPHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.Adornee = character
        highlight.Parent = character
    end
end

local function removeESP(character)
    if character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

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

-- 5. Manejar nuevos jugadores
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled and player ~= LocalPlayer then
            character:WaitForChild("HumanoidRootPart")
            applyESP(character)
        end
    end)
end)

-- 6. Evento de Clic en el Botón Verde
toggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        toggleButton.Text = "ESP: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(39, 174, 96) -- Verde más oscuro al activar
    else
        toggleButton.Text = "ESP: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113) -- Verde claro por defecto
    end
    
    updateESP()
end)
