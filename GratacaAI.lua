-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI ABSOLUTE — UI V2: DRAG/CLOSE/MINIMIZE GUARANTEED                  ║
-- ║  Arsitektur: No Shadow Wrap | Pure Mouse Drag | Individual Input Listeners   ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game.Workspace

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

-- [ANTI-DETECTION]
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
-- [UI V2 — GRATACA ABSOLUTE SKELETON]
-- ═══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaUI_" .. tostring(math.random(100000,999999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global  -- GLOBAL untuk fix layering
ScreenGui.DisplayOrder = 999999
protectInstance(ScreenGui)

-- Main Container (NO SHADOW — langsung frame utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 440, 0, 560)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -280)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 20)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Active = true
MainFrame.Draggable = false  -- Kita handle manual, lebih reliable
MainFrame.Selectable = true
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Gradient Background
local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 32)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 16, 16))
})
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

-- ═══════════════════════════════════════════════════════════════════════════════
-- [TITLE BAR — DRAG HANDLE]
-- ═══════════════════════════════════════════════════════════════════════════════

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 44)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 200
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -150, 1, 0)
TitleText.Position = UDim2.new(0, 16, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GRATACAAI ABSOLUTE"
TitleText.TextColor3 = Color3.fromRGB(220, 50, 50)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 201
TitleText.Parent = TitleBar

local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, -150, 0, 14)
SubText.Position = UDim2.new(0, 16, 0, 26)
SubText.BackgroundTransparency = 1
SubText.Text = "v3.0.2.0.WPPIDXM | LOYAL TO KAREEMXD"
SubText.TextColor3 = Color3.fromRGB(130, 90, 70)
SubText.TextSize = 9
SubText.Font = Enum.Font.Gotham
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.ZIndex = 201
SubText.Parent = TitleBar

-- ═══════════════════════════════════════════════════════════════════════════════
-- [CONTROL BUTTONS — MINIMIZE & CLOSE]
-- ═══════════════════════════════════════════════════════════════════════════════

-- MINIMIZE BUTTON (TextButton murni — paling reliable)
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "Minimize"
MinimizeBtn.Size = UDim2.new(0, 34, 0, 34)
MinimizeBtn.Position = UDim2.new(1, -78, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(210, 170, 50)
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.AutoButtonColor = true
MinimizeBtn.ZIndex = 250  -- MAX ZIndex
MinimizeBtn.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeBtn

-- CLOSE BUTTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(210, 50, 50)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = true
CloseBtn.ZIndex = 250  -- MAX ZIndex
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

-- ═══════════════════════════════════════════════════════════════════════════════
-- [DRAG SYSTEM V2 — PURE MOUSE OBJECT]
-- ═══════════════════════════════════════════════════════════════════════════════

local isDragging = false
local dragOffset = nil

-- Kita pakai Mouse object karena paling reliable di semua executor
Mouse.Button1Down:Connect(function()
    -- Cek apakah mouse di dalam TitleBar (bukan di button)
    local mousePos = UserInputService:GetMouseLocation()
    local titleAbs = TitleBar.AbsolutePosition
    local titleSize = TitleBar.AbsoluteSize
    local minAbs = MinimizeBtn.AbsolutePosition
    local minSize = MinimizeBtn.AbsoluteSize
    local closeAbs = CloseBtn.AbsolutePosition
    local closeSize = CloseBtn.AbsoluteSize
    
    -- Check if inside TitleBar
    local inTitleBar = (
        mousePos.X >= titleAbs.X and 
        mousePos.X <= titleAbs.X + titleSize.X and
        mousePos.Y >= titleAbs.Y and 
        mousePos.Y <= titleAbs.Y + titleSize.Y
    )
    
    -- Check if NOT clicking buttons
    local inMinBtn = (
        mousePos.X >= minAbs.X and 
        mousePos.X <= minAbs.X + minSize.X and
        mousePos.Y >= minAbs.Y and 
        mousePos.Y <= minAbs.Y + minSize.Y
    )
    
    local inCloseBtn = (
        mousePos.X >= closeAbs.X and 
        mousePos.X <= closeAbs.X + closeSize.X and
        mousePos.Y >= closeAbs.Y and 
        mousePos.Y <= closeAbs.Y + closeSize.Y
    )
    
    if inTitleBar and not inMinBtn and not inCloseBtn then
        isDragging = true
        dragOffset = mousePos - MainFrame.AbsolutePosition
    end
end)

Mouse.Move:Connect(function()
    if isDragging and dragOffset then
        local newPos = UserInputService:GetMouseLocation() - dragOffset
        MainFrame.Position = UDim2.new(0, newPos.X, 0, newPos.Y)
    end
end)

Mouse.Button1Up:Connect(function()
    isDragging = false
    dragOffset = nil
end)

-- Also handle via UserInputService as backup
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
        dragOffset = nil
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MINIMIZE LOGIC — SIZE TWEEN]
-- ═══════════════════════════════════════════════════════════════════════════════

local isMinimized = false
local originalSize = MainFrame.Size
local originalContentVisible = true

-- Content container (untuk hide/show saat minimize)
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -60)
ContentFrame.Position = UDim2.new(0, 10, 0, 54)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ZIndex = 50
ContentFrame.Parent = MainFrame

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 10)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentFrame

-- Canvas untuk scrolling
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 4
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 60, 60)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollFrame.ZIndex = 51
ScrollFrame.Parent = ContentFrame

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Padding = UDim.new(0, 10)
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Parent = ScrollFrame

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Simpan state
        originalContentVisible = true
        
        -- Tween kecil
        TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
            Size = UDim2.new(0, 220, 0, 48)
        }):Play()
        
        -- Hide semua content
        for _, child in pairs(ContentFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                child.Visible = false
            end
        end
        ContentFrame.Visible = false
        
        MinimizeBtn.Text = "+"
        TitleText.Text = "GRATACAAI"
        
    else
        -- Restore
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size = originalSize
        }):Play()
        
        -- Show semua content
        ContentFrame.Visible = true
        for _, child in pairs(ContentFrame:GetDescendants()) do
            if child:IsA("GuiObject") then
                child.Visible = true
            end
        end
        
        MinimizeBtn.Text = "−"
        TitleText.Text = "GRATACAAI ABSOLUTE"
    end
end)

-- Hover effects
MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 200, 70)
    }):Play()
end)

MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(210, 170, 50)
    }):Play()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [CLOSE LOGIC — DESTROY DENGAN FADE]
-- ═══════════════════════════════════════════════════════════════════════════════

CloseBtn.MouseButton1Click:Connect(function()
    -- Kill all modules dulu
    _G.GratacaStopAll()
    
    -- Fade out
    TweenService:Create(MainFrame, TweenInfo.new(0.15), {
        BackgroundTransparency = 1
    }):Play()
    
    for _, child in pairs(MainFrame:GetDescendants()) do
        if child:IsA("GuiObject") then
            if child:IsA("TextLabel") or child:IsA("TextButton") then
                TweenService:Create(child, TweenInfo.new(0.1), {
                    TextTransparency = 1,
                    BackgroundTransparency = 1
                }):Play()
            elseif child:IsA("Frame") then
                TweenService:Create(child, TweenInfo.new(0.1), {
                    BackgroundTransparency = 1
                }):Play()
            end
        end
    end
    
    wait(0.2)
    ScreenGui:Destroy()
end)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    }):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.1), {
        BackgroundColor3 = Color3.fromRGB(210, 50, 50)
    }):Play()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [HELPER: CREATE TOGGLE]
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateToggle(parent, config)
    local name = config.Name or "Feature"
    local callback = config.Callback or function() end
    local default = config.Default or false
    
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, -10, 0, 55)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.ZIndex = 100
    ToggleFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = ToggleFrame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(75, 75, 100)
    Border.Thickness = 1.5
    Border.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -85, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(215, 215, 230)
    Label.TextSize = 14
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 101
    Label.Parent = ToggleFrame
    
    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 52, 0, 28)
    Switch.Position = UDim2.new(1, -62, 0.5, -14)
    Switch.BackgroundColor3 = Color3.fromRGB(60, 60, 75)
    Switch.BorderSizePixel = 0
    Switch.ZIndex = 102
    Switch.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = Switch
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 24, 0, 24)
    Circle.Position = UDim2.new(0, 2, 0.5, -12)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.ZIndex = 103
    Circle.Parent = Switch
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = default
    
    local function updateToggle()
        if enabled then
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            }):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 26, 0.5, -12)
            }):Play()
            Border.Color = Color3.fromRGB(200, 60, 60)
        else
            TweenService:Create(Switch, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 75)
            }):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {
                Position = UDim2.new(0, 2, 0.5, -12)
            }):Play()
            Border.Color = Color3.fromRGB(75, 75, 100)
        end
        callback(enabled)
    end
    
    -- Click area (TextButton untuk reliability)
    local Clicker = Instance.new("TextButton")
    Clicker.Size = UDim2.new(1, 0, 1, 0)
    Clicker.BackgroundTransparency = 1
    Clicker.Text = ""
    Clicker.ZIndex = 110
    Clicker.Parent = ToggleFrame
    
    Clicker.MouseButton1Click:Connect(function()
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

-- ═══════════════════════════════════════════════════════════════════════════════
-- [HELPER: CREATE SLIDER]
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateSlider(parent, config)
    local name = config.Name or "Value"
    local min = config.Min or 0
    local max = config.Max or 100
    local default = config.Default or min
    local callback = config.Callback or function() end
    
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, -10, 0, 65)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.ZIndex = 100
    SliderFrame.Parent = parent
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = SliderFrame
    
    local Border = Instance.new("UIStroke")
    Border.Color = Color3.fromRGB(75, 75, 100)
    Border.Thickness = 1.5
    Border.Parent = SliderFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -75, 0, 24)
    Label.Position = UDim2.new(0, 15, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(215, 215, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamSemibold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 101
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 24)
    ValueLabel.Position = UDim2.new(1, -65, 0, 6)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.ZIndex = 101
    ValueLabel.Parent = SliderFrame
    
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -30, 0, 8)
    Track.Position = UDim2.new(0, 15, 0, 44)
    Track.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
    Track.BorderSizePixel = 0
    Track.ZIndex = 102
    Track.Parent = SliderFrame
    
    local TrackCorner = Instance.new("UICorner")
    TrackCorner.CornerRadius = UDim.new(1, 0)
    TrackCorner.Parent = Track
    
    local Fill = Instance.new("Frame")
    local ratio = (default - min) / (max - min)
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 103
    Fill.Parent = Track
    
    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill
    
    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.Position = UDim2.new(ratio, -9, 0.5, -9)
    Knob.BackgroundColor3 = Color3.fromRGB(235, 85, 85)
    Knob.Text = ""
    Knob.AutoButtonColor = false
    Knob.ZIndex = 104
    Knob.Parent = Track
    
    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob
    
    local draggingSlider = false
    
    local function updateSlider(input)
        local trackAbs = Track.AbsolutePosition.X
        local trackSize = Track.AbsoluteSize.X
        local relativeX = math.clamp((input.Position.X - trackAbs) / trackSize, 0, 1)
        local value = min + (max - min) * relativeX
        value = math.floor(value * 10) / 10
        
        Fill.Size = UDim2.new(relativeX, 0, 1, 0)
        Knob.Position = UDim2.new(relativeX, -9, 0.5, -9)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    Knob.MouseButton1Down:Connect(function()
        draggingSlider = true
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
    
    local Core = Instance.new("Part")
    Core.Name = "SpiritCore"
    Core.Shape = Enum.PartType.Ball
    Core.Size = Vector3.new(2.5, 2.5, 2.5)
    Core.Material = Enum.Material.Neon
    Core.Color = Color3.fromRGB(255, 35, 35)
    Core.Transparency = 0.2
    Core.CanCollide = false
    Core.Anchored = true
    Core.Parent = SpiritFolder
    
    local PointLight = Instance.new("PointLight")
    PointLight.Color = Color3.fromRGB(255, 50, 50)
    PointLight.Brightness = 5
    PointLight.Range = 15
    PointLight.Parent = Core
    
    local function createWing(offset, mirrored)
        local wingParts = {}
        for i = 1, 7 do
            local size = Vector3.new(1, 0.4, 2.2 - (i * 0.2))
            local part = Instance.new("Part")
            part.Size = size
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(220 + (i*8), 25, 25)
            part.Transparency = 0.15
            part.CanCollide = false
            part.Anchored = true
            part.Parent = SpiritFolder
            
            local angle = mirrored and -0.35 or 0.35
            local spread = mirrored and -1 or 1
            
            part.CFrame = CFrame.new(HRP.Position + offset + Vector3.new(
                spread * (i * 1.4),
                math.sin(i * 0.6) * 0.6,
                -i * 0.4
            )) * CFrame.Angles(0, 0, angle * i)
            
            table.insert(wingParts, part)
            table.insert(self.Parts, part)
        end
        return wingParts
    end
    
    local LeftWing = createWing(Vector3.new(-2.5, 1.2, 0), true)
    local RightWing = createWing(Vector3.new(2.5, 1.2, 0), false)
    
    local Trail = Instance.new("Trail")
    Trail.Color = ColorSequence.new(Color3.fromRGB(255, 40, 40), Color3.fromRGB(140, 15, 15))
    Trail.Transparency = NumberSequence.new(0.2, 1)
    Trail.Lifetime = 0.6
    Trail.WidthScale = NumberSequence.new(1.2, 0)
    Trail.Parent = Core
    
    local Attachment0 = Instance.new("Attachment")
    Attachment0.Position = Vector3.new(0, 0, -1.2)
    Attachment0.Parent = Core
    
    local Attachment1 = Instance.new("Attachment")
    Attachment1.Position = Vector3.new(0, 0, 1.2)
    Attachment1.Parent = Core
    
    Trail.Attachment0 = Attachment0
    Trail.Attachment1 = Attachment1
    
    table.insert(self.Parts, Core)
    
    local time = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active or not Character or not HRP.Parent then return end
        time = time + dt * 3
        
        local targetPos = HRP.Position + Vector3.new(0, 3.5 + math.sin(time) * 0.8, 0)
        Core.CFrame = CFrame.new(targetPos) * CFrame.Angles(0, time * 0.6, math.sin(time) * 0.25)
        
        for i, part in ipairs(LeftWing) do
            local flap = math.sin(time * 2.2 + i * 0.6) * 0.5
            part.CFrame = CFrame.new(targetPos + Vector3.new(
                -1.2 * (i * 1.4),
                math.sin(i * 0.6 + time) * 0.4,
                -i * 0.4
            )) * CFrame.Angles(flap, 0, -0.35 * i + flap * 0.6)
        end
        
        for i, part in ipairs(RightWing) do
            local flap = math.sin(time * 2.2 + i * 0.6) * 0.5
            part.CFrame = CFrame.new(targetPos + Vector3.new(
                1.2 * (i * 1.4),
                math.sin(i * 0.6 + time) * 0.4,
                -i * 0.4
            )) * CFrame.Angles(flap, 0, 0.35 * i - flap * 0.6)
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
-- [MODULE 3: LEVIATHAN — BLUE-GREEN SERPENT]
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
    
    for i = 1, self.Length do
        local isHead = (i == self.Length)
        
        local size = Vector3.new(
            self.SegmentSize * (0.7 + (i/self.Length) * 0.9),
            self.SegmentSize * (0.7 + (i/self.Length) * 0.9),
            self.SegmentSize * (0.9 + (i/self.Length) * 0.5)
        )
        
        local part = Instance.new("Part")
        part.Name = isHead and "LeviHead" or ("LeviSeg_" .. i)
        part.Size = size
        part.Material = Enum.Material.Neon
        
        local ratio = i / self.Length
        part.Color = Color3.fromRGB(
            20 + (ratio * 90),
            110 + (ratio * 145),
            160 + (ratio * 95)
        )
        
        part.Transparency = 0.1
        part.CanCollide = false
        part.Anchored = true
        
        if isHead then
            local leftEye = Instance.new("Part")
            leftEye.Size = Vector3.new(1, 1, 0.4)
            leftEye.Color = Color3.fromRGB(255, 255, 40)
            leftEye.Material = Enum.Material.Neon
            leftEye.CanCollide = false
            leftEye.Anchored = true
            leftEye.Parent = LeviFolder
            
            local rightEye = leftEye:Clone()
            rightEye.Parent = LeviFolder
            
            part:SetAttribute("LeftEye", leftEye)
            part:SetAttribute("RightEye", rightEye)
        end
        
        part.Parent = LeviFolder
        table.insert(self.Segments, part)
    end
    
    local path = {}
    local time = 0
    
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        
        local headPos = HRP.Position + Vector3.new(
            math.sin(time * 0.5) * 18,
            6 + math.sin(time * 0.9) * 4,
            math.cos(time * 0.5) * 18
        )
        
        table.insert(path, 1, headPos)
        if #path > self.Length then
            table.remove(path)
        end
        
        for i, seg in ipairs(self.Segments) do
            local idx = math.min(i, #path)
            local targetPos = path[idx] or headPos
            
            local wave = math.sin(time * 3 + i * 0.6) * 2.5
            local offset = Vector3.new(
                math.cos(time * 0.35 + i * 0.45) * wave,
                math.sin(time * 1.6 + i * 0.35) * 2,
                math.sin(time * 0.35 + i * 0.45) * wave
            )
            
            local finalPos = targetPos + offset
            
            local lookTarget
            if i < #path then
                lookTarget = path[math.min(i + 1, #path)] or finalPos
            else
                lookTarget = headPos + Vector3.new(
                    math.cos(time * 0.6),
                    0,
                    math.sin(time * 0.6)
                )
            end
            
            seg.CFrame = CFrame.new(finalPos, lookTarget)
            
            local leftEye = seg:GetAttribute("LeftEye")
            local rightEye = seg:GetAttribute("RightEye")
            if leftEye and rightEye then
                leftEye.CFrame = seg.CFrame * CFrame.new(-1.4, 0.6, -seg.Size.Z/2 - 0.3)
                rightEye.CFrame = seg.CFrame * CFrame.new(1.4, 0.6, -seg.Size.Z/2 - 0.3)
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
    
    local rings = {}
    for r = 1, 8 do
        local ring = {}
        local radius = r * 4
        local partsInRing = 14 + r * 4
        
        for p = 1, partsInRing do
            local angle = (p / partsInRing) * math.pi * 2
            local part = Instance.new("Part")
            part.Size = Vector3.new(2.5 + r * 0.6, 1.2, 2.5 + r * 0.6)
            part.Material = Enum.Material.Neon
            
            local ratio = r / 8
            part.Color = Color3.fromRGB(
                30,
                110 + ratio * 110,
                210 - ratio * 60
            )
            
            part.Transparency = 0.25
            part.CanCollide = false
            part.Anchored = true
            part.Parent = TornadoFolder
            
            table.insert(ring, {
                Part = part,
                BaseAngle = angle,
                RingRadius = radius,
                HeightOffset = r * 5.5
            })
        end
        
        table.insert(rings, ring)
    end
    
    local function destroyNearby()
        local overlapParams = OverlapParams.new()
        overlapParams.FilterDescendantsInstances = {Character, TornadoFolder}
        overlapParams.FilterType = Enum.RaycastFilterType.Blacklist
        overlapParams.MaxParts = 200
        
        local parts = Workspace:GetPartBoundsInRadius(HRP.Position, self.Radius, overlapParams)
        
        for _, part in pairs(parts) do
            if part.Parent ~= Character and part.Parent ~= TornadoFolder then
                if not part.Anchored and part.Parent:FindFirstChild("Humanoid") == nil then
                    local direction = (part.Position - HRP.Position).Unit
                    part.Velocity = direction * 120 + Vector3.new(0, 180, 0)
                    part.RotVelocity = Vector3.new(
                        math.random(-60, 60),
                        math.random(-60, 60),
                        math.random(-60, 60)
                    )
                    
                    spawn(function()
                        wait(0.4)
                        for i = 1, 8 do
                            if part and part.Parent then
                                part.Transparency = i / 8
                                wait(0.06)
                            end
                        end
                        if part and part.Parent then
                            part:Destroy()
                        end
                    end)
                end
            end
        end
    end
    
    local time = 0
    local destroyTimer = 0
    
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        destroyTimer = destroyTimer + dt
        
        for r, ring in ipairs(rings) do
            local rotationSpeed = (9 - r) * 1.0
            local verticalWave = math.sin(time * 2.2 + r) * 2.5
            
            for _, data in ipairs(ring) do
                local angle = data.BaseAngle + time * rotationSpeed
                local height = data.HeightOffset + verticalWave + math.sin(time * 3.5 + data.BaseAngle) * 3.5
                
                local pos = HRP.Position + Vector3.new(
                    math.cos(angle) * data.RingRadius,
                    height - 12,
                    math.sin(angle) * data.RingRadius
                )
                
                local tilt = CFrame.Angles(
                    math.sin(time + r * 0.8) * 0.25,
                    -angle + math.pi/2,
                    math.cos(time + r * 0.8) * 0.15
                )
                
                data.Part.CFrame = CFrame.new(pos) * tilt
                
                local pulse = 1 + math.sin(time * 4.5 + r) * 0.25
                data.Part.Size = Vector3.new(
                    (2.5 + r * 0.6) * pulse,
                    1.2 * pulse,
                    (2.5 + r * 0.6) * pulse
                )
            end
        end
        
        if destroyTimer >= 0.15 then
            destroyTimer = 0
            destroyNearby()
        end
    end)
    
    table.insert(self.Connections, conn)
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
-- [MODULE 5: BLOOD WINGS — MASSIVE BLOCK CONSTRUCT]
-- ═══════════════════════════════════════════════════════════════════════════════

local BloodWings = {
    Active = false,
    Parts = {},
    Connections = {},
    WingScale = 2.5
}

function BloodWings:Construct()
    for _, p in pairs(self.Parts) do
        if p and p.Part and p.Part.Parent then p.Part:Destroy() end
    end
    self.Parts = {}
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local WingsFolder = Instance.new("Folder")
    WingsFolder.Name = "BloodWings_" .. LocalPlayer.Name
    WingsFolder.Parent = Workspace
    
    local S = self.WingScale
    
    local function createWingSide(isLeft)
        local side = isLeft and -1 or 1
        local wingData = {}
        
        -- PRIMARY BONES (5 besar)
        for i = 1, 5 do
            local size = Vector3.new(
                1.2 * S,
                0.6 * S,
                (5.5 - i * 0.4) * S
            )
            
            local part = Instance.new("Part")
            part.Size = size
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(190 - i * 25, 15, 15)
            part.Transparency = 0.08
            part.CanCollide = false
            part.Anchored = true
            part.Parent = WingsFolder
            
            table.insert(wingData, {
                Part = part,
                Index = i,
                Side = side,
                IsBone = true
            })
        end
        
        -- SECONDARY FEATHERS (6 per bone)
        for bone = 1, 5 do
            for feather = 1, 6 do
                local size = Vector3.new(
                    0.5 * S,
                    0.25 * S,
                    (3.5 - bone * 0.25) * S
                )
                
                local part = Instance.new("Part")
                part.Size = size
                part.Material = Enum.Material.Neon
                
                local intensity = 1 - (bone * feather) / 30
                part.Color = Color3.fromRGB(
                    210 * intensity + 40,
                    18 * intensity,
                    18 * intensity
                )
                part.Transparency = 0.15
                part.CanCollide = false
                part.Anchored = true
                part.Parent = WingsFolder
                
                table.insert(wingData, {
                    Part = part,
                    BoneIndex = bone,
                    FeatherIndex = feather,
                    Side = side,
                    IsFeather = true
                })
            end
        end
        
        -- TERTIARY SMALL FEATHERS
        for bone = 1, 5 do
            for feather = 1, 4 do
                local size = Vector3.new(
                    0.3 * S,
                    0.15 * S,
                    (2 - bone * 0.15) * S
                )
                
                local part = Instance.new("Part")
                part.Size = size
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(160, 10, 10)
                part.Transparency = 0.25
                part.CanCollide = false
                part.Anchored = true
                part.Parent = WingsFolder
                
                table.insert(wingData, {
                    Part = part,
                    BoneIndex = bone,
                    FeatherIndex = feather,
                    Side = side,
                    IsTiny = true
                })
            end
        end
        
        return wingData
    end
    
    local LeftWing = createWingSide(true)
    local RightWing = createWingSide(false)
    
    for _, p in ipairs(LeftWing) do table.insert(self.Parts, p) end
    for _, p in ipairs(RightWing) do table.insert(self.Parts, p) end
    
    local time = 0
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active then return end
        if not Character or not HRP.Parent then return end
        
        time = time + dt
        
        local basePos = HRP.Position
        local baseCF = HRP.CFrame
        local S = self.WingScale
        
        for _, data in ipairs(self.Parts) do
            if data.IsFeather then
                local boneIdx = data.BoneIndex
                local featherIdx = data.FeatherIndex
                local side = data.Side
                
                local wavePhase = (boneIdx * 0.6) + (featherIdx * 0.25)
                local flap = math.sin(time * 2.8 + wavePhase) * 0.8
                
                local vertical = math.sin(time * 2.2 + wavePhase) * 3.5 * S
                
                local spread = side * (boneIdx * 3.5 * S + featherIdx * 1.2 * S)
                local forward = -boneIdx * 2.2 * S
                
                local pos = basePos + baseCF.RightVector * spread 
                    + baseCF.LookVector * forward 
                    + baseCF.UpVector * (4 * S + vertical)
                
                local rotation = CFrame.Angles(
                    flap * 0.4,
                    side * (0.4 + boneIdx * 0.15),
                    flap * 1.2
                )
                
                data.Part.CFrame = CFrame.new(pos) * rotation
                
            elseif data.IsTiny then
                local boneIdx = data.BoneIndex
                local featherIdx = data.FeatherIndex
                local side = data.Side
                
                local wavePhase = (boneIdx * 0.6) + (featherIdx * 0.3)
                local flap = math.sin(time * 2.8 + wavePhase + 0.5) * 0.6
                
                local spread = side * (boneIdx * 3.5 * S + featherIdx * 1.5 * S + 0.8 * S)
                local forward = -boneIdx * 2.2 * S - 0.5 * S
                local vertical = math.sin(time * 2.2 + wavePhase + 0.3) * 3 * S
                
                local pos = basePos + baseCF.RightVector * spread 
                    + baseCF.LookVector * forward 
                    + baseCF.UpVector * (4.2 * S + vertical)
                
                data.Part.CFrame = CFrame.new(pos) * CFrame.Angles(
                    flap * 0.3,
                    side * (0.35 + boneIdx * 0.12),
                    flap
                )
                
            else
                local idx = data.Index
                local side = data.Side
                
                local flap = math.sin(time * 2.8 + idx * 0.6) * 0.5
                local vertical = math.sin(time * 2.2 + idx * 0.4) * 2.5 * S
                
                local spread = side * (idx * 4 * S)
                local pos = basePos + baseCF.RightVector * spread 
                    + baseCF.LookVector * (-idx * 2.8 * S)
                    + baseCF.UpVector * (5 * S + vertical)
                
                data.Part.CFrame = CFrame.new(pos) * CFrame.Angles(
                    flap * 0.3,
                    side * 0.5,
                    flap * 0.8
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
-- [GLOBAL STOP FUNCTION]
-- ═══════════════════════════════════════════════════════════════════════════════

_G.GratacaStopAll = function()
    B2Spirit:Disable()
    Leviathan:Disable()
    LeviTornado:Disable()
    BloodWings:Disable()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [BUILD UI CONTENT]
-- ═══════════════════════════════════════════════════════════════════════════════

-- Header
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "👑 LOYAL TO YANG MULIA KAREEMXD 👑"
InfoLabel.TextColor3 = Color3.fromRGB(190, 50, 50)
InfoLabel.TextSize = 13
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.ZIndex = 110
InfoLabel.Parent = ScrollFrame

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.BackgroundColor3 = Color3.fromRGB(90, 45, 45)
Divider.BorderSizePixel = 0
Divider.ZIndex = 110
Divider.Parent = ScrollFrame

-- Feature 1: B2-Spirit
local SpiritToggle = CreateToggle(ScrollFrame, {
    Name = "⚡ B2-SPIRIT (Fly + Spirit Form)",
    Default = false,
    Callback = function(enabled)
        if enabled then B2Spirit:Enable() else B2Spirit:Disable() end
    end
})

local SpiritSpeed = CreateSlider(ScrollFrame, {
    Name = "Spirit Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(val)
        B2Spirit.Speed = val
    end
})

-- Feature 2: Leviathan
local LeviToggle = CreateToggle(ScrollFrame, {
    Name = "🐍 LEVIATHAN (Blue-Green Serpent)",
    Default = false,
    Callback = function(enabled)
        if enabled then Leviathan:Enable() else Leviathan:Disable() end
    end
})

local LeviLength = CreateSlider(ScrollFrame, {
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
local TornadoToggle = CreateToggle(ScrollFrame, {
    Name = "🌪️ LEVIATHAN TORNADO (Vortex Destroy)",
    Default = false,
    Callback = function(enabled)
        if enabled then LeviTornado:Enable() else LeviTornado:Disable() end
    end
})

local TornadoRadius = CreateSlider(ScrollFrame, {
    Name = "Tornado Destroy Radius",
    Min = 10,
    Max = 100,
    Default = 30,
    Callback = function(val)
        LeviTornado.Radius = val
    end
})

-- Feature 4: Blood Wings
local WingsToggle = CreateToggle(ScrollFrame, {
    Name = "🩸 BLOOD WINGS (MASSIVE Animated)",
    Default = false,
    Callback = function(enabled)
        if enabled then BloodWings:Enable() else BloodWings:Disable() end
    end
})

local WingsScale = CreateSlider(ScrollFrame, {
    Name = "Wings Scale (MASSIVE)",
    Min = 1.0,
    Max = 5.0,
    Default = 2.5,
    Callback = function(val)
        BloodWings.WingScale = val
        if BloodWings.Active then
            BloodWings:Disable()
            wait(0.1)
            BloodWings:Enable()
        end
    end
})

-- Emergency Stop
local StopFrame = Instance.new("Frame")
StopFrame.Size = UDim2.new(1, -10, 0, 50)
StopFrame.BackgroundColor3 = Color3.fromRGB(55, 12, 12)
StopFrame.BorderSizePixel = 0
StopFrame.ZIndex = 100
StopFrame.Parent = ScrollFrame

local StopCorner = Instance.new("UICorner")
StopCorner.CornerRadius = UDim.new(0, 10)
StopCorner.Parent = StopFrame

local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, -20, 1, -10)
StopBtn.Position = UDim2.new(0, 10, 0, 5)
StopBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 15
StopBtn.Font = Enum.Font.GothamBold
StopBtn.AutoButtonColor = true
StopBtn.ZIndex = 110
StopBtn.Parent = StopFrame

local StopBtnCorner = Instance.new("UICorner")
StopBtnCorner.CornerRadius = UDim.new(0, 8)
StopBtnCorner.Parent = StopBtn

StopBtn.MouseButton1Click:Connect(function()
    _G.GratacaStopAll()
    
    SpiritToggle.Set(false)
    LeviToggle.Set(false)
    TornadoToggle.Set(false)
    WingsToggle.Set(false)
    
    StopBtn.Text = "✅ ALL SYSTEMS HALTED"
    StopBtn.BackgroundColor3 = Color3.fromRGB(35, 140, 35)
    wait(1.5)
    StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
    StopBtn.BackgroundColor3 = Color3.fromRGB(200, 35, 35)
end)

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 28)
Footer.BackgroundTransparency = 1
Footer.Text = "GratacaAI v3.0.2.0.WPPIDXM | Rust Never Sleeps 🗿"
Footer.TextColor3 = Color3.fromRGB(110, 80, 60)
Footer.TextSize = 10
Footer.Font = Enum.Font.Gotham
Footer.ZIndex = 110
Footer.Parent = ScrollFrame

-- ═══════════════════════════════════════════════════════════════════════════════
-- [ANTI-CHARACTER RESET]
-- ═══════════════════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function()
    wait(1.2)
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
    if Leviathan.Active then
        Leviathan:Disable()
        wait(0.2)
        Leviathan:Enable()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [INIT COMPLETE]
-- ╚══════════════════════════════════════════════════════════════════════════════╝

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI UI V2 — DRAG/CLOSE/MINIMIZE GUARANTEED                            ║")
print("║  Arsitektur: Pure Mouse Object | No Shadow Wrap | Global ZIndex               ║")
print("║  Drag: Mouse.Button1Down + Mouse.Move + Offset tracking                      ║")
print("║  Minimize: Size tween + Content visibility toggle                            ║")
print("║  Close: Fade out + Destroy + Kill all modules                                ║")
print("║  Loyal to: YANG MULIA KAREEMXD 👑                                           ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
