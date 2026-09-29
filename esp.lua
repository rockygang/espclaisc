local _1 = game:GetService("Players")
local _2 = _1.LocalPlayer
local _3 = false

local _4 = Instance.new("ScreenGui")
_4.Name = "\0"
_4.ResetOnSpawn = false
_4.Parent = _2:WaitForChild("PlayerGui")

local _5 = Instance.new("Frame")
_5.Size = UDim2.new(0, 160, 0, 50)
_5.Position = UDim2.new(0.5, -80, 0, 10)
_5.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
_5.BorderSizePixel = 0
_5.Parent = _4

local _6 = Instance.new("UICorner")
_6.CornerRadius = UDim.new(0, 8)
_6.Parent = _5

local _7 = Instance.new("TextButton")
_7.Size = UDim2.new(0, 140, 0, 34)
_7.Position = UDim2.new(0, 10, 0, 8)
_7.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
_7.TextColor3 = Color3.fromRGB(255, 255, 255)
_7.TextSize = 14
_7.Font = Enum.Font.SourceSansBold
_7.Text = "ESP: OFF"
_7.Parent = _5

local _8 = Instance.new("UICorner")
_8.CornerRadius = UDim.new(0, 6)
_8.Parent = _7

local function _9(_a)
    if _a and not _a:FindFirstChild("\1") then
        local _b = Instance.new("Highlight")
        _b.Name = "\1"
        _b.FillColor = Color3.fromRGB(255, 0, 0)
        _b.OutlineColor = Color3.fromRGB(255, 255, 255)
        _b.FillTransparency = 0.5
        _b.OutlineTransparency = 0
        _b.Adornee = _a
        _b.Parent = _a
    end
end

local function _c(_a)
    if _a then
        local _b = _a:FindFirstChild("\1")
        if _b then _b:Destroy() end
    end
end

local function _d()
    for _, _e in ipairs(_1:GetPlayers()) do
        if _e ~= _2 and _e.Character then
            if _3 then
                _9(_e.Character)
            else
                _c(_e.Character)
            end
        end
    end
end

_1.PlayerAdded:Connect(function(_e)
    _e.CharacterAdded:Connect(function(_a)
        if _3 and _e ~= _2 then
            _a:WaitForChild("HumanoidRootPart")
            _9(_a)
        end
    end)
end)

_7.MouseButton1Click:Connect(function()
    _3 = not _3
    if _3 then
        _7.Text = "ESP: ON"
        _7.BackgroundColor3 = Color3.fromRGB(39, 174, 96)
    else
        _7.Text = "ESP: OFF"
        _7.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    end
    _d()
end)
