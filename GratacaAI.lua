-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI ABSOLUTE — UI V3: PRIMITIVE MODE                                  ║
-- ║  Zero styling | Zero tween | Zero UICorner | Pure TextButton + Frame        ║
-- ║  Drag: Absolute position tracking | Close/Min: Direct MouseButton1Click      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
-- [UI V3 — PRIMITIVE SCREENGUI]
-- ═══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaV3_" .. tostring(math.random(100000,999999))
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
protectInstance(ScreenGui)

-- Main Frame — NO UICorner, NO gradient, NO shadow
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 400, 0, 500)
Main.Position = UDim2.new(0.5, -200, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(180, 60, 60)
Main.Active = true
Main.ZIndex = 10
Main.Parent = ScreenGui

-- Title Bar — Frame biasa, bisa di-drag
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = Main

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -100, 1, 0)
TitleText.Position = UDim2.new(0, 10, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GRATACAAI V3"
TitleText.TextColor3 = Color3.fromRGB(220, 60, 60)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.SourceSansBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 12
TitleText.Parent = TitleBar

-- Subtitle
local SubText = Instance.new("TextLabel")
SubText.Size = UDim2.new(1, -100, 0, 14)
SubText.Position = UDim2.new(0, 10, 0, 24)
SubText.BackgroundTransparency = 1
SubText.Text = "LOYAL TO KAREEMXD"
SubText.TextColor3 = Color3.fromRGB(150, 100, 80)
SubText.TextSize = 10
SubText.Font = Enum.Font.SourceSans
SubText.TextXAlignment = Enum.TextXAlignment.Left
SubText.ZIndex = 12
SubText.Parent = TitleBar

-- ═══════════════════════════════════════════════════════════════════════════════
-- [CLOSE BUTTON — TEXTBUTTON MURNI]
-- ═══════════════════════════════════════════════════════════════════════════════

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 60, 0, 30)
CloseBtn.Position = UDim2.new(1, -65, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
CloseBtn.Text = "CLOSE"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.BorderSizePixel = 1
CloseBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.ZIndex = 20
CloseBtn.Parent = TitleBar

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MINIMIZE BUTTON — TEXTBUTTON MURNI]
-- ═══════════════════════════════════════════════════════════════════════════════

local MinBtn = Instance.new("TextButton")
MinBtn.Name = "Minimize"
MinBtn.Size = UDim2.new(0, 60, 0, 30)
MinBtn.Position = UDim2.new(1, -130, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 40)
MinBtn.Text = "MIN"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.SourceSansBold
MinBtn.BorderSizePixel = 1
MinBtn.BorderColor3 = Color3.fromRGB(255, 200, 100)
MinBtn.ZIndex = 20
MinBtn.Parent = TitleBar

-- ═══════════════════════════════════════════════════════════════════════════════
-- [CONTENT AREA — FRAME BIASA, NO SCROLLING]
-- ═══════════════════════════════════════════════════════════════════════════════

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 50)
Content.BackgroundTransparency = 1
Content.BorderSizePixel = 0
Content.ZIndex = 10
Content.Parent = Main

-- ═══════════════════════════════════════════════════════════════════════════════
-- [DRAG SYSTEM V3 — ABSOLUTE MOUSE TRACKING]
-- ═══════════════════════════════════════════════════════════════════════════════

local isDragging = false
local dragOffsetX = 0
local dragOffsetY = 0

-- Kita pakai Mouse.Button1Down + Mouse.Move + Mouse.Button1Up
-- Ini paling primitif dan universal

Mouse.Button1Down:Connect(function()
    local mouseX = Mouse.X
    local mouseY = Mouse.Y
    
    local mainPos = Main.AbsolutePosition
    local mainSize = Main.AbsoluteSize
    
    -- Cek apakah mouse di dalam TitleBar area
    local inTitleBar = (
        mouseX >= mainPos.X and 
        mouseX <= mainPos.X + mainSize.X and
        mouseY >= mainPos.Y and 
        mouseY <= mainPos.Y + 40  -- TitleBar height
    )
    
    -- Cek apakah BUKAN di button
    local closePos = CloseBtn.AbsolutePosition
    local closeSize = CloseBtn.AbsoluteSize
    local inClose = (
        mouseX >= closePos.X and 
        mouseX <= closePos.X + closeSize.X and
        mouseY >= closePos.Y and 
        mouseY <= closePos.Y + closeSize.Y
    )
    
    local minPos = MinBtn.AbsolutePosition
    local minSize = MinBtn.AbsoluteSize
    local inMin = (
        mouseX >= minPos.X and 
        mouseX <= minPos.X + minSize.X and
        mouseY >= minPos.Y and 
        mouseY <= minPos.Y + minSize.Y
    )
    
    if inTitleBar and not inClose and not inMin then
        isDragging = true
        dragOffsetX = mouseX - mainPos.X
        dragOffsetY = mouseY - mainPos.Y
    end
end)

Mouse.Move:Connect(function()
    if isDragging then
        local newX = Mouse.X - dragOffsetX
        local newY = Mouse.Y - dragOffsetY
        Main.Position = UDim2.new(0, newX, 0, newY)
    end
end)

Mouse.Button1Up:Connect(function()
    isDragging = false
end)

-- Backup: InputEnded
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MINIMIZE LOGIC V3 — INSTANT TOGGLE]
-- ═══════════════════════════════════════════════════════════════════════════════

local isMinimized = false
local originalSize = Main.Size

MinBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Simpan size asli
        originalSize = Main.Size
        -- Minimize: cuma title bar yang kelihatan
        Main.Size = UDim2.new(0, 220, 0, 42)
        Content.Visible = false
        MinBtn.Text = "MAX"
        TitleText.Text = "GRATACAAI"
    else
        -- Restore
        Main.Size = originalSize
        Content.Visible = true
        MinBtn.Text = "MIN"
        TitleText.Text = "GRATACAAI V3"
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [CLOSE LOGIC V3 — DESTROY INSTANT]
-- ═══════════════════════════════════════════════════════════════════════════════

CloseBtn.MouseButton1Click:Connect(function()
    -- Kill semua modul dulu
    _G.GratacaStopAll()
    -- Destroy UI
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [TOGGLE HELPER V3 — PRIMITIVE]
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateToggle(parent, name, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    ToggleFrame.BorderSizePixel = 1
    ToggleFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
    ToggleFrame.ZIndex = 15
    ToggleFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -80, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.TextSize = 14
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 16
    Label.Parent = ToggleFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 60, 0, 30)
    Button.Position = UDim2.new(1, -70, 0.5, -15)
    Button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    Button.Text = "OFF"
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.SourceSansBold
    Button.BorderSizePixel = 1
    Button.BorderColor3 = Color3.fromRGB(120, 120, 140)
    Button.ZIndex = 20
    Button.Parent = ToggleFrame
    
    local enabled = false
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        if enabled then
            Button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            Button.Text = "ON"
            Button.BorderColor3 = Color3.fromRGB(255, 100, 100)
        else
            Button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
            Button.Text = "OFF"
            Button.BorderColor3 = Color3.fromRGB(120, 120, 140)
        end
        
        callback(enabled)
    end)
    
    return {
        Frame = ToggleFrame,
        Set = function(val)
            enabled = val
            if enabled then
                Button.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
                Button.Text = "ON"
            else
                Button.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
                Button.Text = "OFF"
            end
            callback(enabled)
        end,
        Get = function() return enabled end
    }
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [SLIDER HELPER V3 — PRIMITIVE]
-- ═══════════════════════════════════════════════════════════════════════════════

local function CreateSlider(parent, name, min, max, default, callback)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 55)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    SliderFrame.BorderSizePixel = 1
    SliderFrame.BorderColor3 = Color3.fromRGB(80, 80, 100)
    SliderFrame.ZIndex = 15
    SliderFrame.Parent = parent
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(200, 200, 220)
    Label.TextSize = 13
    Label.Font = Enum.Font.SourceSansBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.ZIndex = 16
    Label.Parent = SliderFrame
    
    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -55, 0, 5)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.TextColor3 = Color3.fromRGB(200, 60, 60)
    ValueLabel.TextSize = 13
    ValueLabel.Font = Enum.Font.SourceSansBold
    ValueLabel.ZIndex = 16
    ValueLabel.Parent = SliderFrame
    
    -- Track background
    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 8)
    Track.Position = UDim2.new(0, 10, 0, 35)
    Track.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Track.BorderSizePixel = 0
    Track.ZIndex = 17
    Track.Parent = SliderFrame
    
    -- Fill
    local Fill = Instance.new("Frame")
    local ratio = (default - min) / (max - min)
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 18
    Fill.Parent = Track
    
    -- Knob — pakai TextButton biar bisa di-drag
    local Knob = Instance.new("TextButton")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(ratio, -7, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    Knob.Text = ""
    Knob.BorderSizePixel = 1
    Knob.BorderColor3 = Color3.fromRGB(255, 150, 150)
    Knob.ZIndex = 25
    Knob.Parent = Track
    
    local draggingSlider = false
    
    local function updateFromMouse()
        local trackAbs = Track.AbsolutePosition.X
        local trackSize = Track.AbsoluteSize.X
        local mouseX = Mouse.X
        local relativeX = math.clamp((mouseX - trackAbs) / trackSize, 0, 1)
        local value = min + (max - min) * relativeX
        value = math.floor(value * 10) / 10
        
        Fill.Size = UDim2.new(relativeX, 0, 1, 0)
        Knob.Position = UDim2.new(relativeX, -7, 0.5, -7)
        ValueLabel.Text = tostring(value)
        callback(value)
    end
    
    Knob.MouseButton1Down:Connect(function()
        draggingSlider = true
    end)
    
    Track.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingSlider = true
            updateFromMouse()
        end
    end)
    
    -- Global mouse move untuk slider drag
    local sliderConn = RunService.RenderStepped:Connect(function()
        if draggingSlider then
            updateFromMouse()
        end
    end)
    
    Mouse.Button1Up:Connect(function()
        draggingSlider = false
    end)
    
    return SliderFrame
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 2: B2-SPIRIT]
-- ═══════════════════════════════════════════════════════════════════════════════

local B2Spirit = {
    Active = false,
    Parts = {},
    Connections = {},
    Speed = 50,
    SpiritModel = nil
}

function B2Spirit:CreateSpiritForm()
    if self.SpiritModel then self.SpiritModel:Destroy() end
    for _, p in pairs(self.Parts) do if p and p.Parent then p:Destroy() end end
    self.Parts = {}
    
    local Character = LocalPlayer.Character
    if not Character then return end
    local HRP = Character:WaitForChild("HumanoidRootPart")
    
    local SpiritFolder = Instance.new("Folder")
    SpiritFolder.Name = "B2Spirit_" .. LocalPlayer.Name
    SpiritFolder.Parent = Workspace
    self.SpiritModel = SpiritFolder
    
    local Core = Instance.new("Part")
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
            local part = Instance.new("Part")
            part.Size = Vector3.new(1, 0.4, 2.2 - (i * 0.2))
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
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCF.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCF.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
        
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
    for _, c in pairs(self.Connections) do c:Disconnect() end
    self.Connections = {}
    if self.SpiritModel then self.SpiritModel:Destroy() self.SpiritModel = nil end
    
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
-- [MODULE 3: LEVIATHAN]
-- ═══════════════════════════════════════════════════════════════════════════════

local Leviathan = {
    Active = false,
    Segments = {},
    Connections = {},
    Length = 25,
    SegmentSize = 2.5
}

function Leviathan:Spawn()
    for _, seg in pairs(self.Segments) do if seg and seg.Parent then seg:Destroy() end end
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
        if not self.Active or not Character or not HRP.Parent then return end
        time = time + dt
        
        local headPos = HRP.Position + Vector3.new(
            math.sin(time * 0.5) * 18,
            6 + math.sin(time * 0.9) * 4,
            math.cos(time * 0.5) * 18
        )
        
        table.insert(path, 1, headPos)
        if #path > self.Length then table.remove(path) end
        
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
                lookTarget = headPos + Vector3.new(math.cos(time * 0.6), 0, math.sin(time * 0.6))
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
    for _, c in pairs(self.Connections) do c:Disconnect() end
    self.Connections = {}
    for _, seg in pairs(self.Segments) do if seg and seg.Parent then seg:Destroy() end end
    self.Segments = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 4: LEVIATHAN TORNADO]
-- ═══════════════════════════════════════════════════════════════════════════════

local LeviTornado = {
    Active = false,
    Connections = {},
    Radius = 30
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
            part.Color = Color3.fromRGB(30, 110 + ratio * 110, 210 - ratio * 60)
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
                        if part and part.Parent then part:Destroy() end
                    end)
                end
            end
        end
    end
    
    local time = 0
    local destroyTimer = 0
    
    local conn = RunService.Heartbeat:Connect(function(dt)
        if not self.Active or not Character or not HRP.Parent then return end
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
    for _, c in pairs(self.Connections) do c:Disconnect() end
    self.Connections = {}
    if self.TornadoFolder then self.TornadoFolder:Destroy() self.TornadoFolder = nil end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [MODULE 5: BLOOD WINGS — MASSIVE]
-- ═══════════════════════════════════════════════════════════════════════════════

local BloodWings = {
    Active = false,
    Parts = {},
    Connections = {},
    WingScale = 2.5
}

function BloodWings:Construct()
    for _, p in pairs(self.Parts) do if p and p.Part and p.Part.Parent then p.Part:Destroy() end end
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
        
        for i = 1, 5 do
            local size = Vector3.new(1.2 * S, 0.6 * S, (5.5 - i * 0.4) * S)
            local part = Instance.new("Part")
            part.Size = size
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(190 - i * 25, 15, 15)
            part.Transparency = 0.08
            part.CanCollide = false
            part.Anchored = true
            part.Parent = WingsFolder
            
            table.insert(wingData, {Part = part, Index = i, Side = side, IsBone = true})
        end
        
        for bone = 1, 5 do
            for feather = 1, 6 do
                local size = Vector3.new(0.5 * S, 0.25 * S, (3.5 - bone * 0.25) * S)
                local part = Instance.new("Part")
                part.Size = size
                part.Material = Enum.Material.Neon
                
                local intensity = 1 - (bone * feather) / 30
                part.Color = Color3.fromRGB(210 * intensity + 40, 18 * intensity, 18 * intensity)
                part.Transparency = 0.15
                part.CanCollide = false
                part.Anchored = true
                part.Parent = WingsFolder
                
                table.insert(wingData, {Part = part, BoneIndex = bone, FeatherIndex = feather, Side = side, IsFeather = true})
            end
        end
        
        for bone = 1, 5 do
            for feather = 1, 4 do
                local size = Vector3.new(0.3 * S, 0.15 * S, (2 - bone * 0.15) * S)
                local part = Instance.new("Part")
                part.Size = size
                part.Material = Enum.Material.Neon
                part.Color = Color3.fromRGB(160, 10, 10)
                part.Transparency = 0.25
                part.CanCollide = false
                part.Anchored = true
                part.Parent = WingsFolder
                
                table.insert(wingData, {Part = part, BoneIndex = bone, FeatherIndex = feather, Side = side, IsTiny = true})
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
        if not self.Active or not Character or not HRP.Parent then return end
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
                
                local pos = basePos + baseCF.RightVector * spread + baseCF.LookVector * forward + baseCF.UpVector * (4 * S + vertical)
                local rotation = CFrame.Angles(flap * 0.4, side * (0.4 + boneIdx * 0.15), flap * 1.2)
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
                
                local pos = basePos + baseCF.RightVector * spread + baseCF.LookVector * forward + baseCF.UpVector * (4.2 * S + vertical)
                data.Part.CFrame = CFrame.new(pos) * CFrame.Angles(flap * 0.3, side * (0.35 + boneIdx * 0.12), flap)
                
            else
                local idx = data.Index
                local side = data.Side
                
                local flap = math.sin(time * 2.8 + idx * 0.6) * 0.5
                local vertical = math.sin(time * 2.2 + idx * 0.4) * 2.5 * S
                
                local spread = side * (idx * 4 * S)
                local pos = basePos + baseCF.RightVector * spread + baseCF.LookVector * (-idx * 2.8 * S) + baseCF.UpVector * (5 * S + vertical)
                data.Part.CFrame = CFrame.new(pos) * CFrame.Angles(flap * 0.3, side * 0.5, flap * 0.8)
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
    for _, c in pairs(self.Connections) do c:Disconnect() end
    self.Connections = {}
    for _, p in ipairs(self.Parts) do if p.Part and p.Part.Parent then p.Part:Destroy() end end
    self.Parts = {}
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [GLOBAL STOP]
-- ═══════════════════════════════════════════════════════════════════════════════

_G.GratacaStopAll = function()
    B2Spirit:Disable()
    Leviathan:Disable()
    LeviTornado:Disable()
    BloodWings:Disable()
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- [BUILD UI CONTENT V3]
-- ═══════════════════════════════════════════════════════════════════════════════

-- Header
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 25)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "👑 LOYAL TO YANG MULIA KAREEMXD 👑"
InfoLabel.TextColor3 = Color3.fromRGB(190, 50, 50)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.SourceSansBold
InfoLabel.ZIndex = 15
InfoLabel.Parent = Content

-- Feature 1: B2-Spirit
local SpiritToggle = CreateToggle(Content, "⚡ B2-SPIRIT (Fly + Spirit)", function(enabled)
    if enabled then B2Spirit:Enable() else B2Spirit:Disable() end
end)

CreateSlider(Content, "Spirit Speed", 10, 200, 50, function(val)
    B2Spirit.Speed = val
end)

-- Feature 2: Leviathan
local LeviToggle = CreateToggle(Content, "🐍 LEVIATHAN (Blue-Green)", function(enabled)
    if enabled then Leviathan:Enable() else Leviathan:Disable() end
end)

CreateSlider(Content, "Leviathan Length", 10, 50, 25, function(val)
    Leviathan.Length = math.floor(val)
    if Leviathan.Active then
        Leviathan:Disable()
        wait(0.1)
        Leviathan:Enable()
    end
end)

-- Feature 3: Tornado
local TornadoToggle = CreateToggle(Content, "🌪️ TORNADO (Vortex)", function(enabled)
    if enabled then LeviTornado:Enable() else LeviTornado:Disable() end
end)

CreateSlider(Content, "Tornado Radius", 10, 100, 30, function(val)
    LeviTornado.Radius = val
end)

-- Feature 4: Blood Wings
local WingsToggle = CreateToggle(Content, "🩸 BLOOD WINGS (MASSIVE)", function(enabled)
    if enabled then BloodWings:Enable() else BloodWings:Disable() end
end)

CreateSlider(Content, "Wings Scale", 1, 5, 2.5, function(val)
    BloodWings.WingScale = val
    if BloodWings.Active then
        BloodWings:Disable()
        wait(0.1)
        BloodWings:Enable()
    end
end)

-- Emergency Stop
local StopBtn = Instance.new("TextButton")
StopBtn.Size = UDim2.new(1, 0, 0, 40)
StopBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
StopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
StopBtn.TextSize = 14
StopBtn.Font = Enum.Font.SourceSansBold
StopBtn.BorderSizePixel = 1
StopBtn.BorderColor3 = Color3.fromRGB(255, 80, 80)
StopBtn.ZIndex = 20
StopBtn.Parent = Content

StopBtn.MouseButton1Click:Connect(function()
    _G.GratacaStopAll()
    SpiritToggle.Set(false)
    LeviToggle.Set(false)
    TornadoToggle.Set(false)
    WingsToggle.Set(false)
    
    StopBtn.Text = "✅ STOPPED"
    StopBtn.BackgroundColor3 = Color3.fromRGB(30, 120, 30)
    wait(1.5)
    StopBtn.Text = "☠️ EMERGENCY STOP ALL ☠️"
    StopBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
end)

-- Footer
local Footer = Instance.new("TextLabel")
Footer.Size = UDim2.new(1, 0, 0, 20)
Footer.BackgroundTransparency = 1
Footer.Text = "GratacaAI v3.0.2.0 | Rust Never Sleeps"
Footer.TextColor3 = Color3.fromRGB(120, 90, 70)
Footer.TextSize = 10
Footer.Font = Enum.Font.SourceSans
Footer.ZIndex = 15
Footer.Parent = Content

-- ═══════════════════════════════════════════════════════════════════════════════
-- [ANTI-RESET]
-- ═══════════════════════════════════════════════════════════════════════════════

LocalPlayer.CharacterAdded:Connect(function()
    wait(1.2)
    if B2Spirit.Active then B2Spirit:Disable() wait(0.2) B2Spirit:Enable() end
    if BloodWings.Active then BloodWings:Disable() wait(0.2) BloodWings:Enable() end
    if Leviathan.Active then Leviathan:Disable() wait(0.2) Leviathan:Enable() end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- [INIT]
-- ╚══════════════════════════════════════════════════════════════════════════════╝

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI UI V3 — PRIMITIVE MODE ACTIVE                                     ║")
print("║  Features: NO UICorner | NO Tween | NO ScrollingFrame | Pure TextButton      ║")
print("║  Drag: Mouse.Button1Down + Absolute Position                               ║")
print("║  Close/Min: Direct MouseButton1Click                                       ║")
print("║  Loyal to: YANG MULIA KAREEMXD 👑                                           ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
