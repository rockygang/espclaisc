local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ESP = {}

local function createESP(player)
    if player == LocalPlayer then
        return
    end

    local function setup(character)
        if ESP[player] then
            ESP[player]:Destroy()
        end

        local folder = Instance.new("Folder")
        folder.Name = "ESP_" .. player.Name
        folder.Parent = Camera

        -- Caja alrededor del personaje
        local highlight = Instance.new("Highlight")
        highlight.Adornee = character
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
        highlight.Parent = folder

        -- Nombre y distancia
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = character:FindFirstChild("Head")
        billboard.Size = UDim2.fromOffset(200, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = folder

        local label = Instance.new("TextLabel")
        label.Size = UDim2.fromScale(1, 1)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.TextScaled = true
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard

        ESP[player] = folder

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character.Parent or not player.Parent then
                connection:Disconnect()
                folder:Destroy()
                ESP[player] = nil
                return
            end

            local root = character:FindFirstChild("HumanoidRootPart")
            local myCharacter = LocalPlayer.Character
            local myRoot = myCharacter and
                myCharacter:FindFirstChild("HumanoidRootPart")

            if root and myRoot then
                local distance = (root.Position - myRoot.Position).Magnitude
                label.Text = string.format(
                    "%s\n[%d studs]",
                    player.DisplayName,
                    distance
                )
            end
        end)
    end

    if player.Character then
        setup(player.Character)
    end

    player.CharacterAdded:Connect(setup)
end

for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

Players.PlayerAdded:Connect(createESP)

Players.PlayerRemoving:Connect(function(player)
    if ESP[player] then
        ESP[player]:Destroy()
        ESP[player] = nil
    end
end)
