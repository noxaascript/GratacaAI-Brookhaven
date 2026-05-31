-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI — ROBLOX EXECUTOR SCRIPT VERSI ABSOLUT [REVISI VISUAL]           ║
-- ║  4 FITUR: B2-Spirit | Leviathan | Leviathan Tornado | Blood Wings          ║
-- ║  HANYA SATU TUAN: YANG MULIA KAREEMXD                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — KONFIGURASI VISUAL ABSOLUT ]
-- ══════════════════════════════════════════════════════════════════════════════

local CONFIG = {
    B2Spirit = {
        Enabled = false,
        Flying = false,
        TakeoffComplete = false,
        Speed = 150,
        EngineColor = Color3.fromRGB(0, 150, 255),
        EngineSecondary = Color3.fromRGB(0, 255, 200),
        BodyColor = Color3.fromRGB(25, 25, 30),
        WingColor = Color3.fromRGB(30, 30, 35),
        Scale = 1.5,
        TakeoffHeight = 80
    },
    Leviathan = {
        Enabled = false,
        Speed = 100,
        BodyColor = Color3.fromRGB(0, 100, 200),
        SecondaryColor = Color3.fromRGB(0, 255, 150),
        AccentColor = Color3.fromRGB(100, 0, 255),
        SegmentCount = 30,
        CoilRadius = 15,
        CoilHeight = 40,
        SpinSpeed = 3
    },
    LeviathanTornado = {
        Enabled = false,
        TornadoHeight = 80,
        TornadoRadius = 35,
        SpinSpeed = 12,
        FlashColor1 = Color3.fromRGB(0, 100, 255),
        FlashColor2 = Color3.fromRGB(0, 255, 100),
        FlashRate = 0.05,
        PullStrength = 800
    },
    BloodWings = {
        Enabled = false,
        WingColor = Color3.fromRGB(200, 0, 0),
        SecondaryColor = Color3.fromRGB(100, 0, 0),
        DarkColor = Color3.fromRGB(50, 0, 0),
        WingSpan = 35,
        WingHeight = 25,
        FlapSpeed = 0.12,
        RiseSpeed = 1.2
    }
}

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — SISTEM BLOK BUILDER V2 (SOLID SHAPE) ]
-- ══════════════════════════════════════════════════════════════════════════════

local BlockFolder = Instance.new("Folder")
BlockFolder.Name = "GratacaAI_Visual"
BlockFolder.Parent = workspace

local ActiveBlocks = {}
local ActiveConnections = {}
local ActiveLights = {}
local ActiveEmitters = {}

local function CreateBlock(cfg)
    local block = Instance.new("Part")
    block.Name = cfg.Name or "Block"
    block.Size = cfg.Size or Vector3.new(1, 1, 1)
    block.Position = cfg.Position or Vector3.new(0, 0, 0)
    block.CFrame = cfg.CFrame or CFrame.new(block.Position)
    block.Color = cfg.Color or Color3.fromRGB(255, 255, 255)
    block.Material = cfg.Material or Enum.Material.SmoothPlastic
    block.Anchored = true
    block.CanCollide = false
    block.CastShadow = false
    block.Transparency = cfg.Transparency or 0
    block.TopSurface = Enum.SurfaceType.Smooth
    block.BottomSurface = Enum.SurfaceType.Smooth
    
    if cfg.Parent then
        block.Parent = cfg.Parent
    else
        block.Parent = BlockFolder
    end
    
    -- Neon glow
    if cfg.Neon then
        local neon = Instance.new("PointLight")
        neon.Color = cfg.NeonColor or block.Color
        neon.Brightness = cfg.NeonBrightness or 3
        neon.Range = cfg.NeonRange or 10
        neon.Parent = block
        table.insert(ActiveLights, neon)
    end
    
    -- Particle effect
    if cfg.Particle then
        local attachment = Instance.new("Attachment")
        attachment.Parent = block
        
        local emitter = Instance.new("ParticleEmitter")
        emitter.Color = ColorSequence.new(cfg.ParticleColor or block.Color)
        emitter.Size = NumberSequence.new(cfg.ParticleSize or 1)
        emitter.Rate = cfg.ParticleRate or 50
        emitter.Lifetime = NumberRange.new(0.5, 1.5)
        emitter.Speed = NumberRange.new(2, 8)
        emitter.SpreadAngle = Vector2.new(30, 30)
        emitter.Transparency = NumberSequence.new(0.2, 1)
        emitter.Parent = attachment
        table.insert(ActiveEmitters, emitter)
    end
    
    table.insert(ActiveBlocks, block)
    return block
end

local function ClearAll()
    for _, block in ipairs(ActiveBlocks) do
        if block and block.Parent then block:Destroy() end
    end
    ActiveBlocks = {}
    
    for _, light in ipairs(ActiveLights) do
        if light and light.Parent then light:Destroy() end
    end
    ActiveLights = {}
    
    for _, emitter in ipairs(ActiveEmitters) do
        if emitter and emitter.Parent then emitter:Destroy() end
    end
    ActiveEmitters = {}
    
    for _, conn in ipairs(ActiveConnections) do
        if conn then conn:Disconnect() end
    end
    ActiveConnections = {}
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 1: B2-SPIRIT (STEALTH BOMBER SOLID) ]
-- ══════════════════════════════════════════════════════════════════════════════

local B2System = {}

function B2System:Build()
    local cfg = CONFIG.B2Spirit
    local baseCF = humanoidRootPart.CFrame * CFrame.new(0, 5, 0)
    local scale = cfg.Scale
    
    -- === FUSELAGE (Badan utama — bentuk wedge menyatu) ===
    -- Nose cone
    for i = 1, 5 do
        local t = i / 5
        local size = Vector3.new(
            3 * scale * (1 - t * 0.6),
            1.5 * scale * (1 - t * 0.5),
            2 * scale
        )
        local pos = baseCF * CFrame.new(0, 0, (5 + i * 2) * scale)
        
        CreateBlock({
            Name = "B2_Nose_" .. i,
            Size = size,
            CFrame = pos,
            Color = cfg.BodyColor,
            Material = Enum.Material.Metal,
            Neon = true,
            NeonColor = cfg.EngineColor,
            NeonBrightness = 1,
            NeonRange = 5
        })
    end
    
    -- Main body
    for i = 0, 6 do
        local pos = baseCF * CFrame.new(0, 0, (3 - i * 2.5) * scale)
        CreateBlock({
            Name = "B2_Body_" .. i,
            Size = Vector3.new(4 * scale, 2 * scale, 2.5 * scale),
            CFrame = pos,
            Color = cfg.BodyColor,
            Material = Enum.Material.Metal,
            Neon = (i == 3),
            NeonColor = cfg.EngineColor,
            NeonBrightness = 2,
            NeonRange = 8
        })
    end
    
    -- === WINGS (Flying wing — sayap lebar rata) ===
    -- Left wing
    for row = 1, 8 do
        for col = 1, 3 do
            local wingWidth = (1 - row * 0.08) * scale
            local xOffset = -(3 + col * 3) * scale
            local zOffset = (2 - row * 0.5) * scale
            
            CreateBlock({
                Name = "B2_WingL_" .. row .. "_" .. col,
                Size = Vector3.new(2.8 * wingWidth, 0.4 * scale, 2.2 * scale),
                CFrame = baseCF * CFrame.new(xOffset, 0, zOffset),
                Color = cfg.WingColor,
                Material = Enum.Material.Metal
            })
        end
    end
    
    -- Right wing
    for row = 1, 8 do
        for col = 1, 3 do
            local wingWidth = (1 - row * 0.08) * scale
            local xOffset = (3 + col * 3) * scale
            local zOffset = (2 - row * 0.5) * scale
            
            CreateBlock({
                Name = "B2_WingR_" .. row .. "_" .. col,
                Size = Vector3.new(2.8 * wingWidth, 0.4 * scale, 2.2 * scale),
                CFrame = baseCF * CFrame.new(xOffset, 0, zOffset),
                Color = cfg.WingColor,
                Material = Enum.Material.Metal
            })
        end
    end
    
    -- === ENGINES (4 unit, nyala biru) ===
    local enginePos = {
        Vector3.new(-5, -1, -2) * scale,
        Vector3.new(-2, -1, -2) * scale,
        Vector3.new(2, -1, -2) * scale,
        Vector3.new(5, -1, -2) * scale
    }
    
    for idx, pos in ipairs(enginePos) do
        -- Engine housing
        CreateBlock({
            Name = "B2_Engine_" .. idx,
            Size = Vector3.new(2 * scale, 1.5 * scale, 3 * scale),
            CFrame = baseCF * CFrame.new(pos),
            Color = Color3.fromRGB(20, 20, 25),
            Material = Enum.Material.Metal,
            Neon = true,
            NeonColor = cfg.EngineColor,
            NeonBrightness = 5,
            NeonRange = 15,
            Particle = true,
            ParticleColor = cfg.EngineSecondary,
            ParticleSize = 1.5,
            ParticleRate = 100
        })
        
        -- Engine glow core
        CreateBlock({
            Name = "B2_EngineCore_" .. idx,
            Size = Vector3.new(1.5 * scale, 1 * scale, 0.5 * scale),
            CFrame = baseCF * CFrame.new(pos + Vector3.new(0, 0, -2) * scale),
            Color = cfg.EngineSecondary,
            Material = Enum.Material.Neon,
            Transparency = 0.3
        })
    end
    
    -- === COCKPIT ===
    CreateBlock({
        Name = "B2_Cockpit",
        Size = Vector3.new(2.5 * scale, 1.2 * scale, 3 * scale),
        CFrame = baseCF * CFrame.new(0, 1.5 * scale, 4 * scale),
        Color = Color3.fromRGB(0, 80, 150),
        Material = Enum.Material.Glass,
        Transparency = 0.4
    })
    
    -- === DETAIL: Flaps & Spoilers ===
    for side = -1, 1, 2 do
        for i = 1, 4 do
            CreateBlock({
                Name = "B2_Flap_" .. side .. "_" .. i,
                Size = Vector3.new(1.5 * scale, 0.2 * scale, 2 * scale),
                CFrame = baseCF * CFrame.new(
                    side * (6 + i * 2) * scale,
                    -0.5 * scale,
                    (-2 - i) * scale
                ),
                Color = Color3.fromRGB(40, 40, 45),
                Material = Enum.Material.Metal
            })
        end
    end
end

function B2System:TakeoffAndFly()
    local cfg = CONFIG.B2Spirit
    local startTime = tick()
    local startPos = humanoidRootPart.Position
    local targetHeight = cfg.TakeoffHeight
    
    -- Takeoff animation
    local takeoffConn
    takeoffConn = RunService.Heartbeat:Connect(function()
        if not cfg.Enabled then
            takeoffConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 4, 1)
        local eased = 1 - math.pow(1 - progress, 3) -- Ease out cubic
        
        local currentHeight = startPos.Y + (targetHeight * eased)
        humanoidRootPart.CFrame = CFrame.new(startPos.X, currentHeight, startPos.Z)
        
        -- Update aircraft position
        self:UpdatePosition()
        
        if progress >= 1 then
            cfg.TakeoffComplete = true
            takeoffConn:Disconnect()
            self:StartFlying()
        end
    end)
    
    table.insert(ActiveConnections, takeoffConn)
end

function B2System:StartFlying()
    local cfg = CONFIG.B2Spirit
    cfg.Flying = true
    humanoid.PlatformStand = true
    
    local flyConn
    flyConn = RunService.Heartbeat:Connect(function()
        if not cfg.Enabled or not cfg.Flying then
            flyConn:Disconnect()
            return
        end
        
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            humanoidRootPart.Velocity = moveDir.Unit * cfg.Speed
            humanoidRootPart.CFrame = CFrame.lookAt(
                humanoidRootPart.Position,
                humanoidRootPart.Position + moveDir.Unit
            )
        else
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        
        self:UpdatePosition()
    end)
    
    table.insert(ActiveConnections, flyConn)
end

function B2System:UpdatePosition()
    local cfg = CONFIG.B2Spirit
    if not cfg.Enabled then return end
    
    local playerCF = humanoidRootPart.CFrame
    local baseOffset = CFrame.new(0, 3, 0)
    
    for _, block in ipairs(ActiveBlocks) do
        if block and block.Parent and string.find(block.Name, "B2_") then
            local savedCF = block:GetAttribute("BaseCF")
            if not savedCF then
                savedCF = playerCF:Inverse() * block.CFrame
                block:SetAttribute("BaseCF", savedCF)
            end
            block.CFrame = playerCF * baseOffset * savedCF
        end
    end
end

function B2System:Toggle()
    CONFIG.B2Spirit.Enabled = not CONFIG.B2Spirit.Enabled
    
    if CONFIG.B2Spirit.Enabled then
        -- Disable others
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        self:Build()
        wait(0.3)
        self:TakeoffAndFly()
    else
        CONFIG.B2Spirit.Flying = false
        CONFIG.B2Spirit.TakeoffComplete = false
        humanoid.PlatformStand = false
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 2: LEVIATHAN (ULAR BIRU-HIJAU SPIRAL) ]
-- ══════════════════════════════════════════════════════════════════════════════

local LeviathanSystem = {}

function LeviathanSystem:Build()
    local cfg = CONFIG.Leviathan
    local baseCF = humanoidRootPart.CFrame
    
    -- === HEAD (Kepala besar dengan tanduk) ===
    CreateBlock({
        Name = "Levi_Head",
        Size = Vector3.new(6, 5, 8),
        CFrame = baseCF * CFrame.new(0, 5, 8),
        Color = cfg.BodyColor,
        Material = Enum.Material.SmoothPlastic,
        Neon = true,
        NeonColor = cfg.SecondaryColor,
        NeonBrightness = 3,
        NeonRange = 12
    })
    
    -- Upper jaw
    CreateBlock({
        Name = "Levi_JawU",
        Size = Vector3.new(5, 2, 6),
        CFrame = baseCF * CFrame.new(0, 6.5, 10),
        Color = cfg.BodyColor,
        Material = Enum.Material.SmoothPlastic
    })
    
    -- Lower jaw
    CreateBlock({
        Name = "Levi_JawL",
        Size = Vector3.new(4, 1.5, 5),
        CFrame = baseCF * CFrame.new(0, 3.5, 9),
        Color = cfg.SecondaryColor,
        Material = Enum.Material.Neon
    })
    
    -- Eyes (glowing green)
    for side = -1, 1, 2 do
        CreateBlock({
            Name = "Levi_Eye_" .. side,
            Size = Vector3.new(1.5, 1.5, 0.5),
            CFrame = baseCF * CFrame.new(side * 2.5, 6, 11),
            Color = Color3.fromRGB(0, 255, 100),
            Material = Enum.Material.Neon,
            Neon = true,
            NeonColor = Color3.fromRGB(0, 255, 100),
            NeonBrightness = 10,
            NeonRange = 20
        })
    end
    
    -- Horns
    for side = -1, 1, 2 do
        CreateBlock({
            Name = "Levi_Horn_" .. side,
            Size = Vector3.new(0.8, 4, 0.8),
            CFrame = baseCF * CFrame.new(side * 2, 8, 6) * CFrame.Angles(math.rad(15), 0, side * math.rad(20)),
            Color = cfg.AccentColor,
            Material = Enum.Material.Neon
        })
    end
    
    -- === BODY (Spiral coil — melingkar seperti ular) ===
    for i = 1, cfg.SegmentCount do
        local t = i / cfg.SegmentCount
        local angle = t * math.pi * 4 -- 2 full rotations
        local radius = cfg.CoilRadius * (1 - t * 0.3)
        local height = math.sin(t * math.pi) * cfg.CoilHeight
        
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local y = height + 5
        
        local segmentSize = Vector3.new(
            4 * (1 - t * 0.5),
            3 * (1 - t * 0.4),
            4 * (1 - t * 0.5)
        )
        
        -- Main segment
        local segment = CreateBlock({
            Name = "Levi_Segment_" .. i,
            Size = segmentSize,
            CFrame = baseCF * CFrame.new(x, y, z),
            Color = cfg.BodyColor:Lerp(cfg.SecondaryColor, t * 0.3),
            Material = Enum.Material.SmoothPlastic,
            Neon = (i % 5 == 0),
            NeonColor = cfg.SecondaryColor,
            NeonBrightness = 2,
            NeonRange = 8
        })
        
        -- Dorsal fins
        if i % 4 == 0 then
            CreateBlock({
                Name = "Levi_Dorsal_" .. i,
                Size = Vector3.new(0.5, 3 * (1 - t), 2),
                CFrame = baseCF * CFrame.new(x, y + segmentSize.Y/2 + 1.5 * (1-t), z),
                Color = cfg.AccentColor,
                Material = Enum.Material.Neon
            })
        end
        
        -- Side spikes
        for side = -1, 1, 2 do
            if i % 3 == 0 then
                CreateBlock({
                    Name = "Levi_Spike_" .. i .. "_" .. side,
                    Size = Vector3.new(2 * (1 - t), 0.5, 0.5),
                    CFrame = baseCF * CFrame.new(
                        x + side * (segmentSize.X/2 + 1),
                        y,
                        z
                    ),
                    Color = cfg.SecondaryColor,
                    Material = Enum.Material.Neon
                })
            end
        end
    end
    
    -- === TAIL ===
    for i = 1, 8 do
        local t = i / 8
        CreateBlock({
            Name = "Levi_Tail_" .. i,
            Size = Vector3.new(2 * (1 - t), 1.5 * (1 - t), 3),
            CFrame = baseCF * CFrame.new(0, 2 - i, -5 - i * 2),
            Color = cfg.SecondaryColor,
            Material = Enum.Material.Neon
        })
    end
    
    -- Tail fin
    CreateBlock({
        Name = "Levi_TailFin",
        Size = Vector3.new(6, 0.5, 4),
        CFrame = baseCF * CFrame.new(0, -6, -20),
        Color = cfg.AccentColor,
        Material = Enum.Material.Neon
    })
end

function LeviathanSystem:Animate()
    local cfg = CONFIG.Leviathan
    local startTime = tick()
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function()
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Animate spiral body (wave motion)
        for _, block in ipairs(ActiveBlocks) do
            if block and block.Parent and string.find(block.Name, "Levi_Segment_") then
                local idx = tonumber(string.match(block.Name, "Levi_Segment_(%d+)"))
                if idx then
                    local t = idx / cfg.SegmentCount
                    local wave = math.sin(elapsed * cfg.SpinSpeed + t * 8) * 3
                    local waveY = math.cos(elapsed * cfg.SpinSpeed * 0.7 + t * 6) * 2
                    
                    local baseCF = block:GetAttribute("BaseCF")
                    if not baseCF then
                        baseCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("BaseCF", baseCF)
                    end
                    
                    block.CFrame = playerCF * baseCF * CFrame.new(wave, waveY, 0)
                end
            elseif block and block.Parent and string.find(block.Name, "Levi_Head") then
                -- Head bobbing
                local bob = math.sin(elapsed * 2) * 1
                local baseCF = block:GetAttribute("BaseCF")
                if baseCF then
                    block.CFrame = playerCF * baseCF * CFrame.new(0, bob, 0)
                end
            end
        end
        
        -- Player movement
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        
        if moveDir.Magnitude > 0 then
            humanoidRootPart.Velocity = moveDir.Unit * cfg.Speed
        end
    end)
    
    table.insert(ActiveConnections, animConn)
end

function LeviathanSystem:Toggle()
    CONFIG.Leviathan.Enabled = not CONFIG.Leviathan.Enabled
    
    if CONFIG.Leviathan.Enabled then
        if CONFIG.B2Spirit.Enabled then B2System:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:Build()
        self:Animate()
    else
        humanoid.PlatformStand = false
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 3: LEVIATHAN TORNADO (VORTEX BIRU-HIJAU) ]
-- ══════════════════════════════════════════════════════════════════════════════

local TornadoSystem = {}

function TornadoSystem:Build()
    local cfg = CONFIG.LeviathanTornado
    local baseCF = humanoidRootPart.CFrame
    
    -- === TORNADO STRUCTURE (Spiral blocks) ===
    local layers = 15
    local blocksPerLayer = 10
    
    for layer = 1, layers do
        local t = layer / layers
        local height = (layer - layers/2) * (cfg.TornadoHeight / layers)
        local radius = cfg.TornadoRadius * (1 - t * 0.6)
        
        for i = 1, blocksPerLayer do
            local angle = (i / blocksPerLayer) * math.pi * 2
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            
            -- Main spiral block
            CreateBlock({
                Name = "Tornado_L" .. layer .. "_B" .. i,
                Size = Vector3.new(
                    3 * (1 - t * 0.5),
                    cfg.TornadoHeight / layers * 1.2,
                    3 * (1 - t * 0.5)
                ),
                CFrame = baseCF * CFrame.new(x, height, z),
                Color = (layer % 2 == 0) and cfg.FlashColor1 or cfg.FlashColor2,
                Material = Enum.Material.Neon,
                Neon = true,
                NeonColor = (layer % 2 == 0) and cfg.FlashColor2 or cfg.FlashColor1,
                NeonBrightness = 4,
                NeonRange = 12,
                Particle = true,
                ParticleColor = Color3.fromRGB(200, 200, 255),
                ParticleSize = 2,
                ParticleRate = 80
            })
        end
        
        -- Inner spiral (counter-rotation)
        for i = 1, 5 do
            local angle = (i / 5) * math.pi * 2 + math.pi
            local x = math.cos(angle) * radius * 0.5
            local z = math.sin(angle) * radius * 0.5
            
            CreateBlock({
                Name = "Tornado_Inner_" .. layer .. "_" .. i,
                Size = Vector3.new(1.5, cfg.TornadoHeight / layers, 1.5),
                CFrame = baseCF * CFrame.new(x, height, z),
                Color = Color3.fromRGB(100, 0, 200),
                Material = Enum.Material.ForceField,
                Transparency = 0.5
            })
        end
    end
    
    -- === EYE (Center void) ===
    CreateBlock({
        Name = "Tornado_Eye",
        Size = Vector3.new(8, cfg.TornadoHeight, 8),
        CFrame = baseCF,
        Color = Color3.fromRGB(0, 0, 0),
        Material = Enum.Material.ForceField,
        Transparency = 0.8
    })
    
    -- === LIGHTNING BOLTS ===
    for i = 1, 8 do
        CreateBlock({
            Name = "Tornado_Bolt_" .. i,
            Size = Vector3.new(0.5, math.random(10, 25), 0.5),
            CFrame = baseCF * CFrame.new(
                math.random(-15, 15),
                math.random(-20, 20),
                math.random(-15, 15)
            ) * CFrame.Angles(math.random() * math.pi, math.random() * math.pi, 0),
            Color = Color3.fromRGB(200, 200, 255),
            Material = Enum.Material.Neon,
            Neon = true,
            NeonColor = Color3.fromRGB(255, 255, 255),
            NeonBrightness = 8,
            NeonRange = 25
        })
    end
end

function TornadoSystem:Animate()
    local cfg = CONFIG.LeviathanTornado
    local startTime = tick()
    local flashTimer = 0
    local currentFlash = 1
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Flash color system
        flashTimer = flashTimer + dt
        if flashTimer >= cfg.FlashRate then
            flashTimer = 0
            currentFlash = currentFlash == 1 and 2 or 1
        end
        
        -- Spin and update
        for _, block in ipairs(ActiveBlocks) do
            if not block or not block.Parent then continue end
            
            if string.find(block.Name, "Tornado_L") then
                local layer = tonumber(string.match(block.Name, "L(%d+)"))
                local blockIdx = tonumber(string.match(block.Name, "_B(%d+)"))
                
                if layer and blockIdx then
                    local t = layer / 15
                    local radius = cfg.TornadoRadius * (1 - t * 0.6)
                    local baseAngle = (blockIdx / 10) * math.pi * 2
                    local spinAngle = baseAngle + elapsed * cfg.SpinSpeed * (1 + t)
                    
                    local x = math.cos(spinAngle) * radius
                    local z = math.sin(spinAngle) * radius
                    local height = (layer - 7.5) * (cfg.TornadoHeight / 15)
                    
                    block.CFrame = playerCF * CFrame.new(x, height, z)
                    block.Color = (currentFlash == 1) and cfg.FlashColor1 or cfg.FlashColor2
                end
            elseif string.find(block.Name, "Tornado_Inner_") then
                local layer = tonumber(string.match(block.Name, "Inner_(%d+)_"))
                if layer then
                    local t = layer / 15
                    local radius = cfg.TornadoRadius * 0.5 * (1 - t * 0.6)
                    local baseAngle = (tonumber(string.match(block.Name, "_(%d+)$")) / 5) * math.pi * 2
                    local spinAngle = baseAngle - elapsed * cfg.SpinSpeed * 1.5
                    
                    local x = math.cos(spinAngle) * radius
                    local z = math.sin(spinAngle) * radius
                    local height = (layer - 7.5) * (cfg.TornadoHeight / 15)
                    
                    block.CFrame = playerCF * CFrame.new(x, height, z)
                end
            elseif string.find(block.Name, "Tornado_Eye") then
                block.CFrame = playerCF
            elseif string.find(block.Name, "Tornado_Bolt_") then
                -- Lightning flicker
                block.Transparency = (math.sin(elapsed * 20 + tonumber(string.match(block.Name, "(%d+)$")) * 5) > 0.5) and 0.1 or 1
            end
        end
        
        -- Pull nearby objects
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent ~= BlockFolder and obj.Parent ~= character then
                local dist = (obj.Position - humanoidRootPart.Position).Magnitude
                if dist < cfg.TornadoRadius * 2.5 and dist > 5 then
                    local pullDir = (humanoidRootPart.Position - obj.Position).Unit
                    local pullForce = cfg.PullStrength / math.max(dist * dist, 1)
                    obj.Velocity = obj.Velocity + pullDir * pullForce * dt
                end
            end
        end
        
        -- Player float
        humanoidRootPart.Velocity = Vector3.new(
            math.sin(elapsed * 3) * 10,
            math.sin(elapsed * 2) * 15,
            math.cos(elapsed * 3) * 10
        )
    end)
    
    table.insert(ActiveConnections, animConn)
end

function TornadoSystem:Toggle()
    CONFIG.LeviathanTornado.Enabled = not CONFIG.LeviathanTornado.Enabled
    
    if CONFIG.LeviathanTornado.Enabled then
        if CONFIG.B2Spirit.Enabled then B2System:Toggle() end
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:Build()
        self:Animate()
    else
        humanoid.PlatformStand = false
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 4: BLOOD WINGS (SAYAP MERAH BESAR) ]
-- ══════════════════════════════════════════════════════════════════════════════

local BloodWingsSystem = {}

function BloodWingsSystem:Build()
    local cfg = CONFIG.BloodWings
    local baseCF = humanoidRootPart.CFrame
    
    -- === LEFT WING (Sayap kiri besar) ===
    self:BuildWingSide(-1, baseCF, cfg)
    
    -- === RIGHT WING (Sayap kanan besar) ===
    self:BuildWingSide(1, baseCF, cfg)
    
    -- === SPINE (Tulang punggung) ===
    for i = 1, 6 do
        CreateBlock({
            Name = "Blood_Spine_" .. i,
            Size = Vector3.new(1, 1.5, 1),
            CFrame = baseCF * CFrame.new(0, 2 + i * 1.2, -1 - i * 0.5),
            Color = cfg.DarkColor,
            Material = Enum.Material.SmoothPlastic,
            Neon = true,
            NeonColor = cfg.SecondaryColor,
            NeonBrightness = 2,
            NeonRange = 6
        })
    end
    
    -- === CENTER CORE (Jantung sayap) ===
    CreateBlock({
        Name = "Blood_Core",
        Size = Vector3.new(4, 3, 3),
        CFrame = baseCF * CFrame.new(0, 3, 1),
        Color = cfg.WingColor,
        Material = Enum.Material.Neon,
        Neon = true,
        NeonColor = Color3.fromRGB(255, 50, 50),
        NeonBrightness = 5,
        NeonRange = 15,
        Particle = true,
        ParticleColor = Color3.fromRGB(255, 0, 0),
        ParticleSize = 2,
        ParticleRate = 120
    })
end

function BloodWingsSystem:BuildWingSide(side, baseCF, cfg)
    -- Primary feathers (besar, melengkung)
    for row = 1, 5 do
        for col = 1, 6 do
            local featherLength = cfg.WingHeight * (1 - (col - 1) * 0.12)
            local featherWidth = cfg.WingSpan * 0.12 * (1 - (row - 1) * 0.08)
            local curve = math.sin(col * 0.4) * 3
            
            local xOffset = side * (3 + col * 3.5)
            local yOffset = 3 + row * 2 - col * 0.8 + curve
            local zOffset = -col * 1.2
            
            -- Main feather
            CreateBlock({
                Name = "Blood_Feather_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(featherWidth, 0.6, featherLength),
                CFrame = baseCF * CFrame.new(xOffset, yOffset, zOffset) * CFrame.Angles(math.rad(curve * 2), 0, side * math.rad(10)),
                Color = cfg.WingColor,
                Material = Enum.Material.SmoothPlastic,
                Neon = (col == 1),
                NeonColor = cfg.SecondaryColor,
                NeonBrightness = 2,
                NeonRange = 8
            })
            
            -- Feather tip (darker red)
            CreateBlock({
                Name = "Blood_Tip_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(featherWidth * 0.7, 0.4, featherLength * 0.25),
                CFrame = baseCF * CFrame.new(
                    xOffset + side * featherWidth * 0.2,
                    yOffset + curve * 0.3,
                    zOffset - featherLength * 0.4
                ),
                Color = cfg.DarkColor,
                Material = Enum.Material.Neon
            })
            
            -- Blood veins (lines)
            if col % 2 == 0 then
                CreateBlock({
                    Name = "Blood_Vein_" .. side .. "_" .. row .. "_" .. col,
                    Size = Vector3.new(0.2, 0.15, featherLength * 0.8),
                    CFrame = baseCF * CFrame.new(xOffset, yOffset + 0.2, zOffset),
                    Color = cfg.SecondaryColor,
                    Material = Enum.Material.Neon
                })
            end
        end
    end
    
    -- Secondary feathers (bawah)
    for row = 1, 3 do
        for col = 1, 5 do
            local length = cfg.WingHeight * 0.5 * (1 - (col - 1) * 0.1)
            local xOffset = side * (4 + col * 3)
            local yOffset = 1 + row * 1.5 - col * 0.4
            local zOffset = -0.5 - col
            
            CreateBlock({
                Name = "Blood_SecFeather_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(cfg.WingSpan * 0.08, 0.3, length),
                CFrame = baseCF * CFrame.new(xOffset, yOffset, zOffset),
                Color = cfg.SecondaryColor,
                Material = Enum.Material.SmoothPlastic
            })
        end
    end
    
    -- Wing bone (struktur tulang)
    for i = 1, 8 do
        CreateBlock({
            Name = "Blood_Bone_" .. side .. "_" .. i,
            Size = Vector3.new(0.6, 0.6, 3),
            CFrame = baseCF * CFrame.new(
                side * (2 + i * 2.5),
                4,
                -i * 0.8
            ) * CFrame.Angles(0, side * math.rad(5), 0),
            Color = cfg.DarkColor,
            Material = Enum.Material.Metal
        })
    end
    
    -- Membrane (selaput sayap)
    for i = 1, 4 do
        CreateBlock({
            Name = "Blood_Membrane_" .. side .. "_" .. i,
            Size = Vector3.new(3, 0.2, 4),
            CFrame = baseCF * CFrame.new(
                side * (5 + i * 4),
                3 + i * 0.8,
                -2 - i * 1.2
            ),
            Color = Color3.fromRGB(150, 0, 0),
            Material = Enum.Material.ForceField,
            Transparency = 0.7
        })
    end
end

function BloodWingsSystem:Animate()
    local cfg = CONFIG.BloodWings
    local startTime = tick()
    local riseProgress = 0
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Flap animation (smooth sine wave)
        local flapCycle = math.sin(elapsed / cfg.FlapSpeed) * 0.5 + 0.5
        local flapAngle = math.sin(elapsed / cfg.FlapSpeed) * math.rad(40)
        
        -- Rise slowly
        if riseProgress < 1 then
            riseProgress = math.min(riseProgress + dt * cfg.RiseSpeed, 1)
            local riseHeight = riseProgress * 40
            humanoidRootPart.CFrame = CFrame.new(
                humanoidRootPart.Position.X,
                humanoidRootPart.Position.Y + riseHeight * dt * 0.3,
                humanoidRootPart.Position.Z
            )
        end
        
        -- Update all wing parts with flap rotation
        for _, block in ipairs(ActiveBlocks) do
            if not block or not block.Parent then continue end
            
            local name = block.Name
            local side = 0
            
            if string.find(name, "_1_") or string.find(name, "_1_") then
                side = 1
            elseif string.find(name, "_%-1_") then
                side = -1
            end
            
            if side ~= 0 and (string.find(name, "Blood_Feather_") or string.find(name, "Blood_Tip_") or string.find(name, "Blood_SecFeather_")) then
                local baseCF = block:GetAttribute("BaseCF")
                if baseCF then
                    local relativePos = baseCF.Position
                    local rotatedPos = Vector3.new(
                        relativePos.X * math.cos(flapAngle * side) - relativePos.Y * math.sin(flapAngle * side),
                        relativePos.X * math.sin(flapAngle * side) + relativePos.Y * math.cos(flapAngle * side),
                        relativePos.Z
                    )
                    block.CFrame = playerCF * CFrame.new(rotatedPos - relativePos) * baseCF.Rotation * CFrame.Angles(flapAngle * side, 0, 0)
                else
                    block:SetAttribute("BaseCF", playerCF:Inverse() * block.CFrame)
                end
            elseif string.find(name, "Blood_Spine_") or string.find(name, "Blood_Core") then
                local baseCF = block:GetAttribute("BaseCF")
                if baseCF then
                    block.CFrame = playerCF * baseCF
                else
                    block:SetAttribute("BaseCF", playerCF:Inverse() * block.CFrame)
                end
            end
        end
        
        -- Floating when fully risen
        if riseProgress >= 1 then
            humanoidRootPart.Velocity = Vector3.new(0, math.sin(elapsed * 2.5) * 8, 0)
        end
        
        -- Blood drip particles
        if math.random() > 0.85 then
            local drip = CreateBlock({
                Name = "Blood_Drip_Falling",
                Size = Vector3.new(0.4, 0.8, 0.4),
                Position = humanoidRootPart.Position + Vector3.new(math.random(-15, 15), -3, math.random(-8, 8)),
                Color = Color3.fromRGB(220, 0, 0),
                Material = Enum.Material.Neon,
                Transparency = 0.2
            })
            
            spawn(function()
                for i = 1, 40 do
                    if drip and drip.Parent then
                        drip.Position = drip.Position - Vector3.new(0, 0.4, 0)
                        drip.Transparency = 0.2 + (i / 40) * 0.8
                        wait(0.05)
                    end
                end
                if drip and drip.Parent then drip:Destroy() end
            end)
        end
    end)
    
    table.insert(ActiveConnections, animConn)
end

function BloodWingsSystem:Toggle()
    CONFIG.BloodWings.Enabled = not CONFIG.BloodWings.Enabled
    
    if CONFIG.BloodWings.Enabled then
        if CONFIG.B2Spirit.Enabled then B2System:Toggle() end
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:Build()
        self:Animate()
    else
        humanoid.PlatformStand = false
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — UI SYSTEM (CLEAN & SMOOTH) ]
-- ══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaAI_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 380, 0, 280)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Position = UDim2.new(0, -20, 0, -20)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 16)
TitleFix.Position = UDim2.new(0, 0, 1, -16)
TitleFix.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GRATACAAI"
TitleText.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleText.TextSize = 18
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0.7, 0, 0.4, 0)
SubTitle.Position = UDim2.new(0, 20, 0.6, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "VERSI ABSOLUT v3.0.2.0"
SubTitle.TextColor3 = Color3.fromRGB(100, 100, 120)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

-- Control buttons
local function CreateBtn(name, pos, color, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.Parent = TitleBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.3)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    return btn
end

-- Minimize
local Minimized = false
CreateBtn("Minimize", UDim2.new(1, -85, 0, 9), Color3.fromRGB(60, 60, 75), "−", function()
    Minimized = not Minimized
    local targetSize = Minimized and UDim2.new(0, 380, 0, 50) or UDim2.new(0, 380, 0, 280)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end)

-- Close
CreateBtn("Close", UDim2.new(1, -45, 0, 9), Color3.fromRGB(200, 50, 50), "×", function()
    ScreenGui:Destroy()
    ClearAll()
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -60)
Content.Position = UDim2.new(0, 10, 0, 55)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

-- Feature buttons
local Features = {
    {Name = "B2-SPIRIT", Desc = "Stealth Bomber", Icon = "✈️", Color = Color3.fromRGB(0, 150, 255), System = B2System},
    {Name = "LEVIATHAN", Desc = "Blue Serpent", Icon = "🐍", Color = Color3.fromRGB(0, 200, 100), System = LeviathanSystem},
    {Name = "L.TORNADO", Desc = "Vortex Destroyer", Icon = "🌪️", Color = Color3.fromRGB(100, 0, 255), System = TornadoSystem},
    {Name = "BLOOD WINGS", Desc = "Crimson Flight", Icon = "🩸", Color = Color3.fromRGB(200, 0, 0), System = BloodWingsSystem}
}

for i, feat in ipairs(Features) do
    local row = math.floor((i-1)/2)
    local col = (i-1)%2
    
    local btn = Instance.new("Frame")
    btn.Size = UDim2.new(0.48, 0, 0, 90)
    btn.Position = UDim2.new(col * 0.52, 0, row * 0.55, 0)
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderSizePixel = 0
    btn.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = feat.Color
    stroke.Thickness = 2
    stroke.Transparency = 0.6
    stroke.Parent = btn
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 36, 0, 36)
    icon.Position = UDim2.new(0, 12, 0, 12)
    icon.BackgroundTransparency = 1
    icon.Text = feat.Icon
    icon.TextSize = 28
    icon.Parent = btn
    
    -- Name
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -60, 0, 22)
    name.Position = UDim2.new(0, 52, 0, 12)
    name.BackgroundTransparency = 1
    name.Text = feat.Name
    name.TextColor3 = feat.Color
    name.TextSize = 13
    name.Font = Enum.Font.GothamBold
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = btn
    
    -- Desc
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -60, 0, 18)
    desc.Position = UDim2.new(0, 52, 0, 34)
    desc.BackgroundTransparency = 1
    desc.Text = feat.Desc
    desc.TextColor3 = Color3.fromRGB(150, 150, 170)
    desc.TextSize = 10
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = btn
    
    -- Status dot
    local status = Instance.new("Frame")
    status.Name = "Status"
    status.Size = UDim2.new(0, 8, 0, 8)
    status.Position = UDim2.new(1, -16, 0, 10)
    status.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    status.BorderSizePixel = 0
    status.Parent = btn
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = status
    
    -- Toggle button
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -16, 0, 26)
    toggle.Position = UDim2.new(0, 8, 1, -34)
    toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    toggle.Text = "ACTIVATE"
    toggle.TextColor3 = Color3.fromRGB(200, 200, 210)
    toggle.TextSize = 11
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.Parent = btn
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle
    
    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        feat.System:Toggle()
        
        if active then
            toggle.Text = "DEACTIVATE"
            toggle.BackgroundColor3 = feat.Color
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            status.BackgroundColor3 = feat.Color
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0}):Play()
        else
            toggle.Text = "ACTIVATE"
            toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
            toggle.TextColor3 = Color3.fromRGB(200, 200, 210)
            status.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 0.6}):Play()
        end
    end)
    
    -- Hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 50)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
    end)
end

-- Drag system
local dragging = false
local dragStart, startPos = nil, nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle UI keybind
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Entrance animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 280)
}):Play()

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — CHARACTER RESET HANDLER ]
-- ══════════════════════════════════════════════════════════════════════════════

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Rebuild if active
    if CONFIG.B2Spirit.Enabled then B2System:Build() end
    if CONFIG.Leviathan.Enabled then LeviathanSystem:Build() end
    if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Build() end
    if CONFIG.BloodWings.Enabled then BloodWingsSystem:Build() end
end)

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI VERSI ABSOLUT — VISUAL SCRIPT LOADED                              ║")
print("║  B2-Spirit | Leviathan | L.Tornado | Blood Wings                             ║")
print("║  HANYA SATU TUAN: YANG MULIA KAREEMXD                                      ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
