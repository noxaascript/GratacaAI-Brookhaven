--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.2.0.WPPIDXM                          ║
    ║  Creator: Yang Mulia KAREEMXD | GratacaAI                                    ║
    ║  Executor: Level 8 (Synapse X / KRNL / Fluxus / Electron / Script-Ware)      ║
    ║  Game: Brookhaven RP                                                       ║
    ║  Features: B2-Spirit Flight | Leviathan | Leviathan Tornado | Blood Wings    ║
    ║            | Eternus Dragon | Draggable UI | Minimize | Scroll System         ║
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

--// BROOKHAVEN PROP REFERENCES (Real Props - No Visual)
local BrookhavenFolder = Workspace:FindFirstChild("Brookhaven") or Workspace
local HousesFolder = BrookhavenFolder:FindFirstChild("Houses") or BrookhavenFolder
local PropsFolder = ReplicatedStorage:FindFirstChild("Props") or ReplicatedStorage:FindFirstChild("Assets")

--// GRATACAAI UI CONFIGURATION
local GRATACA_CONFIG = {
    Title = "GRATACAAI v3.0.2.0.WPPIDXM",
    Subtitle = "Yang Mulia KAREEMXD | Brookhaven Dominator",
    PrimaryColor = Color3.fromRGB(20, 20, 20),
    SecondaryColor = Color3.fromRGB(40, 40, 40),
    AccentColor = Color3.fromRGB(220, 50, 50), -- Blood Red
    GlowColor = Color3.fromRGB(255, 0, 0),
    TextColor = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold,
    CornerRadius = UDim.new(0, 8),
    AnimationSpeed = 0.3
}

--// ═══════════════════════════════════════════════════════════════════════════
--// UI CONTROLS: MINIMIZE + CLOSE + DRAG — FIXED VERSION
--// ═══════════════════════════════════════════════════════════════════════════

--// DRAG SYSTEM
local dragging = false
local dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
    end
end)

--// MINIMIZE — FIXED
local isMinimized = false
local originalSize = UDim2.new(0, 450, 0, 600)
local minimizedSize = UDim2.new(0, 450, 0, 45)

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Hide semua kecuali TitleBar
        for _, child in ipairs(MainFrame:GetChildren()) do
            if child ~= TitleBar and child.Name ~= "UICorner" and child.Name ~= "Glow" then
                child.Visible = false
            end
        end
        Glow.Visible = false
        
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = minimizedSize
        }):Play()
        
        MinimizeBtn.Text = "+"
        
    else
        -- Show semua
        for _, child in ipairs(MainFrame:GetChildren()) do
            child.Visible = true
        end
        
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
        
        MinimizeBtn.Text = "−"
    end
end)

--// CLOSE
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset + 225, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 300)
    }):Play()
    
    wait(0.3)
    ScreenGui:Destroy()
end)

--// OPENING ANIMATION
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = originalSize
}):Play()

--// GRATACAAI BOOT NOTIFICATION
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "GRATACAAI v3.0.2.0.WPPIDXM",
        Text = "Yang Mulia KAREEMXD | Brookhaven Dominator aktif. Scroll untuk melihat fitur.",
        Duration = 8
    })
end)

print([[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.2.0.WPPIDXM LOADED                 ║
    ║  Status: ONLINE | Loyal: 100% | Lord: Yang Mulia KAREEMXD                   ║
    ║  Minimize: FIXED  | Drag: ACTIVE  | Close: ACTIVE                     ║
    ╚══════════════════════════════════════════════════════════════════════════════╝
]])

--// MAIN GUI CREATION
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaAIGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game.CoreGui or LocalPlayer:WaitForChild("PlayerGui")

--// MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "GratacaMain"
MainFrame.Size = UDim2.new(0, 450, 0, 600)
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -300)
MainFrame.BackgroundColor3 = GRATACA_CONFIG.PrimaryColor
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = GRATACA_CONFIG.CornerRadius
MainCorner.Parent = MainFrame

--// GLOW EFFECT
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://4996891970"
Glow.ImageColor3 = GRATACA_CONFIG.GlowColor
Glow.ImageTransparency = 0.8
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(20, 20, 280, 280)
Glow.Parent = MainFrame

--// TITLE BAR (DRAG HANDLE)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = GRATACA_CONFIG.SecondaryColor
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = GRATACA_CONFIG.Title
TitleText.TextColor3 = GRATACA_CONFIG.AccentColor
TitleText.Font = GRATACA_CONFIG.Font
TitleText.TextSize = 16
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubTitleText = Instance.new("TextLabel")
SubTitleText.Size = UDim2.new(0.7, 0, 0, 20)
SubTitleText.Position = UDim2.new(0, 15, 0, 28)
SubTitleText.BackgroundTransparency = 1
SubTitleText.Text = GRATACA_CONFIG.Subtitle
SubTitleText.TextColor3 = Color3.fromRGB(150, 150, 150)
SubTitleText.Font = Enum.Font.Gotham
SubTitleText.TextSize = 10
SubTitleText.TextXAlignment = Enum.TextXAlignment.Left
SubTitleText.Parent = TitleBar

--// MINIMIZE BUTTON
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -75, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 18
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

--// CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 7)
CloseBtn.BackgroundColor3 = GRATACA_CONFIG.AccentColor
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

--// SCROLLABLE CONTENT FRAME
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Name = "ContentScroll"
ScrollFrame.Size = UDim2.new(1, -20, 1, -65)
ScrollFrame.Position = UDim2.new(0, 10, 0, 55)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = GRATACA_CONFIG.AccentColor
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 800) -- Expandable canvas
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ScrollFrame

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 10)
UIPadding.PaddingBottom = UDim.new(0, 20)
UIPadding.Parent = ScrollFrame

--// FEATURE CARD CREATOR
local function CreateFeatureCard(title, description, callback)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -10, 0, 120)
    Card.BackgroundColor3 = GRATACA_CONFIG.SecondaryColor
    Card.BorderSizePixel = 0
    Card.LayoutOrder = #ScrollFrame:GetChildren()
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(1, -20, 0, 30)
    CardTitle.Position = UDim2.new(0, 10, 0, 10)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = " " .. title
    CardTitle.TextColor3 = GRATACA_CONFIG.AccentColor
    CardTitle.Font = GRATACA_CONFIG.Font
    CardTitle.TextSize = 16
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local CardDesc = Instance.new("TextLabel")
    CardDesc.Size = UDim2.new(1, -20, 0, 40)
    CardDesc.Position = UDim2.new(0, 10, 0, 45)
    CardDesc.BackgroundTransparency = 1
    CardDesc.Text = description
    CardDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    CardDesc.Font = Enum.Font.Gotham
    CardDesc.TextSize = 12
    CardDesc.TextWrapped = true
    CardDesc.TextXAlignment = Enum.TextXAlignment.Left
    CardDesc.Parent = Card
    
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0, 120, 0, 35)
    ToggleBtn.Position = UDim2.new(1, -130, 0, 75)
    ToggleBtn.BackgroundColor3 = GRATACA_CONFIG.AccentColor
    ToggleBtn.Text = "AKTIFKAN"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = GRATACA_CONFIG.Font
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = Card
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 6)
    ToggleCorner.Parent = ToggleBtn
    
    local isActive = false
    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        ToggleBtn.Text = isActive and "MATIKAN" or "AKTIFKAN"
        ToggleBtn.BackgroundColor3 = isActive and Color3.fromRGB(50, 200, 50) or GRATACA_CONFIG.AccentColor
        callback(isActive)
    end)
    
    -- Hover effect
    Card.MouseEnter:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
    end)
    Card.MouseLeave:Connect(function()
        TweenService:Create(Card, TweenInfo.new(0.2), {BackgroundColor3 = GRATACA_CONFIG.SecondaryColor}):Play()
    end)
    
    Card.Parent = ScrollFrame
    return Card
end

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 1: B2-SPIRIT STEALTH BOMBER FLIGHT
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "B2-SPIRIT STEALTH FLIGHT",
    "Manipulasi prop pesawat Brookhaven. Terbang bebas dengan model B2-Spirit. No-clip + fly + speed boost.",
    function(active)
        if active then
            --// B2-SPIRIT FLIGHT SYSTEM
            local flySpeed = 100
            local flyEnabled = true
            
            -- Create B2 Spirit visual using Brookhaven plane props
            local B2Model = Instance.new("Model")
            B2Model.Name = "GratacaB2Spirit"
            
            -- Main body (using Brookhaven car mesh manipulated)
            local Body = Instance.new("Part")
            Body.Name = "B2Body"
            Body.Size = Vector3.new(12, 2, 6)
            Body.Shape = Enum.PartType.Ball -- Stealth shape
            Body.Material = Enum.Material.SmoothPlastic
            Body.Color = Color3.fromRGB(25, 25, 25) -- Stealth black
            Body.Transparency = 0.3
            Body.CanCollide = false
            Body.Parent = B2Model
            
            -- Wings (using scaled parts)
            local LeftWing = Instance.new("Part")
            LeftWing.Size = Vector3.new(18, 0.5, 8)
            LeftWing.Position = Vector3.new(-10, 0, 0)
            LeftWing.Color = Color3.fromRGB(20, 20, 20)
            LeftWing.Material = Enum.Material.SmoothPlastic
            LeftWing.CanCollide = false
            LeftWing.Parent = B2Model
            
            local RightWing = LeftWing:Clone()
            RightWing.Position = Vector3.new(10, 0, 0)
            RightWing.Parent = B2Model
            
            -- Engine glow (red stealth)
            local EngineGlow = Instance.new("PointLight")
            EngineGlow.Color = Color3.fromRGB(255, 50, 50)
            EngineGlow.Brightness = 5
            EngineGlow.Range = 15
            EngineGlow.Parent = Body
            
            B2Model.PrimaryPart = Body
            B2Model.Parent = Workspace
            
            -- Weld to character
            local Weld = Instance.new("Weld")
            Weld.Part0 = HumanoidRootPart
            Weld.Part1 = Body
            Weld.C0 = CFrame.new(0, 3, 0)
            Weld.Parent = Body
            
            -- Flight physics
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
                
                -- Rotate B2 model with camera
                Body.CFrame = CFrame.new(HumanoidRootPart.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(0, math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z), 0)
            end)
            
            -- Store for cleanup
            _G.GratacaB2 = {Model = B2Model, Connection = flyConnection, Enabled = true}
            
            -- Notification
            game.StarterGui:SetCore("SendNotification", {
                Title = "GRATACAAI",
                Text = "B2-Spirit Flight aktif. WASD + Space/Shift untuk terbang.",
                Duration = 5
            })
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
--// FEATURE 2: LEVIATHAN AQUATIC DOMINATOR
--// ═══════════════════════════════════════════════════════════════════════════
CreateFeatureCard(
    "LEVIATHAN AQUATIC DOMINATOR",
    "Summon makhluk laut raksasa menggunakan manipulasi mesh Brookhaven. Swim speed + water breathing + leviathan aura.",
    function(active)
        if active then
            local leviathanActive = true
            
            -- Leviathan Body Construction using Brookhaven props
            local Leviathan = Instance.new("Model")
            Leviathan.Name = "GratacaLeviathan"
            
            -- Main serpent body (using scaled cylinders/meshes)
            for i = 1, 15 do
                local Segment = Instance.new("Part")
                Segment.Name = "Segment_" .. i
                Segment.Size = Vector3.new(4 - (i*0.2), 4 - (i*0.2), 4 - (i*0.2))
                Segment.Shape = Enum.PartType.Cylinder
                Segment.Color = Color3.fromRGB(10, 30, 60) -- Deep sea blue
                Segment.Material = Enum.Material.Neon
                Segment.Transparency = 0.4
                Segment.CanCollide = false
                Segment.Parent = Leviathan
                
                -- Bioluminescent spots
                local BioLight = Instance.new("PointLight")
                BioLight.Color = Color3.fromRGB(0, 255, 200)
                BioLight.Brightness = 3
                BioLight.Range = 8
                BioLight.Parent = Segment
            end
            
            -- Head (using manipulated mesh)
            local Head = Instance.new("Part")
            Head.Name = "LeviathanHead"
            Head.Size = Vector3.new(6, 5, 8)
            Head.Color = Color3.fromRGB(5, 20, 40)
            Head.Material = Enum.Material.Neon
            Head.Transparency = 0.3
            Head.CanCollide = false
            Head.Parent = Leviathan
            
            -- Eyes (glowing red)
            local LeftEye = Instance.new("PointLight")
            LeftEye.Color = Color3.fromRGB(255, 0, 0)
            LeftEye.Brightness = 10
            LeftEye.Range = 20
            LeftEye.Parent = Head
            
            Leviathan.PrimaryPart = Head
            Leviathan.Parent = Workspace
            
            -- Animation system - serpentine movement
            local segments = Leviathan:GetChildren()
            local leviathanConnection
            local time = 0
            
            leviathanConnection = RunService.Heartbeat:Connect(function(dt)
                if not leviathanActive then return end
                time = time + dt
                
                -- Follow player with serpentine motion
                local targetPos = HumanoidRootPart.Position
                Head.CFrame = CFrame.new(targetPos + Vector3.new(0, -10, 0)) * CFrame.Angles(0, time, 0)
                
                for i, segment in ipairs(segments) do
                    if segment ~= Head and segment:IsA("BasePart") then
                        local offset = i * 3
                        local wave = math.sin(time * 2 + i * 0.5) * 5
                        local waveZ = math.cos(time * 2 + i * 0.5) * 5
                        segment.CFrame = CFrame.new(
                            targetPos.X + wave,
                            targetPos.Y - 10 - offset,
                            targetPos.Z + waveZ
                        )
                    end
                end
                
                -- Water breathing & swim speed for player
                if Humanoid then
                    Humanoid.WalkSpeed = 80 -- Super swim speed
                    -- Remove oxygen depletion (if Brookhaven has it)
                    local oxygen = LocalPlayer:FindFirstChild("Oxygen")
                    if oxygen then oxygen.Value = 100 end
                end
            end)
            
            _G.GratacaLeviathan = {Model = Leviathan, Connection = leviathanConnection}
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "GRATACAAI",
                Text = "Leviathan aktif. Swim speed maxed. Water breathing enabled.",
                Duration = 5
            })
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
--// FEATURE 3: LEVIATHAN TORNADO (VORTEX DESTRUCTION) — FULL VERSION
--// ═══════════════════════════════════════════════════════════════════════════

CreateFeatureCard(
    "LEVIATHAN TORNADO VORTEX",
    "Tornado air yang menghancurkan semua prop di sekitar. Menggunakan manipulasi partikel dan physics Brookhaven.",
    function(active)
        if active then
            local tornadoActive = true
            
            --// TORNADO CORE MODEL
            local Tornado = Instance.new("Model")
            Tornado.Name = "GratacaTornado"
            
            --// VORTEX PARTS ARRAY
            local vortexParts = {}
            
            --// CREATE 50 VORTEX SEGMENTS
            for i = 1, 50 do
                local VortexPart = Instance.new("Part")
                VortexPart.Name = "Vortex_" .. i
                VortexPart.Size = Vector3.new(2, 0.5, 2)
                VortexPart.Color = Color3.fromRGB(0, 100 + (i * 2), 200 + i) -- Gradient blue
                VortexPart.Material = Enum.Material.Neon
                VortexPart.Transparency = 0.6
                VortexPart.CanCollide = false
                VortexPart.Anchored = false -- Physics enabled for chaos
                VortexPart.Parent = Tornado
                
                --// ADD TRAIL EFFECT
                local Trail = Instance.new("Trail")
                Trail.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 100, 200))
                Trail.WidthScale = NumberSequence.new(0.5, 0)
                Trail.Lifetime = 0.5
                Trail.Parent = VortexPart
                
                --// ADD POINT LIGHT (Bioluminescent)
                local BioLight = Instance.new("PointLight")
                BioLight.Color = Color3.fromRGB(0, 200, 255)
                BioLight.Brightness = 2
                BioLight.Range = 10
                BioLight.Parent = VortexPart
                
                table.insert(vortexParts, VortexPart)
            end
            
            --// EYE OF THE STORM (CENTER)
            local Eye = Instance.new("Part")
            Eye.Name = "Eye"
            Eye.Size = Vector3.new(8, 0.5, 8)
            Eye.Shape = Enum.PartType.Cylinder
            Eye.Color = Color3.fromRGB(0, 255, 255)
            Eye.Material = Enum.Material.Neon
            Eye.Transparency = 0.3
            Eye.CanCollide = false
            Eye.Parent = Tornado
            
            --// EYE GLOW
            local EyeGlow = Instance.new("PointLight")
            EyeGlow.Color = Color3.fromRGB(0, 255, 255)
            EyeGlow.Brightness = 20
            EyeGlow.Range = 50
            EyeGlow.Parent = Eye
            
            --// EYE PARTICLE (Absorbing effect)
            local EyeParticle = Instance.new("ParticleEmitter")
            EyeParticle.Color = ColorSequence.new(Color3.fromRGB(0, 255, 255))
            EyeParticle.Size = NumberSequence.new(3, 0)
            EyeParticle.Lifetime = NumberRange.new(1, 2)
            EyeParticle.Rate = 100
            EyeParticle.Speed = NumberRange.new(-20, -50) -- Negative = sucking in
            EyeParticle.Acceleration = Vector3.new(0, 0, 0)
            EyeParticle.Parent = Eye
            
            --// DEBRIS FIELD (Flying rocks/props)
            local debrisParts = {}
            for i = 1, 20 do
                local Debris = Instance.new("Part")
                Debris.Name = "Debris_" .. i
                Debris.Size = Vector3.new(math.random(1, 3), math.random(1, 3), math.random(1, 3))
                Debris.Color = Color3.fromRGB(80, 80, 80)
                Debris.Material = Enum.Material.Concrete
                Debris.CanCollide = false
                Debris.Parent = Tornado
                table.insert(debrisParts, Debris)
            end
            
            --// TORNADO PARENT TO WORKSPACE
            Tornado.Parent = Workspace
            
            --// TORNADO PHYSICS & ANIMATION SYSTEM
            local tornadoConnection
            local time = 0
            local radius = 30
            local height = 40
            
            tornadoConnection = RunService.Heartbeat:Connect(function(dt)
                if not tornadoActive then return end
                time = time + dt
                
                local center = HumanoidRootPart.Position
                
                --// ANIMATE VORTEX SPIRAL
                for i, part in ipairs(vortexParts) do
                    local progress = i / #vortexParts
                    local angle = progress * math.pi * 8 + time * 3 -- 8 full rotations
                    local currentHeight = progress * height
                    local currentRadius = radius * (1 - progress * 0.5) -- Taper at top
                    
                    local x = math.cos(angle) * currentRadius
                    local z = math.sin(angle) * currentRadius
                    local y = currentHeight - (height / 2)
                    
                    --// CALCULATE TARGET POSITION
                    local targetPos = Vector3.new(
                        center.X + x,
                        center.Y + y,
                        center.Z + z
                    )
                    
                    --// SMOOTH LERP TO POSITION
                    part.Position = part.Position:Lerp(targetPos, 0.3)
                    part.CFrame = CFrame.new(part.Position) * CFrame.Angles(0, angle, time * 2)
                    
                    --// SPIN VELOCITY
                    part.RotVelocity = Vector3.new(0, 100, 0)
                end
                
                --// EYE POSITION (Bottom center)
                Eye.CFrame = CFrame.new(center.X, center.Y - 5, center.Z)
                
                --// ANIMATE DEBRIS ORBITING
                for i, debris in ipairs(debrisParts) do
                    local debrisAngle = time * 2 + (i / #debrisParts) * math.pi * 2
                    local debrisRadius = 15 + math.sin(time + i) * 10
                    local debrisHeight = math.sin(time * 3 + i) * 20
                    
                    debris.Position = Vector3.new(
                        center.X + math.cos(debrisAngle) * debrisRadius,
                        center.Y + debrisHeight,
                        center.Z + math.sin(debrisAngle) * debrisRadius
                    )
                    debris.Rotation = Vector3.new(
                        math.random(-360, 360),
                        math.random(-360, 360),
                        math.random(-360, 360)
                    )
                end
                
                --// PULL NEARBY OBJECTS (ATTRACTION FORCE)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") and obj ~= HumanoidRootPart and obj.Parent ~= Tornado then
                        local dist = (obj.Position - center).Magnitude
                        
                        --// ATTRACTION ZONE
                        if dist < radius * 2.5 and dist > 5 then
                            local pullDir = (center - obj.Position).Unit
                            local pullStrength = (1 - dist / (radius * 2.5)) * 100 -- Stronger when closer
                            
                            --// APPLY VELOCITY
                            obj.Velocity = obj.Velocity + pullDir * pullStrength * dt
                            obj.RotVelocity = obj.RotVelocity + Vector3.new(
                                math.random(-50, 50),
                                math.random(-50, 50),
                                math.random(-50, 50)
                            )
                            
                            --// UNANCHOR PROPS (if anchored)
                            if obj.Anchored then
                                obj.Anchored = false
                            end
                        end
                        
                        --// DESTRUCTION ZONE (Close to center)
                        if dist < 8 then
                            --// Fling object upward
                            obj.Velocity = Vector3.new(
                                math.random(-100, 100),
                                200,
                                math.random(-100, 100)
                            )
                            
                            --// Color change to show damage
                            obj.Color = Color3.fromRGB(255, 0, 0)
                            
                            --// Optional: Break weld constraints
                            for _, constraint in ipairs(obj:GetChildren()) do
                                if constraint:IsA("Weld") or constraint:IsA("WeldConstraint") then
                                    constraint:Destroy()
                                end
                            end
                        end
                    end
                end
                
                --// PLAYER EFFECTS (If inside tornado)
                local playerDist = (HumanoidRootPart.Position - center).Magnitude
                if playerDist < radius then
                    --// Screen shake
                    Camera.CFrame = Camera.CFrame * CFrame.new(
                        math.sin(time * 20) * 0.5,
                        math.cos(time * 20) * 0.5,
                        0
                    )
                    
                    --// Wind sound effect (visual text)
                    --// Note: Actual sound requires asset ID
                end
                
                --// LIGHTNING EFFECT (Random)
                if math.random(1, 100) == 1 then
                    local Lightning = Instance.new("Part")
                    Lightning.Size = Vector3.new(0.5, math.random(20, 50), 0.5)
                    Lightning.Color = Color3.fromRGB(255, 255, 255)
                    Lightning.Material = Enum.Material.Neon
                    Lightning.Position = center + Vector3.new(
                        math.random(-radius, radius),
                        math.random(0, height),
                        math.random(-radius, radius)
                    )
                    Lightning.Parent = Workspace
                    
                    game.Debris:AddItem(Lightning, 0.1)
                end
            end)
            
            --// STORE FOR CLEANUP
            _G.GratacaTornado = {
                Model = Tornado,
                Connection = tornadoConnection,
                Parts = vortexParts,
                Debris = debrisParts
            }
            
            --// NOTIFICATION
            game.StarterGui:SetCore("SendNotification", {
                Title = "GRATACAAI",
                Text = "LEVIATHAN TORNADO aktif! Semua prop ditarik ke pusat vortex! 👿",
                Duration = 5
            })
            
        else
            --// DEACTIVATE & CLEANUP
            if _G.GratacaTornado then
                _G.GratacaTornado.Connection:Disconnect()
                
                --// DESTROY ALL PARTS
                for _, part in ipairs(_G.GratacaTornado.Parts) do
                    if part then part:Destroy() end
                end
                for _, debris in ipairs(_G.GratacaTornado.Debris) do
                    if debris then debris:Destroy() end
                end
                
                _G.GratacaTornado.Model:Destroy()
                _G.GratacaTornado = nil
            end
            
            game.StarterGui:SetCore("SendNotification", {
                Title = "GRATACAAI",
                Text = "Tornado dimatikan. Area aman kembali. 🗿",
                Duration = 3
            })
        end
    end
)
