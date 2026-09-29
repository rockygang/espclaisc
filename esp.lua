-- =================================================================
-- SISTEMA ESP OFUSCADO Y OPTIMIZADO
-- Ubicación: StarterPlayer -> StarterPlayerScripts -> LocalScript
-- =================================================================

-- Tecla para Activar / Desactivar el ESP
local TOGGLE_KEY = Enum.KeyCode.E 
local ESP_ENABLED = true

-- Tabla de resolución de nombres mediante codificación de bytes
local _0xMAP = {
	[1] = game:GetService(string.char(80, 108, 97, 121, 101, 114, 115)),            -- Players
	[2] = game:GetService(string.char(82, 117, 110, 83, 101, 114, 118, 105, 99, 101)),-- RunService
	[3] = game:GetService(string.char(85, 115, 101, 114, 73, 110, 112, 117, 116, 83, 101, 114, 118, 105, 99, 101)), -- UserInputService
	[4] = string.char(72, 117, 109, 97, 110, 111, 105, 100, 82, 111, 111, 116, 80, 97, 114, 116), -- HumanoidRootPart
	[5] = string.char(72, 117, 109, 97, 110, 111, 105, 100),                          -- Humanoid
	[6] = string.char(72, 101, 97, 100),                                             -- Head
	[7] = string.char(72, 105, 103, 104, 108, 105, 103, 104, 116),                    -- Highlight
	[8] = string.char(66, 105, 108, 108, 98, 111, 97, 114, 100, 71, 117, 105),        -- BillboardGui
	[9] = string.char(84, 101, 120, 116, 76, 97, 98, 101, 108)                         -- TextLabel
}

local _P = _0xMAP[1]
local _R = _0xMAP[2]
local _UIS = _0xMAP[3]
local _LP = _P.LocalPlayer

-- Bucle principal para la creación del ESP por jugador
local function _0xCreateESP(_p, _c)
	if _p == _LP then return end

	local _r = _c:WaitForChild(_0xMAP[4], 5)
	local _h = _c:WaitForChild(_0xMAP[5], 5)
	local _d = _c:WaitForChild(_0xMAP[6], 5)
	
	if not _r or not _h or not _d or _c:FindFirstChild("HL_X") then return end

	-- Highlight (Silueta a través de paredes)
	local _hl = Instance.new(_0xMAP[7])
	_hl.Name = "HL_X"
	_hl.Adornee = _c
	_hl.FillColor = Color3.fromRGB(255, 45, 45)
	_hl.FillTransparency = 0.55
	_hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	_hl.OutlineTransparency = 0
	_hl.Parent = _c

	-- BillboardGui (Texto de Nombre y Distancia)
	local _bg = Instance.new(_0xMAP[8])
	_bg.Name = "BG_X"
	_bg.Adornee = _d
	_bg.Size = UDim2.new(0, 100, 0, 40)
	_bg.StudsOffset = Vector3.new(0, 2, 0)
	_bg.AlwaysOnTop = true
	_bg.Parent = _c

	local _tl = Instance.new(_0xMAP[9])
	_tl.Size = UDim2.new(1, 0, 1, 0)
	_tl.BackgroundTransparency = 1
	_tl.TextColor3 = Color3.fromRGB(255, 255, 255)
	_tl.TextStrokeTransparency = 0
	_tl.TextSize = 13
	_tl.Font = Enum.Font.SourceSansBold
	_tl.Parent = _bg

	-- RenderStepped: Actualización en vivo
	local _conn
	_conn = _R.RenderStepped:Connect(function()
		-- Limpieza automática si el objetivo muere o desaparece
		if not _c or not _c.Parent or _h.Health <= 0 then
			_bg:Destroy()
			_hl:Destroy()
			_conn:Disconnect()
			return
		end

		-- Verificar si el ESP global está activado con la tecla
		if not ESP_ENABLED then
			_bg.Enabled = false
			_hl.Enabled = false
			return
		end

		-- Comprobación de Equipos (Filtro Anti-Aliados)
		if _p.Team and _LP.Team and _p.Team == _LP.Team then
			_bg.Enabled = false
			_hl.Enabled = false
			return
		end

		-- Comprobación de Distancia
		if _LP.Character and _LP.Character:FindFirstChild(_0xMAP[4]) then
			local _dist = (_LP.Character[_0xMAP[4]].Position - _r.Position).Magnitude
			
			if _dist > 350 then
				_bg.Enabled = false
				_hl.Enabled = false
			else
				_bg.Enabled = true
				_hl.Enabled = true
				_tl.Text = string.format("%s\n[%.0fm]", _p.Name, _dist)
			end
		end
	end)
end

-- Inicialización para jugadores
local function _0xInitPlayer(_player)
	_player.CharacterAdded:Connect(function(_char)
		_0xCreateESP(_player, _char)
	end)
	if _player.Character then
		task.spawn(function()
			_0xCreateESP(_player, _player.Character)
		end)
	end
end

-- Asignación a jugadores actuales y futuros
for _, _v in ipairs(_P:GetPlayers()) do
	_0xInitPlayer(_v)
end

_P.PlayerAdded:Connect(_0xInitPlayer)

-- Atajo de Tecla para Activar/Desactivar (Toggle)
_UIS.InputBegan:Connect(function(_input, _gameProcessed)
	if _gameProcessed then return end -- Ignora si estás escribiendo en el chat
	if _input.KeyCode == TOGGLE_KEY then
		ESP_ENABLED = not ESP_ENABLED
	end
end)
