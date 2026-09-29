local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ENEMY_COLOR = Color3.fromRGB(255, 50, 50)   -- Rojo para enemigos
local ALLY_COLOR = Color3.fromRGB(50, 255, 50)    -- Verde para aliados (opcional)

local function createESP(player, character)
	if player == LocalPlayer then return end

	local rootPart = character:WaitForChild("HumanoidRootPart", 5)
	local humanoid = character:WaitForChild("Humanoid", 5)
	local head = character:WaitForChild("Head", 5)
	
	if not rootPart or not humanoid or not head then return end
	if character:FindFirstChild("HighlightESP") then return end

	-- Comprobar si son del mismo equipo (si tu juego usa Teams)
	local function updateTeamColor()
		if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
			return false -- Es aliado, puedes decidir no mostrarlo o pintarlo diferente
		end
		return true -- Es enemigo
	end

	-- Highlight (Silueta)
	local highlight = Instance.new("Highlight")
	highlight.Name = "HighlightESP"
	highlight.Adornee = character
	highlight.FillColor = ENEMY_COLOR
	highlight.FillTransparency = 0.6 -- Más transparente para que sea sutil
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0.5
	highlight.Parent = character

	-- BillboardGui (Texto)
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "InfoESP"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = character

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextStrokeTransparency = 0
	textLabel.TextSize = 13
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = billboard

	-- Bucle de actualización
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if not character or not character.Parent or humanoid.Health <= 0 then
			billboard:Destroy()
			highlight:Destroy()
			connection:Disconnect()
			return
		end

		-- Opcional: Ocultar si están muy lejos para mejorar rendimiento
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
			
			if distance > 300 then -- Si está a más de 300 studs, se oculta para no saturar la pantalla
				billboard.Enabled = false
				highlight.Enabled = false
			else
				billboard.Enabled = true
				highlight.Enabled = true
				textLabel.Text = string.format("%s\n[%.0fm]", player.Name, distance)
			end
		end
	end)
end

-- Inicialización para jugadores actuales y futuros
for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(function(char)
		createESP(player, char)
	end)
	if player.Character then
		task.spawn(function()
			createESP(player, player.Character)
		end)
	end
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(char)
		createESP(player, char)
	end)
end)
