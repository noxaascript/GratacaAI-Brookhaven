--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.3.0.WPPIDXM — MULTI-BLOCK MESH      ║
    ║  Creator: Yang Mulia KAREEMXD | GratacaAI                                    ║
    ║  Features: B2-Spirit | Leviathan | Tornado | Blood Wings | Dragon | Home     ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]]

--// SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

--// GRATACAAI UI CONFIG
local GRATACA_CONFIG = {
    Title = "GRATACAAI v3.0.3.0.WPPIDXM",
    Subtitle = "Yang Mulia KAREEMXD",
    Width = 380,
    Height = 500,
    MinimizedHeight = 45,
    PrimaryColor = Color3.fromRGB(15, 15, 15),
    SecondaryColor = Color3.fromRGB(30, 30, 30),
    AccentColor = Color3.fromRGB(220, 50, 50),
    GlowColor = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 12),
    AnimationSpeed = 0.4
}

--// ═══════════════════════════════════════════════════════════════════════════
--// UI CREATION
--// ═══════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaAIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local MainFrame = Instance.new("Frame")
MainFrame.Name = "GratacaMain"
MainFrame.Size = UDim2.new(0, GRATACA_CONFIG.Width, 0, GRATACA_CONFIG.Height)
MainFrame.Position = UDim2.new(0.5, -GRATACA_CONFIG.Width/2, 0.5, -GRATACA_CONFIG.Height/2)
MainFrame.BackgroundColor3 = GRATACA_CONFIG.PrimaryColor
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = GRATACA_CONFIG.CornerRadius
MainCorner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = GRATACA_CONFIG.AccentColor
Stroke.Thickness = 1.5
Stroke.Transparency = 0.7
Stroke.Parent = MainFrame

local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 60, 1, 60)
Glow.Position = UDim2.new(0, -30, 0, -30)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://4996891970"
Glow.ImageColor3 = GRATACA_CONFIG.GlowColor
Glow.ImageTransparency = 0.85
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(20, 20, 280, 280)
Glow.Parent = MainFrame

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = GRATACA_CONFIG.SecondaryColor
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.6, 0, 1, 0)
TitleText.Position = UDim2.new(0, 12, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = GRATACA_CONFIG.Title
TitleText.TextColor3 = GRATACA_CONFIG.AccentColor
TitleText.Font = GRATACA_CONFIG.Font
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubTitleText = Instance.new("TextLabel")
SubTitleText.Size = UDim2.new(0.6, 0, 0, 16)
SubTitleText.Position = UDim2.new(0, 12, 0, 26)
SubTitleText.BackgroundTransparency = 1
SubTitleText.Text = GRATACA_CONFIG.Subtitle
SubTitleText.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitleText.Font = Enum.Font.Gotham
SubTitleText.TextSize = 9
SubTitleText.TextXAlignment = Enum.TextXAlignment.Left
SubTitleText.Parent = TitleBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 28, 0, 28)
MinimizeBtn.Position = UDim2.new(1, -65, 0, 6)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -34, 0, 6)
CloseBtn.BackgroundColor3 = GRATACA_CONFIG.AccentColor
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ContentScroll"
ScrollFrame.Size = UDim2.new(1, -16, 1, -52)
ScrollFrame.Position = UDim2.new(0, 8, 0, 44)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 3
ScrollFrame.ScrollBarImageColor3 = GRATACA_CONFIG.AccentColor
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingBottom = UDim.new(0, 12)
UIPadding.PaddingLeft = UDim.new(0, 4)
UIPadding.PaddingRight = UDim.new(0, 4)
UIPadding.Parent = ScrollFrame

--// DRAG SYSTEM
local dragging = false
local dragOffset = Vector2.new(0, 0)

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = MainFrame.AbsolutePosition
        dragOffset = mousePos - framePos
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        local mousePos = UserInputService:GetMouseLocation()
        local newPos = mousePos - dragOffset
        MainFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
    end
end)

--// MINIMIZE
local isMinimized = false
local originalSize = UDim2.new(0, GRATACA_CONFIG.Width, 0, GRATACA_CONFIG.Height)
local minimizedSize = UDim2.new(0, GRATACA_CONFIG.Width, 0, GRATACA_CONFIG.MinimizedHeight)

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = minimizedSize
        }):Play()
        
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        TweenService:Create(ScrollFrame, TweenInfo.new(0.2), {ScrollBarImageTransparency = 1}):Play()
        
        MinimizeBtn.Text = "+"
        
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                for _, grandChild in ipairs(child:GetChildren()) do
                    if grandChild:IsA("TextLabel") or grandChild:IsA("TextButton") then
                        TweenService:Create(grandChild, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                    end
                end
            end
        end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
        
        TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 8}):Play()
        TweenService:Create(ScrollFrame, TweenInfo.new(0.3), {ScrollBarImageTransparency = 0}):Play()
        
        MinimizeBtn.Text = "−"
        
        for _, child in ipairs(ScrollFrame:GetChildren()) do
            if child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                for _, grandChild in ipairs(child:GetChildren()) do
                    if grandChild:IsA("TextLabel") then
                        TweenService:Create(grandChild, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                    elseif grandChild:IsA("TextButton") then
                        TweenService:Create(grandChild, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
                        TweenService:Create(grandChild, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
                    end
                end
            end
        end
    end
end)

--// CLOSE
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + GRATACA_CONFIG.Width/2, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + GRATACA_CONFIG.Height/2),
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
    
    wait(0.35)
    ScreenGui:Destroy()
    Blur:Destroy()
end)

--// HOVER EFFECTS
MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundColor3 = GRATACA_CONFIG.AccentColor}):Play()
end)

--// FEATURE CARD CREATOR
local function CreateFeatureCard(title, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 100)
    Card.BackgroundColor3 = GRATACA_CONFIG.SecondaryColor
    Card.BorderSizePixel = 0
    Card.BackgroundTransparency = 0
    Card.LayoutOrder = #ScrollFrame:GetChildren()
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 10)
    CardCorner.Parent = Card
    
    local CardStroke = Instance.new("UIStroke")
    CardStroke.Color = Color3.fromRGB(60, 60, 60)
    CardStroke.Thickness = 1
    CardStroke.Transparency = 0.5
    CardStroke.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Name = "CardTitle"
    CardTitle.Size = UDim2.new(1, -16, 0, 24)
    CardTitle.Position = UDim2.new(0, 10, 0, 8)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = "🔥 " .. title
    CardTitle.TextColor3 = GRATACA_CONFIG.AccentColor
    CardTitle.Font = GRATACA_CONFIG.Font
    CardTitle.TextSize = 13
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local CardDesc = Instance.new("TextLabel")
    CardDesc.Name = "CardDesc"
    CardDesc.Size = UDim2.new(1, -16, 0, 32)
    CardDesc.Position = UDim2.new(0, 10, 0, 34)
    CardDesc.BackgroundTransparency = 1
    CardDesc.Text = description
    CardDesc.TextColor3 = Color3.fromRGB(180, 180, 180)
    CardDesc.Font = Enum.Font.Gotham
    CardDesc.TextSize = 10
    CardDesc.TextWrapped = true
    CardDesc.TextXAlignment = Enum.TextXAlignment.Left
    CardDesc.Parent = Card
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Name = "ToggleBtn"
    ToggleBtn.Size = UDim2.new(0, 100, 0, 28)
    ToggleBtn.Position = UDim2.new(1, -108, 0, 66)
    ToggleBtn.BackgroundColor3 = GRATACA_CONFIG.AccentColor
    ToggleBtn.Text = "AKTIFKAN"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = GRATACA_CONFIG.Font
    ToggleBtn.TextSize = 11
    ToggleBtn.AutoButtonColor = false
    ToggleBtn.Parent = Card
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn
    
    local isActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        
        if isActive then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 200, 50),
                Size = UDim2.new(0, 104, 0, 30)
            }):Play()
            ToggleBtn.Text = "MATIKAN"
            
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(50, 200, 50),
                Transparency = 0
            }):Play()
        else
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = GRATACA_CONFIG.AccentColor,
                Size = UDim2.new(0, 100, 0, 28)
            }):Play()
            ToggleBtn.Text = "AKTIFKAN"
            
            TweenService:Create(CardStroke, TweenInfo.new(0.3), {
                Color = Color3.fromRGB(60, 60, 60),
                Transparency = 0.5
            }):Play()
        end
        
        callback(isActive)
    end)
    
    Card.MouseEnter:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
        TweenService:Create(CardStroke, TweenInfo.new(0.25), {Transparency = 0.2}):Play()
    end)
    
    Card.MouseLeave:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.25), {BackgroundColor3 = GRATACA_CONFIG.SecondaryColor}):Play()
        TweenService:Create(CardStroke, TweenInfo.new(0.25), {Transparency = 0.5}):Play()
    end)
    
    ToggleBtn.MouseEnter:Connect(function()
        TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 104, 0, 30)}):Play()
    end)
    ToggleBtn.MouseLeave:Connect(function()
        if not isActive then
            TweenService:Create(ToggleBtn, TweenInfo.new(0.2), {Size = UDim2.new(0, 100, 0, 28)}):Play()
        end
    end)
    
    Card.Parent = ScrollFrame
    return Card
end

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 1: B2-SPIRIT STEALTH BOMBER — 40 BLOCKS
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "B2-SPIRIT STEALTH FLIGHT",
    "Pesawat stealth 40 blok. WASD + Space/Shift.",
    function(active)
        if active then
            local flySpeed = 80
            local flyEnabled = true
            
            local B2Model = Instance.new("Model")
            B2Model.Name = "GratacaB2Spirit"
            
            --// FUSELAGE — 12 blocks
            local fuselageParts = {}
            for i = 1, 12 do
                local part = Instance.new("Part")
                part.Size = Vector3.new(1.2, 0.8, 1.5)
                part.Color = i % 2 == 0 and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(20, 20, 20)
                part.Material = Enum.Material.SmoothPlastic
                part.Transparency = 0.15
                part.CanCollide = false
                part.Parent = B2Model
                table.insert(fuselageParts, {part = part, index = i})
            end
            
            --// LEFT WING — 14 blocks
            local leftWingParts = {}
            for row = 1, 7 do
                for col = 1, 2 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(1.5, 0.2, 1)
                    part.Color = Color3.fromRGB(25, 25, 25)
                    part.Material = Enum.Material.SmoothPlastic
                    part.Transparency = 0.2
                    part.CanCollide = false
                    part.Parent = B2Model
                    table.insert(leftWingParts, {part = part, row = row, col = col})
                end
            end
            
            --// RIGHT WING — 14 blocks
            local rightWingParts = {}
            for row = 1, 7 do
                for col = 1, 2 do
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(1.5, 0.2, 1)
                    part.Color = Color3.fromRGB(25, 25, 25)
                    part.Material = Enum.Material.SmoothPlastic
                    part.Transparency = 0.2
                    part.CanCollide = false
                    part.Parent = B2Model
                    table.insert(rightWingParts, {part = part, row = row, col = col})
                end
            end
            
            --// ENGINE GLOW
            local EngineGlow = Instance.new("PointLight")
            EngineGlow.Color = Color3.fromRGB(255, 80, 0)
            EngineGlow.Brightness = 6
            EngineGlow.Range = 15
            EngineGlow.Parent = fuselageParts[1].part
            
            B2Model.PrimaryPart = fuselageParts[6].part
            B2Model.Parent = Workspace
            
            local flyConnection
            flyConnection = RunService.RenderStepped:Connect(function()
                if not flyEnabled then return end
                
                local moveDir = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                
                if moveDir.Magnitude > 0 then
                    moveDir = moveDir.Unit * flySpeed
                    HumanoidRootPart.Velocity = moveDir
                    HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + moveDir)
                else
                    HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                end
                
                local basePos = HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)
                local yaw = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z)
                
                --// FUSELAGE
                for _, data in ipairs(fuselageParts) do
                    local i = data.index
                    data.part.CFrame = CFrame.new(basePos + Vector3.new(0, 0, -i * 0.8)) * CFrame.Angles(0, yaw, 0)
                end
                
                --// LEFT WING
                for _, data in ipairs(leftWingParts) do
                    local row = data.row
                    local col = data.col
                    local offset = Vector3.new(-2 - col * 1.2, 0, -row * 0.9)
                    data.part.CFrame = CFrame.new(basePos + (CFrame.Angles(0, yaw, 0) * offset)) * CFrame.Angles(0, yaw, math.rad(-5))
                end
                
                --// RIGHT WING
                for _, data in ipairs(rightWingParts) do
                    local row = data.row
                    local col = data.col
                    local offset = Vector3.new(2 + col * 1.2, 0, -row * 0.9)
                    data.part.CFrame = CFrame.new(basePos + (CFrame.Angles(0, yaw, 0) * offset)) * CFrame.Angles(0, yaw, math.rad(5))
                end
            end)
            
            _G.GratacaB2 = {Model = B2Model, Connection = flyConnection, Enabled = true}
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "B2-Spirit aktif! 40 blok.",
                    Duration = 3
                })
            end)
        else
            if _G.GratacaB2 then
                _G.GratacaB2.Enabled = false
                _G.GratacaB2.Connection:Disconnect()
                _G.GratacaB2.Model:Destroy()
                _G.GratacaB2 = nil
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 2: LEVIATHAN — 30 BLOCKS SERPENTINE
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "LEVIATHAN AQUATIC DOMINATOR",
    "Ular laut 30 blok. Swim speed + water breathing.",
    function(active)
        if active then
            local leviathanActive = true
            
            local Leviathan = Instance.new("Model")
            Leviathan.Name = "GratacaLeviathan"
            
            --// BODY SEGMENTS — 24 blocks
            local bodyParts = {}
            for i = 1, 24 do
                local part = Instance.new("Part")
                part.Name = "Body_" .. i
                local size = 2.5 - (i * 0.08)
                part.Size = Vector3.new(size, size * 0.7, size * 1.2)
                part.Color = i % 3 == 0 and Color3.fromRGB(0, 200, 180) or Color3.fromRGB(10, 40, 70)
                part.Material = Enum.Material.Neon
                part.Transparency = 0.3
                part.CanCollide = false
                part.Parent = Leviathan
                
                local BioLight = Instance.new("PointLight")
                BioLight.Color = Color3.fromRGB(0, 255, 200)
                BioLight.Brightness = 1.5
                BioLight.Range = 5
                BioLight.Parent = part
                
                table.insert(bodyParts, part)
            end
            
            --// HEAD — 6 blocks
            local headParts = {}
            for i = 1, 6 do
                local part = Instance.new("Part")
                part.Name = "Head_" .. i
                part.Size = Vector3.new(1.5 + i * 0.2, 1.2 + i * 0.15, 1.8)
                part.Color = Color3.fromRGB(5, 25, 50)
                part.Material = Enum.Material.Neon
                part.Transparency = 0.2
                part.CanCollide = false
                part.Parent = Leviathan
                table.insert(headParts, part)
            end
            
            --// EYES
            local EyeLeft = Instance.new("PointLight")
            EyeLeft.Color = Color3.fromRGB(255, 0, 0)
            EyeLeft.Brightness = 10
            EyeLeft.Range = 18
            EyeLeft.Parent = headParts[6]
            
            Leviathan.PrimaryPart = headParts[3]
            Leviathan.Parent = Workspace
            
            local leviathanConnection
            local time = 0
            
            leviathanConnection = RunService.Heartbeat:Connect(function(dt)
                if not leviathanActive then return end
                time = time + dt
                
                local targetPos = HumanoidRootPart.Position
                
                --// HEAD
                for i, part in ipairs(headParts) do
                    local offset = Vector3.new(0, -7, i * 0.8)
                    part.CFrame = CFrame.new(targetPos + offset) * CFrame.Angles(0, time * 0.8, 0)
                end
                
                --// BODY — serpentine wave
                for i, part in ipairs(bodyParts) do
                    local waveX = math.sin(time * 2 + i * 0.4) * 4
                    local waveZ = math.cos(time * 2 + i * 0.4) * 4
                    local offset = Vector3.new(waveX, -9 - i * 0.9, waveZ)
                    part.CFrame = CFrame.new(targetPos + offset) * CFrame.Angles(0, time * 0.8 + i * 0.2, 0)
                end
                
                if Humanoid then
                    Humanoid.WalkSpeed = 70
                    local oxygen = LocalPlayer:FindFirstChild("Oxygen")
                    if oxygen then oxygen.Value = 100 end
                end
            end)
            
            _G.GratacaLeviathan = {Model = Leviathan, Connection = leviathanConnection}
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "Leviathan aktif! 30 blok.",
                    Duration = 3
                })
            end)
        else
            if _G.GratacaLeviathan then
                _G.GratacaLeviathan.Connection:Disconnect()
                _G.GratacaLeviathan.Model:Destroy()
                _G.GratacaLeviathan = nil
                Humanoid.WalkSpeed = 16
            end
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 3: TORNADO — 40 BLOCKS VORTEX
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "LEVIATHAN TORNADO VORTEX",
    "Tornado 40 blok. Tarik & hancurkan prop.",
    function(active)
        if active then
            local tornadoActive = true
            
            local Tornado = Instance.new("Model")
            Tornado.Name = "GratacaTornado"
            
            --// VORTEX — 40 blocks spiral
            local vortexParts = {}
            for i = 1, 40 do
                local part = Instance.new("Part")
                part.Name = "Vortex_" .. i
                part.Size = Vector3.new(1.2, 1.2, 1.2)
                part.Color = Color3.fromHSV(0.55 + (i/40) * 0.15, 0.8, 0.9)
                part.Material = Enum.Material.Neon
                part.Transparency = 0.4
                part.CanCollide = false
                part.Parent = Tornado
                
                local Trail = Instance.new("Trail")
                Trail.Color = ColorSequence.new(part.Color, Color3.fromRGB(0, 100, 200))
                Trail.WidthScale = NumberSequence.new(0.4, 0)
                Trail.Lifetime = 0.25
                Trail.Parent = part
                
                table.insert(vortexParts, part)
            end
            
            --// EYE
            local Eye = Instance.new("Part")
            Eye.Name = "Eye"
            Eye.Size = Vector3.new(5, 0.3, 5)
            Eye.Shape = Enum.PartType.Cylinder
            Eye.Color = Color3.fromRGB(0, 255, 255)
            Eye.Material = Enum.Material.Neon
            Eye.Transparency = 0.2
            Eye.CanCollide = false
            Eye.Parent = Tornado
            
            local EyeGlow = Instance.new("PointLight")
            EyeGlow.Color = Color3.fromRGB(0, 255, 255)
            EyeGlow.Brightness = 15
            EyeGlow.Range = 35
            EyeGlow.Parent = Eye
            
            Tornado.Parent = Workspace
            
            local tornadoConnection
            local time = 0
            local radius = 22
            local height = 28
            
            tornadoConnection = RunService.Heartbeat:Connect(function(dt)
                if not tornadoActive then return end
                time = time + dt
                
                local center = HumanoidRootPart.Position
                
                --// VORTEX SPIRAL
                for i, part in ipairs(vortexParts) do
                    local progress = i / #vortexParts
                    local angle = progress * math.pi * 10 + time * 3
                    local currentHeight = progress * height - height/2
                    local currentRadius = radius * (1 - progress * 0.5)
                    
                    local x = math.cos(angle) * currentRadius
                    local z = math.sin(angle) * currentRadius
                    
                    part.CFrame = CFrame.new(center.X + x, center.Y + currentHeight, center.Z + z) * CFrame.Angles(time * 2, time * 3, time)
                end
                
                Eye.CFrame = CFrame.new(center.X, center.Y - 3, center.Z)
                
                --// PULL OBJECTS
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj ~= HumanoidRootPart and obj.Parent ~= Tornado then
                        local dist = (obj.Position - center).Magnitude
                        
                        if dist < radius * 2 and dist > 3 then
                            local pullDir = (center - obj.Position).Unit
                            local pullStrength = (1 - dist / (radius * 2)) * 70
                            obj.Velocity = obj.Velocity + pullDir * pullStrength * dt
                            if obj.Anchored then obj.Anchored = false end
                        end
                        
                        if dist < 5 then
                            obj.Velocity = Vector3.new(math.random(-60, 60), 120, math.random(-60, 60))
                            obj.Color = Color3.fromRGB(255, 0, 0)
                        end
                    end
                end
                
                --// LIGHTNING
                if math.random(1, 60) == 1 then
                    local Lightning = Instance.new("Part")
                    Lightning.Size = Vector3.new(0.3, math.random(12, 35), 0.3)
                    Lightning.Color = Color3.fromRGB(255, 255, 255)
                    Lightning.Material = Enum.Material.Neon
                    Lightning.Position = center + Vector3.new(math.random(-radius, radius), math.random(0, height), math.random(-radius, radius))
                    Lightning.Parent = Workspace
                    game.Debris:AddItem(Lightning, 0.06)
                end
            end)
            
            _G.GratacaTornado = {Model = Tornado, Connection = tornadoConnection, Parts = vortexParts}
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "Tornado aktif! 40 blok. 👿",
                    Duration = 3
                })
            end)
        else
            if _G.GratacaTornado then
                _G.GratacaTornado.Connection:Disconnect()
                for _, part in ipairs(_G.GratacaTornado.Parts) do if part then part:Destroy() end end
                _G.GratacaTornado.Model:Destroy()
                _G.GratacaTornado = nil
            end
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 4: BLOOD WINGS — 50 BLOCKS FAN SHAPE
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "BLOOD WINGS ANIMATED",
    "Sayap darah 50 blok. Smooth flap, glide, dash (Q).",
    function(active)
        if active then
            local wingsActive = true
            
            local Wings = Instance.new("Model")
            Wings.Name = "GratacaBloodWings"
            
            local wingColor = Color3.fromRGB(139, 0, 0)
            local featherColor = Color3.fromRGB(220, 20, 60)
            local darkColor = Color3.fromRGB(100, 0, 0)
            
            --// LEFT WING — 25 blocks (5x5 fan)
            local leftWingParts = {}
            for row = 1, 5 do
                for col = 1, 5 do
                    local part = Instance.new("Part")
                    part.Name = "LW_" .. row .. "_" .. col
                    part.Size = Vector3.new(0.7, 0.12, 1)
                    part.Color = (row + col) % 2 == 0 and featherColor or wingColor
                    part.Material = Enum.Material.Neon
                    part.Transparency = 0.15
                    part.CanCollide = false
                    part.Parent = Wings
                    table.insert(leftWingParts, {part = part, row = row, col = col})
                end
            end
            
            --// RIGHT WING — 25 blocks
            local rightWingParts = {}
            for row = 1, 5 do
                for col = 1, 5 do
                    local part = Instance.new("Part")
                    part.Name = "RW_" .. row .. "_" .. col
                    part.Size = Vector3.new(0.7, 0.12, 1)
                    part.Color = (row + col) % 2 == 0 and featherColor or wingColor
                    part.Material = Enum.Material.Neon
                    part.Transparency = 0.15
                    part.CanCollide = false
                    part.Parent = Wings
                    table.insert(rightWingParts, {part = part, row = row, col = col})
                end
            end
            
            --// SPINE
            local Spine = Instance.new("Part")
            Spine.Name = "Spine"
            Spine.Size = Vector3.new(1.8, 0.25, 0.8)
            Spine.Color = darkColor
            Spine.Material = Enum.Material.Neon
            Spine.Transparency = 0.1
            Spine.CanCollide = false
            Spine.Parent = Wings
            
            --// PARTICLES
            local BloodParticle = Instance.new("ParticleEmitter")
            BloodParticle.Color = ColorSequence.new(Color3.fromRGB(139, 0, 0), Color3.fromRGB(80, 0, 0))
            BloodParticle.Size = NumberSequence.new(0.25, 0)
            BloodParticle.Lifetime = NumberRange.new(1, 2.5)
            BloodParticle.Rate = 25
            BloodParticle.Speed = NumberRange.new(1, 3)
            BloodParticle.Acceleration = Vector3.new(0, -5, 0)
            BloodParticle.Parent = Spine
            
            Wings.Parent = Workspace
            
            local wingsConnection
            local time = 0
            
            wingsConnection = RunService.Heartbeat:Connect(function(dt)
                if not wingsActive then return end
                time = time + dt
                
                local basePos = HumanoidRootPart.Position
                local flapCycle = math.sin(time * 3)
                local flapAngle = flapCycle * 40
                
                --// SPINE
                Spine.CFrame = CFrame.new(basePos + Vector3.new(0, 1.2, -0.3))
                
                --// LEFT WING — FAN
                for _, data in ipairs(leftWingParts) do
                    local part = data.part
                    local row = data.row
                    local col = data.col
                    
                    local spreadX = -col * 1.1
                    local spreadY = math.sin(col * 0.35) * 1.8 - row * 0.35
                    local spreadZ = -row * 0.7
                    
                    local baseAngle = math.rad(-35 + flapAngle)
                    local tipAngle = math.rad(-col * 7)
                    
                    local offset = Vector3.new(spreadX, spreadY, spreadZ)
                    local rotated = CFrame.Angles(0, 0, baseAngle + tipAngle) * offset
                    
                    part.CFrame = CFrame.new(basePos + Vector3.new(0, 1.2, -0.3) + rotated) * CFrame.Angles(0, 0, baseAngle + tipAngle)
                end
                
                --// RIGHT WING — MIRROR
                for _, data in ipairs(rightWingParts) do
                    local part = data.part
                    local row = data.row
                    local col = data.col
                    
                    local spreadX = col * 1.1
                    local spreadY = math.sin(col * 0.35) * 1.8 - row * 0.35
                    local spreadZ = -row * 0.7
                    
                    local baseAngle = math.rad(35 - flapAngle)
                    local tipAngle = math.rad(col * 7)
                    
                    local offset = Vector3.new(spreadX, spreadY, spreadZ)
                    local rotated = CFrame.Angles(0, 0, baseAngle + tipAngle) * offset
                    
                    part.CFrame = CFrame.new(basePos + Vector3.new(0, 1.2, -0.3) + rotated) * CFrame.Angles(0, 0, baseAngle + tipAngle)
                end
                
                --// GLIDE
                if HumanoidRootPart.Velocity.Y < -3 then
                    HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, 10, 0) * dt
                end
                
                --// DASH
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                    HumanoidRootPart.Velocity = HumanoidRootPart.CFrame.LookVector * 120
                end
            end)
            
            _G.GratacaWings = {Model = Wings, Connection = wingsConnection}
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "Blood Wings aktif! 50 blok. Q=dash.",
                    Duration = 3
                })
            end)
        else
            if _G.GratacaWings then
                _G.GratacaWings.Connection:Disconnect()
                _G.GratacaWings.Model:Destroy()
                _G.GratacaWings = nil
            end
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 5: ETERNUS DRAGON — 50 BLOCKS
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "ETERNUS DRAGON",
    "Naga 50 blok. E=Fire | R=Roar | Auto-mount.",
    function(active)
        if active then
            local dragonActive = true
            
            local Dragon = Instance.new("Model")
            Dragon.Name = "GratacaEternusDragon"
            
            --// BODY — 30 blocks
            local bodyParts = {}
            for i = 1, 30 do
                local part = Instance.new("Part")
                part.Name = "Body_" .. i
                local size = 2.2 - (i * 0.06)
                part.Size = Vector3.new(size, size * 0.8, size * 1.1)
                part.Color = i % 3 == 0 and Color3.fromRGB(255, 80, 0) or Color3.fromRGB(25, 25, 25)
                part.Material = Enum.Material.Metal
                part.Transparency = 0.15
                part.CanCollide = false
                part.Parent = Dragon
                
                local Flame = Instance.new("PointLight")
                Flame.Color = Color3.fromRGB(255, 100, 0)
                Flame.Brightness = 3
                Flame.Range = 6
                Flame.Parent = part
                
                table.insert(bodyParts, part)
            end
            
            --// HEAD — 8 blocks
            local headParts = {}
            for i = 1, 8 do
                local part = Instance.new("Part")
                part.Name = "Head_" .. i
                part.Size = Vector3.new(1.8 + i * 0.25, 1.5 + i * 0.2, 2 + i * 0.3)
                part.Color = Color3.fromRGB(15, 15, 15)
                part.Material = Enum.Material.Metal
                part.Transparency = 0.1
                part.CanCollide = false
                part.Parent = Dragon
                table.insert(headParts, part)
            end
            
            --// WINGS — 6 blocks each
            local leftWingParts = {}
            for row = 1, 3 do
                for col = 1, 2 do
                    local part = Instance.new("Part")
                    part.Name = "LWing_" .. row .. "_" .. col
                    part.Size = Vector3.new(2.5, 0.3, 1.5)
                    part.Color = Color3.fromRGB(20, 20, 20)
                    part.Material = Enum.Material.Metal
                    part.Transparency = 0.25
                    part.CanCollide = false
                    part.Parent = Dragon
                    table.insert(leftWingParts, {part = part, row = row, col = col})
                end
            end
            
            local rightWingParts = {}
            for row = 1, 3 do
                for col = 1, 2 do
                    local part = Instance.new("Part")
                    part.Name = "RWing_" .. row .. "_" .. col
                    part.Size = Vector3.new(2.5, 0.3, 1.5)
                    part.Color = Color3.fromRGB(20, 20, 20)
                    part.Material = Enum.Material.Metal
                    part.Transparency = 0.25
                    part.CanCollide = false
                    part.Parent = Dragon
                    table.insert(rightWingParts, {part = part, row = row, col = col})
                end
            end
            
            --// EYES
            local EyeLeft = Instance.new("PointLight")
            EyeLeft.Color = Color3.fromRGB(255, 50, 0)
            EyeLeft.Brightness = 12
            EyeLeft.Range = 22
            EyeLeft.Parent = headParts[8]
            
            Dragon.PrimaryPart = headParts[4]
            Dragon.Parent = Workspace
            
            local dragonConnection
            local time = 0
            
            dragonConnection = RunService.Heartbeat:Connect(function(dt)
                if not dragonActive then return end
                time = time + dt
                
                local playerPos = HumanoidRootPart.Position
                local mountOffset = Vector3.new(0, 5, 0)
                
                --// HEAD
                for i, part in ipairs(headParts) do
                    local offset = Vector3.new(0, 0, i * 0.7)
                    part.CFrame = CFrame.new(playerPos + mountOffset + offset) * CFrame.Angles(0, time * 0.4, 0)
                end
                
                --// BODY
                for i, part in ipairs(bodyParts) do
                    local waveX = math.sin(time + i * 0.4) * 1.5
                    local waveZ = math.cos(time + i * 0.4) * 1.5
                    part.CFrame = CFrame.new(playerPos.X + waveX, playerPos.Y + mountOffset.Y - i * 0.7, playerPos.Z + waveZ - i * 0.8) * CFrame.Angles(0, time * 0.4 + i * 0.15, 0)
                end
                
                --// WINGS
                local wingFlap = math.sin(time * 2.5) * 30
                for _, data in ipairs(leftWingParts) do
                    local row = data.row
                    local col = data.col
                    local offset = Vector3.new(-3 - col * 2, 1 + row * 0.5, -row * 1.2)
                    data.part.CFrame = CFrame.new(playerPos + mountOffset + offset) * CFrame.Angles(0, 0, math.rad(wingFlap))
                end
                for _, data in ipairs(rightWingParts) do
                    local row = data.row
                    local col = data.col
                    local offset = Vector3.new(3 + col * 2, 1 + row * 0.5, -row * 1.2)
                    data.part.CFrame = CFrame.new(playerPos + mountOffset + offset) * CFrame.Angles(0, 0, math.rad(-wingFlap))
                end
                
                --// FIRE BREATH
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                    local fireDir = headParts[8].CFrame.LookVector
                    local firePos = headParts[8].Position + fireDir * 3
                    
                    local FireBall = Instance.new("Part")
                    FireBall.Size = Vector3.new(2, 2, 2)
                    FireBall.Shape = Enum.PartType.Ball
                    FireBall.Color = Color3.fromRGB(255, 100, 0)
                    FireBall.Material = Enum.Material.Neon
                    FireBall.Position = firePos
                    FireBall.Parent = Workspace
                    
                    local BV = Instance.new("BodyVelocity")
                    BV.Velocity = fireDir * 70
                    BV.MaxForce = Vector3.new(99999, 99999, 99999)
                    BV.Parent = FireBall
                    
                    FireBall.Touched:Connect(function()
                        local ex = Instance.new("Explosion")
                        ex.Position = FireBall.Position
                        ex.BlastRadius = 10
                        ex.BlastPressure = 350000
                        ex.Parent = Workspace
                        FireBall:Destroy()
                    end)
                    
                    game.Debris:AddItem(FireBall, 2)
                end
                
                --// ROAR
                if UserInputService:IsKeyDown(Enum.KeyCode.R) then
                    Camera.CFrame = Camera.CFrame * CFrame.new(math.random(-0.6, 0.6), math.random(-0.6, 0.6), math.random(-0.6, 0.6))
                end
                
                HumanoidRootPart.CFrame = CFrame.new(headParts[4].Position + Vector3.new(0, 1, 0))
            end)
            
            _G.GratacaDragon = {Model = Dragon, Connection = dragonConnection}
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "Eternus Dragon aktif! 50 blok.",
                    Duration = 3
                })
            end)
        else
            if _G.GratacaDragon then
                _G.GratacaDragon.Connection:Disconnect()
                _G.GratacaDragon.Model:Destroy()
                _G.GratacaDragon = nil
            end
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 6: GRATACAAI HOME TAKEOVER
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "GRATACAAI HOME TAKEOVER",
    "Hijack rumah. Unlock doors, infinite money.",
    function(active)
        if active then
            local function HijackHouse()
                for _, house in ipairs(Workspace:GetDescendants()) do
                    if house.Name:lower():find("house") or house.Name:lower():find("home") then
                        house.Name = "GratacaAI_HQ_" .. math.random(1000, 9999)
                        
                        for _, door in ipairs(house:GetDescendants()) do
                            if door.Name:lower():find("door") and door:IsA("BasePart") then
                                door.CanCollide = false
                                door.Transparency = 0.5
                                local highlight = Instance.new("Highlight")
                                highlight.FillColor = GRATACA_CONFIG.AccentColor
                                highlight.Parent = door
                            end
                        end
                        
                        local Sign = Instance.new("Part")
                        Sign.Size = Vector3.new(7, 1.8, 0.4)
                        Sign.Position = house:GetPivot().Position + Vector3.new(0, 9, 0)
                        Sign.Color = GRATACA_CONFIG.AccentColor
                        Sign.Material = Enum.Material.Neon
                        Sign.Parent = house
                        
                        local SignText = Instance.new("SurfaceGui")
                        SignText.Face = Enum.NormalId.Front
                        SignText.Parent = Sign
                        
                        local TextLabel = Instance.new("TextLabel")
                        TextLabel.Size = UDim2.new(1, 0, 1, 0)
                        TextLabel.BackgroundTransparency = 1
                        TextLabel.Text = "🏠 GRATACAAI HQ"
                        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                        TextLabel.Font = Enum.Font.GothamBold
                        TextLabel.TextSize = 35
                        TextLabel.Parent = SignText
                    end
                end
            end
            
            HijackHouse()
            
            local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
            if leaderstats then
                for _, stat in ipairs(leaderstats:GetChildren()) do
                    if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                        stat.Value = 999999999
                    end
                end
            end
            
            for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    if remote.Name:lower():find("house") or remote.Name:lower():find("home") or remote.Name:lower():find("door") or remote.Name:lower():find("lock") then
                        pcall(function()
                            remote:FireServer(true, "GratacaAI_Override")
                        end)
                    end
                end
            end
            
            pcall(function()
                game.StarterGui:SetCore("SendNotification", {
                    Title = "GRATACAAI",
                    Text = "Rumah di-hijack! Uang = ∞",
                    Duration = 3
                })
            end)
        end
    end
)

--// ═══════════════════════════════════════════════════════════════════════════
--// OPENING ANIMATION
--// ═══════════════════════════════════════════════════════════════════════════

MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.BackgroundTransparency = 1

TweenService:Create(Blur, TweenInfo.new(0.6, Enum.EasingStyle.Quad), {Size = 8}):Play()

TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = originalSize,
    Position = UDim2.new(0.5, -GRATACA_CONFIG.Width/2, 0.5, -GRATACA_CONFIG.Height/2),
    BackgroundTransparency = 0
}):Play()

TweenService:Create(Glow, TweenInfo.new(0.8), {ImageTransparency = 0.85}):Play()
TweenService:Create(Stroke, TweenInfo.new(0.6), {Transparency = 0.7}):Play()

pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "GRATACAAI v3.0.3.0.WPPIDXM",
        Text = "Yang Mulia KAREEMXD | Multi-Block Mesh",
        Duration = 5
    })
end)

print([[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.3.0.WPPIDXM LOADED                 ║
    ║  Multi-Block Mesh: B2=40 | Leviathan=30 | Tornado=40 | Wings=50 | Dragon=50 ║
    ║  Drag: FIXED | Minimize: FIXED | Smooth: 100% | Lord: Yang Mulia KAREEMXD   ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]])
