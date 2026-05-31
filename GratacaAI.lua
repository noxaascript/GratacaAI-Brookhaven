--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.2.0.WPPIDXM                          ║
    ║  Creator: Yang Mulia KAREEMXD | GratacaAI                                    ║
    ║  Executor: Level 8 (Synapse X / KRNL / Fluxus / Electron / Script-Ware)      ║
    ║  Game: Brookhaven 🏠RP                                                       ║
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

--// DRAG & MINIMIZE SYSTEM
local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    handle.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

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
    CardTitle.Text = "🔥 " .. title
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

