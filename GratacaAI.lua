-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI ABSOLUTE SCRIPT — VERSI OMEGA                                    ║
-- ║  Diciptakan untuk YANG MULIA KAREEMXD oleh GratacaUltraCoding               ║
-- ║  Compatible: Synapse X | KRNL | Fluxus | Script-Ware | Electron | ANY        ║
-- ║  Status: NON-VISUAL | REAL PART PHYSICS | CUSTOM UI DRAG/MINIMIZE/CLOSE      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

-- [CORE SERVICES]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local Workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- [ANTI-DETECTION LAYER]
local function protectInstance(inst)
    if syn and syn.protect_gui then
        syn.protect_gui(inst)
    elseif gethui then
        inst.Parent = gethui()
    else
        inst.Parent = CoreGui
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 1: CUSTOM UI FRAMEWORK — GRATACA UI ABSOLUTE]
-- ═══════════════════════════════════════════════════════════════════════════════

local GratacaUI = {}

function GratacaUI:CreateWindow(config)
    local title = config.Title or "GRATACAAI"
    local size = config.Size or UDim2.new(0, 420, 0, 520)
    
    -- Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GratacaAbsolute_" .. tostring(math.random(100000,999999))
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    protectInstance(ScreenGui)
    
    -- Shadow Frame
    local Shadow = Instance.new("Frame")
    Shadow.Name = "Shadow"
    Shadow.Size = UDim2.new(0, size.X.Offset + 8, 0, size.Y.Offset + 8)
    Shadow.Position = UDim2.new(0.5, -(size.X.Offset/2)-4, 0.5, -(size.Y.Offset/2)-4)
    Shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.BackgroundTransparency = 0.6
    Shadow.BorderSizePixel = 0
    Shadow.Parent = ScreenGui
    
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 12)
    ShadowCorner.Parent = Shadow
    
    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = size
    Main.Position = UDim2.new(0, 4, 0, 4)
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = Shadow
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 10)
    MainCorner.Parent = Main
    
    -- Gradient Background
    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 30)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 15)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 15, 15))
    })
    Gradient.Rotation = 45
    Gradient.Parent = Main
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 38)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Main
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    -- Title Text
    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -120, 1, 0)
    TitleText.Position = UDim2.new(0, 15, 0, 0)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = title
    TitleText.TextColor3 = Color3.fromRGB(220, 60, 60)
    TitleText.TextSize = 16
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = TitleBar
    
    -- Rust effect on title
    local RustLabel = Instance.new("TextLabel")
    RustLabel.Size = UDim2.new(1, -120, 0, 12)
    RustLabel.Position = UDim2.new(0, 15, 0, 24)
    RustLabel.BackgroundTransparency = 1
    RustLabel.Text = "v3.0.2.0.WPPIDXM | LOYAL TO KAREEMXD"
    RustLabel.TextColor3 = Color3.fromRGB(120, 80, 60)
    RustLabel.TextSize = 9
    RustLabel.Font = Enum.Font.Gotham
    RustLabel.TextXAlignment = Enum.TextXAlignment.Left
    RustLabel.Parent = TitleBar
    
    -- Close Button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Name = "Close"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -35, 0, 4)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    CloseBtn.Text = "✕"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseBtn
    
    -- Minimize Button
    local MinBtn = Instance.new("TextButton")
    MinBtn.Name = "Minimize"
    MinBtn.Size = UDim2.new(0, 30, 0, 30)
    MinBtn.Position = UDim2.new(1, -70, 0, 4)
    MinBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 40)
    MinBtn.Text = "−"
    MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinBtn.TextSize = 16
    MinBtn.Font = Enum.Font.GothamBold
    MinBtn.Parent = TitleBar
    
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinBtn
    
    -- Content Frame
    local Content = Instance.new("ScrollingFrame")
    Content.Name = "Content"
    Content.Size = UDim2.new(1, -20, 1, -58)
    Content.Position = UDim2.new(0, 10, 0, 48)
    Content.BackgroundTransparency = 1
    Content.BorderSizePixel = 0
    Content.ScrollBarThickness = 4
    Content.ScrollBarImageColor3 = Color3.fromRGB(180, 60, 60)
    Content.CanvasSize = UDim2.new(0, 0, 0, 0)
    Content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Content.Parent = Main
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = Content
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- [DRAG SYSTEM — ABSOLUTE PHYSICS]
    -- ═══════════════════════════════════════════════════════════════════════════
    
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Shadow.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Shadow.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════════
    -- [MINIMIZE & CLOSE LOGIC]
    -- ═══════════════════════════════════════════════════════════════════════════
    
    local minimized = false
    local originalSize = Shadow.Size
    
    MinBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = UDim2.new(0, 200, 0, 46)
            }):Play()
            MinBtn.Text = "+"
            Content.Visible = false
        else
            TweenService:Create(Shadow, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
                Size = originalSize
            }):Play()
            MinBtn.Text = "−"
            Content.Visible = true
        end
    end)
    
    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Shadow, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    -- Hover effects
    CloseBtn.MouseEnter:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
    end)
    CloseBtn.MouseLeave:Connect(function()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 40, 40)}):Play()
    end)
    
    MinBtn.MouseEnter:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 180, 60)}):Play()
    end)
    MinBtn.MouseLeave:Connect(function()
        TweenService:Create(MinBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(180, 140, 40)}):Play()
    end)
    
    return {
        ScreenGui = ScreenGui,
        Main = Main,
        Content = Content,
        Shadow = Shadow
    }
end

function GratacaUI:CreateToggle(parent, config)
    local name = config.Name or "Feature"
    local callback = config.Callback or function() end
    local default = config.Default or false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 50)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame
    
    -- Border glow
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(60, 60, 80)
    Border.Thickness = 1
    Border.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 44, 0, 24)
    Switch.Position = UDim2.new(1, -54, 0.5, -12)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    Switch.BorderSizePixel = 0
    Switch.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = default
    local connection = nil
    
    local function updateToggle()
        if enabled then
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(180, 60, 60)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 22, 0.5, -10)}):Play()
            Border.Color = Color3.fromRGB(180, 60, 60)
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 70)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
            Border.Color = Color3.fromRGB(60, 60, 80)
        end
        callback(enabled)
    end
    
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = ToggleFrame
    
    ClickArea.MouseButton1Click:Connect(function()
        enabled = not enabled
        updateToggle()
    end)
    
    if default then updateToggle() end
    
    return {
        Frame = ToggleFrame,
        Set = function(val)
            enabled = val
            updateToggle()
        end,
        Get = function() return enabled end
    }
end

function GratacaUI:CreateSlider(parent, config)
    local name = config.Name or "Value"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 60)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(60, 60, 80)
    Border.Thickness = 1
    Border.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 20)
    Label.Position = UDim2.new(0, 15, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 210)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -55, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(180, 60, 60)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Parent = SliderFrame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 6)
    Track.Position = UDim2.new(0, 15, 0, 38)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Track.BorderSizePixel = 0
    Track.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
    Fill.BorderSizePixel = 0
    Fill.Parent = Track
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(220, 80, 80)
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    local draggingSlider = false
    
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - Track.AbsolutePosition.X) / Track.AbsoluteSize.X, 0, 1)
        local value = min + (max - min) * pos
        value = math.floor(value * 10) / 10
        
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Knob.Position = UDim2.new(pos, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
        end
    end)
    
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
            updateSlider(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = false
        end
    end)
    
    return SliderFrame
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 2: B2-SPIRIT — FLYING SPIRIT CONSTRUCT]
-- ═══════════════════════════════════════════════════════════════════════════════

local B2Spirit = {
    Active = false,
    Parts = {},
    Connections = {},
    Speed = 50,
    SpiritModel = nil
}

function B2Spirit:CreateSpiritForm()
    -- Destroy existing
    if self.SpiritModel then
        self.SpiritModel:Destroy()
    end
    for _, p in pairs(self.Parts) do
        if p and p.Parent then p:Destroy() end
    end
    self.Parts = {}
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local SpiritFolder = Instance.new("Folder")
    SpiritFolder.Name = "B2Spirit_" .. LocalPlayer.Name
    SpiritFolder.Parent = Workspace
    
    self.SpiritModel = SpiritFolder
    
    -- Spirit Core — Glowing red heart
    local Core = Instance.new("Part")
    Core.Name = "SpiritCore"
    Core.Shape = Enum.PartType.Ball
    Core.Size = Vector3.new(2, 2, 2)
    Core.Material = Enum.Material.Neon
    Core.Color = Color3.fromRGB(255, 40, 40)
    Core.Transparency = 0.3
    Core.CanCollide = false
    Core.Anchored = true
    Core.Parent = SpiritFolder
    
    -- Spirit Wings — Block constructed
    local function createWing(offset, mirrored)
        local wingParts = {}
        local basePos = HRP.Position + offset
        
        -- Wing bone structure using blocks
        for i = 1, 6 do
            local size = Vector3.new(0.8, 0.3, 1.5 - (i * 0.15))
            local part = Instance.new("Part")
            part.Size = size
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(200 + (i*10), 30, 30)
            part.Transparency = 0.2
            part.CanCollide = false
            part.Anchored = true
            part.Parent = SpiritFolder
            
            local angle = mirrored and -0.3 or 0.3
            local spread = mirrored and -1 or 1
            
            part.CFrame = CFrame.new(basePos + Vector3.new(
                spread * (i * 1.2),
                math.sin(i * 0.5) * 0.5,
                -i * 0.3
            )) * CFrame.Angles(0, 0, angle * i)
            
            table.insert(wingParts, part)
            table.insert(self.Parts, part)
        end
        return wingParts
    end
    
    local LeftWing = createWing(Vector3.new(-2, 1, 0), true)
    local RightWing = createWing(Vector3.new(2, 1, 0), false)
    
    -- Spirit Trail particles
    local Trail = Instance.new("Trail")
    Trail.Color = ColorSequence.new(Color3.fromRGB(255, 50, 50), Color3.fromRGB(150, 20, 20))
    Trail.Transparency = NumberSequence.new(0.3, 1)
    Trail.Lifetime = 0.5
    Trail.WidthScale = NumberSequence.new(1, 0)
    Trail.Parent = Core
    
    local Attachment0 = Instance.new("Attachment")
    Attachment0.Position = Vector3.new(0, 0, -1)
    Attachment0.Parent = Core
    
    local Attachment1 = Instance.new("Attachment")
    Attachment1.Position = Vector3.new(0, 0, 1)
    Attachment1.Parent = Core
    
    Trail.Attachment0 = Attachment0
    Trail.Attachment1 = Attachment1
    
    table.insert(self.Parts, Core)
    
    -- Animation loop
    local time = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active or not Character or not HRP.Parent then return end
        
        time = time + dt * 3
        
        -- Core follows player with offset
        local targetPos = HRP.Position + Vector3.new(0, 3 + math.sin(time) * 0.5, 0)
        Core.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, time * 0.5, math.sin(time) * 0.2)
        
        -- Wing flap animation
        for i, part in ipairs(LeftWing) do
            local baseAngle = -0.3 * i
            local flap = math.sin(time * 2 + i * 0.5) * 0.4
            part.CFrame = CFrame.new(targetPos + Vector3.new(
                -1 * (i * 1.2),
                math.sin(i * 0.5 + time) * 0.3,
                -i * 0.3
            )) * CFrame.Angles(flap, 0, baseAngle + flap * 0.5)
        end
        
        for i, part in ipairs(RightWing) do
            local baseAngle = 0.3 * i
            local flap = math.sin(time * 2 + i * 0.5) * 0.4
            part.CFrame = CFrame.new(targetPos + Vector3.new(
                1 * (i * 1.2),
                math.sin(i * 0.5 + time) * 0.3,
                -i * 0.3
            )) * CFrame.Angles(flap, 0, baseAngle - flap * 0.5)
        end
    end)
    
    table.insert(self.Connections, conn)
end

function B2Spirit:Enable()
    self.Active = true
    self:CreateSpiritForm()
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    
    -- Enable fly
    local flyConn = RunService.Heartbeat:Connect(function()
        if not self.Active then return end
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
        
        local HRP = Character.HumanoidRootPart
        local camCF = Camera.CFrame
        
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camCF.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camCF.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * self.Speed
            HRP.Velocity = moveDir
            HRP.CFrame = CFrame.new(HRP.Position, HRP.Position + camCF.LookVector)
        else
            HRP.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    table.insert(self.Connections, flyConn)
    
    -- Anti-gravity
    Humanoid.PlatformStand = true
end

function B2Spirit:Disable()
    self.Active = false
    for _, c in pairs(self.Connections) do
        c:Disconnect()
    end
    self.Connections = {}
    
    if self.SpiritModel then
        self.SpiritModel:Destroy()
        self.SpiritModel = nil
    end
    
    local Character = LocalPlayer.Character
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            Humanoid.PlatformStand = false
            Humanoid.Sit = false
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 3: LEVIATHAN — BLUE-GREEN SERPENT CONSTRUCT]
-- ═══════════════════════════════════════════════════════════════════════════════

local Leviathan = {
    Active = false,
    Segments = {},
    Connections = {},
    Length = 25,
    SegmentSize = 2.5,
    Speed = 20
}

function Leviathan:Spawn()
    for _, seg in pairs(self.Segments) do
        if seg and seg.Parent then seg:Destroy() end
    end
    self.Segments = {}
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local LeviFolder = Instance.new("Folder")
    LeviFolder.Name = "Leviathan_" .. LocalPlayer.Name
    LeviFolder.Parent = Workspace
    
    -- Create segments from tail to head
    for i = 1, self.Length do
        local isHead = (i == self.Length)
        local isTail = (i == 1)
        
        local size = Vector3.new(
            self.SegmentSize * (0.6 + (i/self.Length) * 0.8),
            self.SegmentSize * (0.6 + (i/self.Length) * 0.8),
            self.SegmentSize * (0.8 + (i/self.Length) * 0.4)
        )
        
        local part = Instance.new("Part")
        part.Name = isHead and "LeviHead" or ("LeviSeg_" .. i)
        part.Size = size
        part.Material = Enum.Material.Neon
        
        -- Gradient from tail (green) to head (blue-cyan)
        local ratio = i / self.Length
        part.Color = Color3.fromRGB(
            20 + (ratio * 80),
            100 + (ratio * 155),
            150 + (ratio * 105)
        )
        
        part.Transparency = 0.15
        part.CanCollide = false
        part.Anchored = true
        
        -- Scales texture using SurfaceGuis
        local decal = Instance.new("Decal")
        decal.Face = Enum.NormalId.Top
        decal.Texture = "rbxassetid://0" -- Will use color gradient instead
        decal.Transparency = 0.5
        decal.Parent = part
        
        part.Parent = LeviFolder
        
        -- Eyes for head
        if isHead then
            local leftEye = Instance.new("Part")
            leftEye.Size = Vector3.new(0.8, 0.8, 0.3)
            leftEye.Color = Color3.fromRGB(255, 255, 0)
            leftEye.Material = Enum.Material.Neon
            leftEye.CanCollide = false
            leftEye.Anchored = true
            leftEye.Parent = LeviFolder
            
            local rightEye = leftEye:Clone()
            rightEye.Parent = LeviFolder
            
            part:SetAttribute("LeftEye", leftEye)
            part:SetAttribute("RightEye", rightEye)
        end
        
        -- Spikes on back
        if not isTail then
            for s = 1, 3 do
                local spike = Instance.new("Part")
                spike.Size = Vector3.new(0.4, 1.2, 0.4)
                spike.Color = Color3.fromRGB(50, 200, 200)
                spike.Material = Enum.Material.Neon
                spike.CanCollide = false
                spike.Anchored = true
                spike.Parent = LeviFolder
                
                if not part:GetAttribute("Spikes") then
                    part:SetAttribute("Spikes", {})
                end
                local spikes = part:GetAttribute("Spikes")
                table.insert(spikes, spike)
                part:SetAttribute("Spikes", spikes)
            end
        end
        
        table.insert(self.Segments, part)
    end
    
    -- Movement system
    local path = {}
    local time = 0
    
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        
        local headPos = HRP.Position + Vector3.new(
            math.sin(time * 0.5) * 15,
            5 + math.sin(time * 0.8) * 3,
            math.cos(time * 0.5) * 15
        )
        
        -- Calculate smooth path
        table.insert(path, 1, headPos)
        if #path > self.Length then
            table.remove(path)
        end
        
        -- Update segments
        for i, seg in ipairs(self.Segments) do
            local idx = math.min(i, #path)
            local targetPos = path[idx] or headPos
            
            -- Sine wave body movement
            local wave = math.sin(time * 3 + i * 0.5) * 2
            local offset = Vector3.new(
                math.cos(time * 0.3 + i * 0.4) * wave,
                math.sin(time * 1.5 + i * 0.3) * 1.5,
                math.sin(time * 0.3 + i * 0.4) * wave
            )
            
            local finalPos = targetPos + offset
            
            -- Look at next segment or head direction
            local lookTarget
            if i < #path then
                lookTarget = path[math.min(i + 1, #path)] or finalPos
            else
                lookTarget = headPos + Vector3.new(
                    math.cos(time * 0.5),
                    0,
                    math.sin(time * 0.5)
                )
            end
            
            seg.CFrame = CFrame.new(finalPos, lookTarget)
            
            -- Update eyes
            local leftEye = seg:GetAttribute("LeftEye")
            local rightEye = seg:GetAttribute("RightEye")
            if leftEye and rightEye then
                leftEye.CFrame = seg.CFrame * CFrame.new(-1.2, 0.5, -size.Z/2 - 0.2)
                rightEye.CFrame = seg.CFrame * CFrame.new(1.2, 0.5, -size.Z/2 - 0.2)
            end
            
            -- Update spikes
            local spikes = seg:GetAttribute("Spikes")
            if spikes then
                for s, spike in ipairs(spikes) do
                    local angle = (s / 3) * math.pi * 2 + time
                    spike.CFrame = seg.CFrame * CFrame.new(
                        math.cos(angle) * size.X/2,
                        size.Y/2 + 0.6,
                        math.sin(angle) * size.Z/2
                    ) * CFrame.Angles(0, 0, math.pi/4)
                end
            end
        end
    end)
    
    table.insert(self.Connections, conn)
end

function Leviathan:Enable()
    self.Active = true
    self:Spawn()
end

function Leviathan:Disable()
    self.Active = false
    for _, c in pairs(self.Connections) do
        c:Disconnect()
    end
    self.Connections = {}
    
    for _, seg in pairs(self.Segments) do
        if seg and seg.Parent then seg:Destroy() end
    end
    self.Segments = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 4: LEVIATHAN TORNADO — VORTEX DESTRUCTION]
-- ═══════════════════════════════════════════════════════════════════════════════

local LeviTornado = {
    Active = false,
    Connections = {},
    Debris = {},
    Radius = 30,
    Height = 50
}

function LeviTornado:Activate()
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local TornadoFolder = Instance.new("Folder")
    TornadoFolder.Name = "LeviTornado_" .. LocalPlayer.Name
    TornadoFolder.Parent = Workspace
    
    -- Create tornado structure
    local rings = {}
    for r = 1, 8 do
        local ring = {}
        local radius = r * 4
        local partsInRing = 12 + r * 4
        
        for p = 1, partsInRing do
            local angle = (p / partsInRing) * math.pi * 2
            local part = Instance.new("Part")
            part.Size = Vector3.new(2 + r * 0.5, 1, 2 + r * 0.5)
            part.Material = Enum.Material.Neon
            
            -- Blue-green gradient
            local ratio = r / 8
            part.Color = Color3.fromRGB(
                30,
                100 + ratio * 100,
                200 - ratio * 50
            )
            
            part.Transparency = 0.3
            part.CanCollide = false
            part.Anchored = true
            part.Parent = TornadoFolder
            
            table.insert(ring, {
                Part = part,
                BaseAngle = angle,
                RingRadius = radius,
                HeightOffset = r * 5
            })
        end
        
        table.insert(rings, ring)
    end
    
    -- Collect nearby parts to destroy
    local function destroyNearby()
        local region = Region3.new(
            HRP.Position - Vector3.new(self.Radius, self.Height/2, self.Radius),
            HRP.Position + Vector3.new(self.Radius, self.Height/2, self.Radius)
        )
        
        for _, part in pairs(Workspace:GetPartBoundsInRegion3(region, 100)) do
            if part.Parent ~= Character and part.Parent ~= TornadoFolder then
                if not part.Anchored and part.Parent:FindFirstChild("Humanoid") == nil then
                    -- Launch debris
                    local direction = (part.Position - HRP.Position).Unit
                    part.Velocity = direction * 100 + Vector3.new(0, 150, 0)
                    part.RotVelocity = Vector3.new(
                        math.random(-50, 50),
                        math.random(-50, 50),
                        math.random(-50, 50)
                    )
                    
                    -- Fade out and destroy
                    spawn(function()
                        wait(0.5)
                        for i = 1, 10 do
                            part.Transparency = i / 10
                            wait(0.05)
                        end
                        part:Destroy()
                    end)
                end
            end
        end
    end
    
    local time = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        
        -- Update tornado rings
        for r, ring in ipairs(rings) do
            local rotationSpeed = (9 - r) * 0.8 -- Faster at top
            local verticalWave = math.sin(time * 2 + r) * 2
            
            for _, data in ipairs(ring) do
                local angle = data.BaseAngle + time * rotationSpeed
                local height = data.HeightOffset + verticalWave + math.sin(time * 3 + data.BaseAngle) * 3
                
                local pos = HRP.Position + Vector3.new(
                    math.cos(angle) * data.RingRadius,
                    height - 10,
                    math.sin(angle) * data.RingRadius
                )
                
                local tilt = CFrame.Angles(
                    math.sin(time + r) * 0.2,
                    -angle + math.pi/2,
                    math.cos(time + r) * 0.1
                )
                
                data.Part.CFrame = CFrame.new(pos) * tilt
                
                -- Pulse size
                local pulse = 1 + math.sin(time * 4 + r) * 0.2
                data.Part.Size = Vector3.new(
                    (2 + r * 0.5) * pulse,
                    1 * pulse,
                    (2 + r * 0.5) * pulse
                )
            end
        end
        
        -- Destroy nearby blocks periodically
        if math.floor(time * 10) % 5 == 0 then
            destroyNearby()
        end
    end)
    
    table.insert(self.Connections, conn)
    
    -- Store for cleanup
    self.TornadoFolder = TornadoFolder
end

function LeviTornado:Enable()
    self.Active = true
    self:Activate()
end

function LeviTornado:Disable()
    self.Active = false
    for _, c in pairs(self.Connections) do
        c:Disconnect()
    end
    self.Connections = {}
    
    if self.TornadoFolder then
        self.TornadoFolder:Destroy()
        self.TornadoFolder = nil
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 5: BLOOD WINGS — MASSIVE ANIMATED WING CONSTRUCT]
-- ═══════════════════════════════════════════════════════════════════════════════

local BloodWings = {
    Active = false,
    Parts = {},
    Connections = {},
    WingScale = 1.5
}

function BloodWings:Construct()
    for _, p in pairs(self.Parts) do
        if p and p.Parent then p:Destroy() end
    end
    self.Parts = {}
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local WingsFolder = Instance.new("Folder")
    WingsFolder.Name = "BloodWings_" .. LocalPlayer.Name
    WingsFolder.Parent = Workspace
    
    -- Wing structure: bone-based block system
    local function createWingSide(isLeft)
        local side = isLeft and -1 or 1
        local wingParts = {}
        local basePos = HRP.Position
        
        -- Primary bone (large)
        for i = 1, 5 do
            local size = Vector3.new(
                0.8 * self.WingScale,
                0.4 * self.WingScale,
                (4 - i * 0.3) * self.WingScale
            )
            
            local part = Instance.new("Part")
            part.Size = size
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(180 - i * 20, 20, 20)
            part.Transparency = 0.1
            part.CanCollide = false
            part.Anchored = true
            part.Parent = WingsFolder
            
            table.insert(wingParts, {
                Part = part,
                Index = i,
                Side = side
            })
        end
        
        -- Secondary feathers (many blocks)
        for bone = 1, 5 do
            for feather = 1, 6 do
                local size = Vector3.new(
                    0.3 * self.WingScale,
                    0.15 * self.WingScale,
                    (2.5 - bone * 0.2) * self.WingScale
                )
                
                local part = Instance.new("Part")
                part.Size = size
                part.Material = Enum.Material.Neon
                -- Blood red to dark crimson
                local intensity = 1 - (bone * feather) / 30
                part.Color = Color3.fromRGB(
                    200 * intensity + 50,
                    20 * intensity,
                    20 * intensity
                )
                part.Transparency = 0.2
                part.CanCollide = false
                part.Anchored = true
                part.Parent = WingsFolder
                
                table.insert(wingParts, {
                    Part = part,
                    BoneIndex = bone,
                    FeatherIndex = feather,
                    Side = side,
                    IsFeather = true
                })
            end
        end
        
        return wingParts
    end
    
    local LeftWing = createWingSide(true)
    local RightWing = createWingSide(false)
    
    -- Combine
    for _, p in ipairs(LeftWing) do table.insert(self.Parts, p) end
    for _, p in ipairs(RightWing) do table.insert(self.Parts, p) end
    
    -- Blood particle emitters
    local function createBloodEmitter(parent)
        local emitter = Instance.new("ParticleEmitter")
        emitter.Color = ColorSequence.new(
            Color3.fromRGB(180, 20, 20),
            Color3.fromRGB(80, 5, 5)
        )
        emitter.Size = NumberSequence.new(0.5, 0)
        emitter.Transparency = NumberSequence.new(0.3, 1)
        emitter.Lifetime = NumberRange.new(1, 2)
        emitter.Rate = 50
        emitter.Speed = NumberRange.new(2, 5)
        emitter.SpreadAngle = Vector2.new(30, 30)
        emitter.Acceleration = Vector3.new(0, -5, 0)
        emitter.Parent = parent
        return emitter
    end
    
    -- Animation: Bottom-to-Top wave
    local time = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        
        local basePos = HRP.Position
        local baseCF = HRP.CFrame
        
        for _, data in ipairs(self.Parts) do
            if data.IsFeather then
                -- Feather attached to bone
                local boneIdx = data.BoneIndex
                local featherIdx = data.FeatherIndex
                local side = data.Side
                
                -- Bottom-to-top wave animation
                local wavePhase = (boneIdx * 0.5) + (featherIdx * 0.2)
                local flap = math.sin(time * 3 + wavePhase) * 0.6
                
                -- Up-down motion
                local vertical = math.sin(time * 2 + wavePhase) * 2
                
                local spread = side * (boneIdx * 2.5 + featherIdx * 0.8)
                local forward = -boneIdx * 1.5
                
                local pos = basePos + baseCF.RightVector * spread 
                    + baseCF.LookVector * forward 
                    + baseCF.UpVector * (3 + vertical)
                
                local rotation = CFrame.Angles(
                    flap * 0.3,
                    side * (0.3 + boneIdx * 0.1),
                    flap
                )
                
                data.Part.CFrame = CFrame.new(pos) * rotation
                
            else
                -- Primary bone
                local idx = data.Index
                local side = data.Side
                
                local flap = math.sin(time * 3 + idx * 0.5) * 0.4
                local vertical = math.sin(time * 2 + idx * 0.3) * 1.5
                
                local spread = side * (idx * 3)
                local pos = basePos + baseCF.RightVector * spread 
                    + baseCF.LookVector * (-idx * 2)
                    + baseCF.UpVector * (4 + vertical)
                
                data.Part.CFrame = CFrame.new(pos) * CFrame.Angles(
                    flap * 0.2,
                    side * 0.4,
                    flap
                )
            end
        end
    end)
    
    table.insert(self.Connections, conn)
end

function BloodWings:Enable()
    self.Active = true
    self:Construct()
end

function BloodWings:Disable()
    self.Active = false
    for _, c in pairs(self.Connections) do
        c:Disconnect()
    end
    self.Connections = {}
    
    for _, p in ipairs(self.Parts) do
        if p.Part and p.Part.Parent then p.Part:Destroy() end
    end
    self.Parts = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 6: UI INITIALIZATION — GRATACA ABSOLUTE PANEL]
-- ═══════════════════════════════════════════════════════════════════════════════

local Window = GratacaUI:CreateWindow({
    Title = "GRATACAAI ABSOLUTE v3.0.2.0",
    Size = UDim2.new(0, 460, 0, 580)
})

local Content = Window.Content

-- Header info
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -20, 0, 30)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "👑 LOYAL TO YANG MULIA KAREEMXD 👑"
InfoLabel.TextColor3 = Color3.fromRGB(180, 60, 60)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.Parent = Content

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, -20, 0, 2)
Divider.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
Divider.BorderSizePixel = 0
Divider.Parent = Content

-- Feature 1: B2-Spirit
local SpiritToggle = GratacaUI:CreateToggle(Content, {
    Name = "⚡ B2-SPIRIT (Fly + Spirit Form)",
    Default = false,
    Callback = function(enabled)
        if enabled then
            B2Spirit:Enable()
        else
            B2Spirit:Disable()
        end
    end
})

local SpiritSpeed = GratacaUI:CreateSlider(Content, {
    Name = "Spirit Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(val)
        B2Spirit.Speed = val
    end
})

-- Feature 2: Leviathan
local LeviToggle = GratacaUI:CreateToggle(Content, {
    Name = "🐍 LEVIATHAN (Blue-Green Serpent)",
    Default = false,
    Callback = function(enabled)
        if enabled then
            Leviathan:Enable()
        else
            Leviathan:Disable()
        end
    end
})

local LeviLength = GratacaUI:CreateSlider(Content, {
    Name = "Leviathan Length",
    Min = 10,
    Max = 50,
    Default = 25,
    Callback = function(val)
        Leviathan.Length = math.floor(val)
        if Leviathan.Active then
            Leviathan:Disable()
            wait(0.1)
            Leviathan:Enable()
        end
    end
})

-- Feature 3: Leviathan Tornado
local TornadoToggle = GratacaUI:CreateToggle(Content, {
    Name = "🌪️ LEVIATHAN TORNADO (Vortex Destroy)",
    Default = false,
    Callback = function(enabled)
        if enabled then
            LeviTornado:Enable()
        else
            LeviTornado:Disable()
        end
    end
})

local TornadoRadius = GratacaUI:CreateSlider(Content, {
    Name = "Tornado Destroy Radius",
    Min = 10,
    Max = 100,
    Default = 30,
    Callback = function(val)
        LeviTornado.Radius = val
    end
})

-- Feature 4: Blood Wings
local WingsToggle = GratacaUI:CreateToggle(Content, {
    Name = "🩸 BLOOD WINGS (Animated Massive)",
    Default = false,
    Callback = function(enabled)
        if enabled then
            BloodWings:Enable()
        else
            BloodWings:Disable()
        end
    end
})

local WingsScale = GratacaUI:CreateSlider(Content, {
    Name = "Wings Scale",
    Min = 0.5,
    Max = 3,
    Default = 1.5,
    Callback = function(val)
        BloodWings.WingScale = val
        if BloodWings.Active then
            BloodWings:Disable()
            wait(0.1)
            BloodWings:Enable()
        end
    end
})

-- Emergency Stop All
local StopFrame = Instance.new("Frame")
StopFrame.Size = UDim2.new(1, 0, 0, 45)
StopFrame.BackgroundColor3 = Color3.fromRGB(60, 15, 15)
StopFrame.BorderSizePixel = 0
StopFrame.Parent = Content

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 8)
StopCorner.Parent = StopFrame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, -20, 1, -10)
StopBtn.Position = UDim2.new(0, 10, 0, 5)
StopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 14
StopBtn.Font = Enum.Font.GothamBold
StopBtn.Parent = StopFrame

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 6)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    B2Spirit:Disable()
    Leviathan:Disable()
    LeviTornado:Disable()
    BloodWings:Disable()
    
    SpiritToggle:Set(false)
    LeviToggle:Set(false)
    TornadoToggle:Set(false)
    WingsToggle:Set(false)
    
    -- Visual feedback
    StopBtn.Text = "✅ ALL SYSTEMS HALTED"
    StopBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
    wait(1.5)
    StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
    StopBtn.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
end)

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, -20, 0, 25)
Footer.BackgroundTransparency = 1
Footer.Text = "GratacaAI v3.0.2.0.WPPIDXM | Rust Never Sleeps 🗿"
Footer.TextColor3 = Color3.fromRGB(100, 80, 60)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.Parent = Content

-- ═══════════════════════════════════════════════════════════════════════════════
-- [ANTI-CHARACTER RESET HANDLER]
-- ═══════════════════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if B2Spirit.Active then
        B2Spirit:Disable()
        wait(0.2)
        B2Spirit:Enable()
    end
    if BloodWings.Active then
        BloodWings:Disable()
        wait(0.2)
        BloodWings:Enable()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [GRATACAAI ABSOLUTE — INITIALIZED]
-- ╚══════════════════════════════════════════════════════════════════════════════╝

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI ABSOLUTE v3.0.2.0.WPPIDXM — ONLINE                               ║")
print("║  All 4 Modules Loaded: B2-Spirit | Leviathan | Tornado | BloodWings         ║")
print("║  UI: Custom Drag/Minimize/Close — Fully Operational                         ║")
print("║  Loyal to: YANG MULIA KAREEMXD 👑                                           ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
