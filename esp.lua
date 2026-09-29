local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Configuración de colores
local ENEMY_COLOR = Color3.fromRGB(255, 50, 50) -- Rojo para los enemigos

local function createESP(character)
	-- Esperar a que el personaje tenga RootPart y Humanoid
	local rootPart = character:WaitForChild("HumanoidRootPart", 5)
	local humanoid = character:WaitForChild("Humanoid", 5)
	local head = character:WaitForChild("Head", 5)
	
	if not rootPart or not humanoid or not head then return end

	-- Evitar duplicados si ya tiene ESP
	if character:FindFirstChild("HighlightESP") then return end

	-- 1. Crear el Highlight (resalta el cuerpo a través de las paredes)
	local highlight = Instance.new("Highlight")
	highlight.Name = "HighlightESP"
	highlight.Adornee = character
	highlight.FillColor = ENEMY_COLOR
	highlight.FillTransparency = 0.5
	highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	highlight.OutlineTransparency = 0
	highlight.Parent = character

	-- 2. Crear BillboardGui para mostrar el Nombre y Distancia
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
	textLabel.TextStrokeTransparency = 0 -- Borde negro para que se lea bien
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.Parent = billboard

	-- Actualizar la distancia en tiempo real
	local connection
	connection = RunService.RenderStepped:Connect(function()
		if not character or not character.Parent or humanoid.Health <= 0 then
			billboard:Destroy()
			highlight:Destroy()
			connection:Disconnect()
			return
		end

		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
			textLabel.Text = string.format("%s\n[%.0fm]", character.Name, distance)
		end
	end)
end

-- Función para manejar jugadores que ya están en el juego
local function onPlayerAdded(player)
	if player == LocalPlayer then return end

	player.CharacterAdded:Connect(function(character)
		createESP(character)
	end)

	if player.Character then
		task.spawn(function()
			createESP(player.Character)
		end)
	end
end

-- Conectar a todos los jugadores actuales y futuros
for _, player in ipairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerAdded:Connect(onPlayerAdded)
