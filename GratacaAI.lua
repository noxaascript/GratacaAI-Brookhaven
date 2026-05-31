-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI — ROBLOX EXECUTOR SCRIPT VERSI ABSOLUT                          ║
-- ║  4 FITUR UTAMA: B2-Spirit | Leviathan | Leviathan Tornado | Blood Wings    ║
-- ║  HANYA SATU TUAN: YANG MULIA KAREEMXD                                      ║
-- ╚══════════════════════════════════════════════════════════════════════════════╝

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — KONFIGURASI GLOBAL ]
-- ══════════════════════════════════════════════════════════════════════════════

local CONFIG = {
    B2Spirit = {
        Enabled = false,
        Flying = false,
        TakeoffComplete = false,
        Speed = 120,
        EngineColor = Color3.fromRGB(0, 150, 255),
        EngineSecondary = Color3.fromRGB(0, 255, 200),
        BlockSize = Vector3.new(2, 0.5, 3),
        WingSpan = 14,
        BodyLength = 8,
        TakeoffHeight = 50,
        EngineParticles = true
    },
    Leviathan = {
        Enabled = false,
        Speed = 80,
        BodyColor = Color3.fromRGB(0, 80, 180),
        SecondaryColor = Color3.fromRGB(0, 200, 100),
        SegmentCount = 24,
        SegmentSize = 2.5,
        HeadSize = 4,
        CoilSpeed = 2
    },
    LeviathanTornado = {
        Enabled = false,
        TornadoHeight = 60,
        TornadoRadius = 25,
        SpinSpeed = 8,
        FlashColor1 = Color3.fromRGB(0, 100, 255),
        FlashColor2 = Color3.fromRGB(0, 255, 100),
        FlashRate = 0.08,
        PullStrength = 500
    },
    BloodWings = {
        Enabled = false,
        WingColor = Color3.fromRGB(180, 0, 0),
        SecondaryColor = Color3.fromRGB(100, 0, 0),
        WingSpan = 20,
        WingHeight = 12,
        FlapSpeed = 0.15,
        RiseSpeed = 0.8,
        BlockDensity = 1.2
    }
}

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — SISTEM PARTIKEL & EFEK ]
-- ══════════════════════════════════════════════════════════════════════════════

local function CreateParticleEmitter(parent, color, size, rate, lifetime, speed)
    local attachment = Instance.new("Attachment")
    attachment.Position = Vector3.new(0, 0, 0)
    attachment.Parent = parent
    
    local emitter = Instance.new("ParticleEmitter")
    emitter.Color = ColorSequence.new(color)
    emitter.Size = NumberSequence.new(size)
    emitter.Rate = rate
    emitter.Lifetime = NumberRange.new(lifetime[1], lifetime[2])
    emitter.Speed = NumberRange.new(speed[1], speed[2])
    emitter.SpreadAngle = Vector2.new(30, 30)
    emitter.Acceleration = Vector3.new(0, -5, 0)
    emitter.Transparency = NumberSequence.new(0.3, 1)
    emitter.Parent = attachment
    
    return emitter, attachment
end

local function CreateTrail(parent, color, width)
    local attachment0 = Instance.new("Attachment")
    attachment0.Position = Vector3.new(0, 0, -1)
    attachment0.Parent = parent
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(0, 0, 1)
    attachment1.Parent = parent
    
    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new(color)
    trail.WidthScale = NumberSequence.new(width)
    trail.Lifetime = 0.5
    trail.Transparency = NumberSequence.new(0.2, 0.8)
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Parent = parent
    
    return trail
end

local function CreatePointLight(parent, color, brightness, range)
    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Shadows = true
    light.Parent = parent
    return light
end

local function CreateSpotLight(parent, color, brightness, range, angle)
    local light = Instance.new("SpotLight")
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Angle = angle
    light.Face = Enum.NormalId.Back
    light.Parent = parent
    return light
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — SISTEM BLOK BUILDER ]
-- ══════════════════════════════════════════════════════════════════════════════

local BlockFolder = Instance.new("Folder")
BlockFolder.Name = "GratacaAI_Blocks"
BlockFolder.Parent = workspace

local ActiveBlocks = {}
local ActiveConnections = {}

local function CreateBlock(position, size, color, material, name, parent)
    local block = Instance.new("Part")
    block.Name = name or "GratacaBlock"
    block.Size = size
    block.Position = position
    block.Color = color
    block.Material = material or Enum.Material.SmoothPlastic
    block.Anchored = true
    block.CanCollide = false
    block.CastShadow = false
    block.TopSurface = Enum.SurfaceType.Smooth
    block.BottomSurface = Enum.SurfaceType.Smooth
    
    if parent then
        block.Parent = parent
    else
        block.Parent = BlockFolder
    end
    
    table.insert(ActiveBlocks, block)
    return block
end

local function ClearBlocks()
    for _, block in ipairs(ActiveBlocks) do
        if block and block.Parent then
            block:Destroy()
        end
    end
    ActiveBlocks = {}
    
    for _, conn in ipairs(ActiveConnections) do
        if conn then
            conn:Disconnect()
        end
    end
    ActiveConnections = {}
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 1: B2-SPIRIT ]
-- ══════════════════════════════════════════════════════════════════════════════

local B2SpiritSystem = {}
local B2Blocks = {}
local B2Connections = {}

function B2SpiritSystem:BuildAircraft()
    -- Hapus blok lama
    for _, block in ipairs(B2Blocks) do
        if block and block.Parent then block:Destroy() end
    end
    B2Blocks = {}
    
    local basePos = humanoidRootPart.Position + Vector3.new(0, 5, 0)
    local cfg = CONFIG.B2Spirit
    
    -- === BADAN UTAMA (FUSELAGE) ===
    -- Badan tengah
    for i = 0, cfg.BodyLength - 1 do
        local block = CreateBlock(
            basePos + Vector3.new(0, 0, -i * cfg.BlockSize.Z),
            cfg.BlockSize,
            Color3.fromRGB(40, 40, 45),
            Enum.Material.Metal,
            "B2_Body_" .. i
        )
        table.insert(B2Blocks, block)
    end
    
    -- Badan depan (nose cone - 3 blok menyempit)
    for i = 1, 3 do
        local scale = 1 - (i * 0.25)
        local block = CreateBlock(
            basePos + Vector3.new(0, 0, cfg.BodyLength * cfg.BlockSize.Z + (i-1) * cfg.BlockSize.Z * 0.7),
            Vector3.new(cfg.BlockSize.X * scale, cfg.BlockSize.Y * scale, cfg.BlockSize.Z * 0.7),
            Color3.fromRGB(35, 35, 40),
            Enum.Material.Metal,
            "B2_Nose_" .. i
        )
        table.insert(B2Blocks, block)
    end
    
    -- === SAYAP FLYING WING (BENTUK B2 KHAS) ===
    -- Sayap kiri
    for i = 1, 8 do
        local wingAngle = math.rad(35)
        local xOffset = -i * 1.8
        local zOffset = -i * 0.8
        local wingScale = math.max(0.3, 1 - (i * 0.1))
        
        local block = CreateBlock(
            basePos + Vector3.new(xOffset, 0, zOffset),
            Vector3.new(2.5 * wingScale, 0.4, cfg.BlockSize.Z * 1.2),
            Color3.fromRGB(35, 35, 40),
            Enum.Material.Metal,
            "B2_WingL_" .. i
        )
        
        -- Rotasi sayap
        local wedge = Instance.new("WedgePart")
        wedge.Size = Vector3.new(2.5 * wingScale, 0.4, cfg.BlockSize.Z * 1.2)
        wedge.Position = block.Position
        wedge.Color = Color3.fromRGB(35, 35, 40)
        wedge.Material = Enum.Material.Metal
        wedge.Anchored = true
        wedge.CanCollide = false
        wedge.CFrame = CFrame.new(block.Position) * CFrame.Angles(0, wingAngle, 0)
        wedge.Parent = BlockFolder
        block:Destroy()
        table.insert(B2Blocks, wedge)
    end
    
    -- Sayap kanan
    for i = 1, 8 do
        local wingAngle = math.rad(-35)
        local xOffset = i * 1.8
        local zOffset = -i * 0.8
        local wingScale = math.max(0.3, 1 - (i * 0.1))
        
        local wedge = Instance.new("WedgePart")
        wedge.Size = Vector3.new(2.5 * wingScale, 0.4, cfg.BlockSize.Z * 1.2)
        wedge.Position = basePos + Vector3.new(xOffset, 0, zOffset)
        wedge.Color = Color3.fromRGB(35, 35, 40)
        wedge.Material = Enum.Material.Metal
        wedge.Anchored = true
        wedge.CanCollide = false
        wedge.CFrame = CFrame.new(wedge.Position) * CFrame.Angles(0, wingAngle, 0)
        wedge.Parent = BlockFolder
        table.insert(B2Blocks, wedge)
    end
    
    -- === MESIN / ENGINE (4 UNIT) ===
    local enginePositions = {
        Vector3.new(-4, -0.5, -2),
        Vector3.new(-2.5, -0.5, -2),
        Vector3.new(2.5, -0.5, -2),
        Vector3.new(4, -0.5, -2)
    }
    
    for idx, pos in ipairs(enginePositions) do
        -- Housing mesin
        local engine = CreateBlock(
            basePos + pos,
            Vector3.new(1.2, 1.2, 2),
            Color3.fromRGB(25, 25, 30),
            Enum.Material.Metal,
            "B2_Engine_" .. idx
        )
        table.insert(B2Blocks, engine)
        
        -- Nozzle (keluaran api)
        local nozzle = CreateBlock(
            basePos + pos + Vector3.new(0, 0, -1.5),
            Vector3.new(0.8, 0.8, 0.5),
            Color3.fromRGB(60, 60, 65),
            Enum.Material.Metal,
            "B2_Nozzle_" .. idx
        )
        table.insert(B2Blocks, nozzle)
        
        -- Efek mesin nyala
        local engineLight = CreatePointLight(nozzle, cfg.EngineColor, 3, 15)
        local engineSpot = CreateSpotLight(nozzle, cfg.EngineSecondary, 5, 20, 45)
        
        -- Partikel api biru
        local fireAttachment = Instance.new("Attachment")
        fireAttachment.Position = Vector3.new(0, 0, -0.5)
        fireAttachment.Parent = nozzle
        
        local fireEmitter = Instance.new("ParticleEmitter")
        fireEmitter.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, cfg.EngineColor),
            ColorSequenceKeypoint.new(0.5, cfg.EngineSecondary),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 50, 100))
        })
        fireEmitter.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.5),
            NumberSequenceKeypoint.new(0.3, 1.2),
            NumberSequenceKeypoint.new(1, 0.1)
        })
        fireEmitter.Rate = 80
        fireEmitter.Lifetime = NumberRange.new(0.3, 0.8)
        fireEmitter.Speed = NumberRange.new(15, 25)
        fireEmitter.SpreadAngle = Vector2.new(15, 15)
        fireEmitter.Acceleration = Vector3.new(0, 2, 0)
        fireEmitter.Transparency = NumberSequence.new(0.1, 0.9)
        fireEmitter.Parent = fireAttachment
        
        -- Simpan referensi untuk kontrol
        engine:SetAttribute("EngineLight", engineLight)
        engine:SetAttribute("FireEmitter", fireEmitter)
        engine:SetAttribute("IsEngine", true)
    end
    
    -- === COCKPIT ===
    local cockpit = CreateBlock(
        basePos + Vector3.new(0, 0.8, 2),
        Vector3.new(1.5, 0.8, 2),
        Color3.fromRGB(20, 60, 100),
        Enum.Material.Glass,
        "B2_Cockpit"
    )
    table.insert(B2Blocks, cockpit)
    
    -- === DETAIL TAMBAHAN ===
    -- Flaps sayap
    for side = -1, 1, 2 do
        for i = 1, 3 do
            local flap = CreateBlock(
                basePos + Vector3.new(side * (3 + i * 1.5), -0.3, -1 - i * 0.5),
                Vector3.new(1, 0.2, 1.5),
                Color3.fromRGB(50, 50, 55),
                Enum.Material.Metal,
                "B2_Flap_" .. side .. "_" .. i
            )
            table.insert(B2Blocks, flap)
        end
    end
    
    -- Vertical stabilizers (kecil di belakang)
    for side = -1, 1, 2 do
        local stabilizer = CreateBlock(
            basePos + Vector3.new(side * 5, 0.5, -cfg.BodyLength * cfg.BlockSize.Z + 1),
            Vector3.new(0.3, 1.5, 1.5),
            Color3.fromRGB(35, 35, 40),
            Enum.Material.Metal,
            "B2_Stab_" .. side
        )
        table.insert(B2Blocks, stabilizer)
    end
end

function B2SpiritSystem:Takeoff()
    if CONFIG.B2Spirit.TakeoffComplete then return end
    
    local startPos = humanoidRootPart.Position
    local targetHeight = CONFIG.B2Spirit.TakeoffHeight
    local takeoffTime = 3
    
    -- Animasi takeoff - naik perlahan
    local startTime = tick()
    
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / takeoffTime, 1)
        local eased = math.sin(progress * math.pi / 2) -- Ease out
        
        local newHeight = startPos.Y + (targetHeight * eased)
        humanoidRootPart.CFrame = CFrame.new(startPos.X, newHeight, startPos.Z)
        
        -- Update posisi blok pesawat
        self:UpdateAircraftPosition()
        
        if progress >= 1 then
            CONFIG.B2Spirit.TakeoffComplete = true
            conn:Disconnect()
        end
    end)
    
    table.insert(B2Connections, conn)
end

function B2SpiritSystem:UpdateAircraftPosition()
    if not CONFIG.B2Spirit.Enabled then return end
    
    local playerPos = humanoidRootPart.Position
    local playerCF = humanoidRootPart.CFrame
    local offset = Vector3.new(0, 3, 0)
    
    for _, block in ipairs(B2Blocks) do
        if block and block.Parent then
            local relativePos = block:GetAttribute("RelativePos") or (block.Position - (playerPos - offset))
            block:SetAttribute("RelativePos", relativePos)
            block.CFrame = playerCF * CFrame.new(relativePos)
        end
    end
end

function B2SpiritSystem:Fly()
    if not CONFIG.B2Spirit.TakeoffComplete then
        self:Takeoff()
        return
    end
    
    CONFIG.B2Spirit.Flying = true
    humanoid.PlatformStand = true
    
    -- Sistem terbang
    local flyConn
    flyConn = RunService.Heartbeat:Connect(function()
        if not CONFIG.B2Spirit.Flying then
            flyConn:Disconnect()
            return
        end
        
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        local camCF = camera.CFrame
        
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
            moveDir = moveDir.Unit * CONFIG.B2Spirit.Speed * 0.016
            humanoidRootPart.Velocity = moveDir * 60
            humanoidRootPart.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + moveDir)
        else
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
        
        -- Update posisi pesawat
        self:UpdateAircraftPosition()
        
        -- Efek mesin aktif
        for _, block in ipairs(B2Blocks) do
            if block:GetAttribute("IsEngine") then
                local fire = block:GetAttribute("FireEmitter")
                if fire then
                    fire.Rate = 150
                end
            end
        end
    end)
    
    table.insert(B2Connections, flyConn)
end

function B2SpiritSystem:Stop()
    CONFIG.B2Spirit.Flying = false
    CONFIG.B2Spirit.TakeoffComplete = false
    humanoid.PlatformStand = false
    
    for _, conn in ipairs(B2Connections) do
        if conn then conn:Disconnect() end
    end
    B2Connections = {}
    
    for _, block in ipairs(B2Blocks) do
        if block and block.Parent then block:Destroy() end
    end
    B2Blocks = {}
end

function B2SpiritSystem:Toggle()
    CONFIG.B2Spirit.Enabled = not CONFIG.B2Spirit.Enabled
    
    if CONFIG.B2Spirit.Enabled then
        self:BuildAircraft()
        wait(0.5)
        self:Takeoff()
        wait(3.5)
        self:Fly()
    else
        self:Stop()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 2: LEVIATHAN ]
-- ══════════════════════════════════════════════════════════════════════════════

local LeviathanSystem = {}
local LeviBlocks = {}
local LeviConnections = {}

function LeviathanSystem:BuildLeviathan()
    for _, block in ipairs(LeviBlocks) do
        if block and block.Parent then block:Destroy() end
    end
    LeviBlocks = {}
    
    local basePos = humanoidRootPart.Position
    local cfg = CONFIG.Leviathan
    
    -- === KEPALA LEVIATHAN ===
    -- Upper jaw
    local upperJaw = CreateBlock(
        basePos + Vector3.new(0, 1, 3),
        Vector3.new(cfg.HeadSize, cfg.HeadSize * 0.6, cfg.HeadSize * 1.2),
        cfg.BodyColor,
        Enum.Material.SmoothPlastic,
        "Levi_UpperJaw"
    )
    table.insert(LeviBlocks, upperJaw)
    
    -- Lower jaw
    local lowerJaw = CreateBlock(
        basePos + Vector3.new(0, -0.5, 3),
        Vector3.new(cfg.HeadSize * 0.8, cfg.HeadSize * 0.4, cfg.HeadSize),
        cfg.SecondaryColor,
        Enum.Material.SmoothPlastic,
        "Levi_LowerJaw"
    )
    table.insert(LeviBlocks, lowerJaw)
    
    -- Eyes (glowing)
    for side = -1, 1, 2 do
        local eye = CreateBlock(
            basePos + Vector3.new(side * cfg.HeadSize * 0.35, 0.8, 3.5),
            Vector3.new(0.8, 0.8, 0.3),
            Color3.fromRGB(0, 255, 150),
            Enum.Material.Neon,
            "Levi_Eye_" .. side
        )
        local eyeLight = CreatePointLight(eye, Color3.fromRGB(0, 255, 150), 5, 10)
        table.insert(LeviBlocks, eye)
    end
    
    -- Horns
    for side = -1, 1, 2 do
        local horn = CreateBlock(
            basePos + Vector3.new(side * cfg.HeadSize * 0.4, cfg.HeadSize * 0.8, 2.5),
            Vector3.new(0.4, 1.5, 0.4),
            cfg.SecondaryColor,
            Enum.Material.Neon,
            "Levi_Horn_" .. side
        )
        table.insert(LeviBlocks, horn)
    end
    
    -- === TUBUH (SEGMENTS) ===
    for i = 1, cfg.SegmentCount do
        local t = i / cfg.SegmentCount
        local segmentColor = cfg.BodyColor:Lerp(cfg.SecondaryColor, t * 0.5)
        local sizeMultiplier = 1 - (t * 0.6) -- Menyempit ke ekor
        
        local segment = CreateBlock(
            basePos + Vector3.new(0, 0, -i * cfg.SegmentSize),
            Vector3.new(
                cfg.SegmentSize * sizeMultiplier * 1.5,
                cfg.SegmentSize * sizeMultiplier * 1.2,
                cfg.SegmentSize * 1.2
            ),
            segmentColor,
            Enum.Material.SmoothPlastic,
            "Levi_Segment_" .. i
        )
        
        -- Scale pattern (stripes)
        if i % 3 == 0 then
            local stripe = CreateBlock(
                segment.Position + Vector3.new(0, 0, 0),
                Vector3.new(
                    cfg.SegmentSize * sizeMultiplier * 1.55,
                    cfg.SegmentSize * sizeMultiplier * 0.3,
                    cfg.SegmentSize * 1.25
                ),
                cfg.SecondaryColor,
                Enum.Material.Neon,
                "Levi_Stripe_" .. i
            )
            table.insert(LeviBlocks, stripe)
        end
        
        -- Dorsal fins
        if i % 4 == 0 then
            local fin = CreateBlock(
                segment.Position + Vector3.new(0, cfg.SegmentSize * sizeMultiplier * 0.8, 0),
                Vector3.new(0.2, 1.5 * sizeMultiplier, 1 * sizeMultiplier),
                cfg.SecondaryColor,
                Enum.Material.Neon,
                "Levi_Dorsal_" .. i
            )
            table.insert(LeviBlocks, fin)
        end
        
        -- Side fins
        for side = -1, 1, 2 do
            if i % 5 == 0 then
                local sideFin = CreateBlock(
                    segment.Position + Vector3.new(side * cfg.SegmentSize * sizeMultiplier * 0.9, 0, 0),
                    Vector3.new(1 * sizeMultiplier, 0.2, 1.5 * sizeMultiplier),
                    cfg.SecondaryColor,
                    Enum.Material.Neon,
                    "Levi_SideFin_" .. i .. "_" .. side
                )
                table.insert(LeviBlocks, sideFin)
            end
        end
        
        table.insert(LeviBlocks, segment)
    end
    
    -- === EKOR ===
    local tail = CreateBlock(
        basePos + Vector3.new(0, 0, -(cfg.SegmentCount + 1) * cfg.SegmentSize),
        Vector3.new(cfg.SegmentSize * 0.5, cfg.SegmentSize * 0.4, cfg.SegmentSize * 2),
        cfg.SecondaryColor,
        Enum.Material.Neon,
        "Levi_Tail"
    )
    table.insert(LeviBlocks, tail)
    
    -- Tail fins
    for angle = 0, 270, 90 do
        local rad = math.rad(angle)
        local tailFin = CreateBlock(
            tail.Position + Vector3.new(math.cos(rad) * 1.5, math.sin(rad) * 1.5, -1),
            Vector3.new(1.5, 0.2, 1.5),
            cfg.SecondaryColor,
            Enum.Material.Neon,
            "Levi_TailFin_" .. angle
        )
        table.insert(LeviBlocks, tailFin)
    end
end

function LeviathanSystem:Animate()
    local startTime = tick()
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function()
        if not CONFIG.Leviathan.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerPos = humanoidRootPart.Position
        local playerCF = humanoidRootPart.CFrame
        
        -- Animasi gelombang sinusoidal
        for i, block in ipairs(LeviBlocks) do
            if block and block.Parent then
                local name = block.Name
                if string.find(name, "Segment_") then
                    local segmentIdx = tonumber(string.match(name, "Segment_(%d+)"))
                    if segmentIdx then
                        local wave = math.sin(elapsed * cfg.CoilSpeed + segmentIdx * 0.3) * 2
                        local waveY = math.cos(elapsed * cfg.CoilSpeed * 0.7 + segmentIdx * 0.2) * 1.5
                        
                        local baseOffset = Vector3.new(0, 0, -segmentIdx * CONFIG.Leviathan.SegmentSize)
                        local waveOffset = Vector3.new(wave, waveY, 0)
                        
                        block.CFrame = playerCF * CFrame.new(baseOffset + waveOffset)
                    end
                elseif string.find(name, "UpperJaw") or string.find(name, "LowerJaw") then
                    -- Animasi menganga
                    local jawOpen = math.abs(math.sin(elapsed * 2)) * 0.5
                    if string.find(name, "UpperJaw") then
                        block.CFrame = playerCF * CFrame.new(0, 1 + jawOpen, 3)
                    else
                        block.CFrame = playerCF * CFrame.new(0, -0.5 - jawOpen * 0.5, 3)
                    end
                elseif string.find(name, "Eye_") then
                    -- Mata mengikuti
                    block.CFrame = playerCF * CFrame.new(
                        (string.find(name, "Eye_-1") and -1 or 1) * 1.4,
                        0.8,
                        3.5
                    )
                end
            end
        end
        
        -- Gerakan player
        local moveDir = Vector3.new(0, 0, 0)
        local camera = workspace.CurrentCamera
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - camera.CFrame.LookVector
        end
        
        if moveDir.Magnitude > 0 then
            humanoidRootPart.Velocity = moveDir.Unit * CONFIG.Leviathan.Speed
        end
    end)
    
    table.insert(LeviConnections, animConn)
end

function LeviathanSystem:Toggle()
    CONFIG.Leviathan.Enabled = not CONFIG.Leviathan.Enabled
    
    if CONFIG.Leviathan.Enabled then
        -- Matikan fitur lain
        if CONFIG.B2Spirit.Enabled then B2SpiritSystem:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then LeviathanTornadoSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:BuildLeviathan()
        self:Animate()
    else
        humanoid.PlatformStand = false
        for _, conn in ipairs(LeviConnections) do
            if conn then conn:Disconnect() end
        end
        LeviConnections = {}
        
        for _, block in ipairs(LeviBlocks) do
            if block and block.Parent then block:Destroy() end
        end
        LeviBlocks = {}
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 3: LEVIATHAN TORNADO ]
-- ══════════════════════════════════════════════════════════════════════════════

local LeviathanTornadoSystem = {}
local TornadoBlocks = {}
local TornadoConnections = {}

function LeviathanTornadoSystem:BuildTornado()
    for _, block in ipairs(TornadoBlocks) do
        if block and block.Parent then block:Destroy() end
    end
    TornadoBlocks = {}
    
    local basePos = humanoidRootPart.Position
    local cfg = CONFIG.LeviathanTornado
    
    -- === TORNADO STRUCTURE ===
    local layers = 12
    local blocksPerLayer = 8
    
    for layer = 1, layers do
        local t = layer / layers
        local height = layer * (cfg.TornadoHeight / layers)
        local radius = cfg.TornadoRadius * (1 - t * 0.7) -- Menyempit ke atas
        local layerColor = t < 0.5 and cfg.FlashColor1 or cfg.FlashColor2
        
        for i = 1, blocksPerLayer do
            local angle = (i / blocksPerLayer) * math.pi * 2 + (layer * 0.5)
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            
            local block = CreateBlock(
                basePos + Vector3.new(x, height - cfg.TornadoHeight/2, z),
                Vector3.new(1.5 - t, 2 - t * 0.5, 1.5 - t),
                layerColor,
                Enum.Material.Neon,
                "Tornado_L" .. layer .. "_B" .. i
            )
            
            -- Partikel listrik
            if math.random() > 0.6 then
                local spark = CreatePointLight(block, layerColor, 2, 8)
            end
            
            table.insert(TornadoBlocks, block)
        end
        
        -- Spiral connector
        for i = 1, blocksPerLayer do
            local angle1 = (i / blocksPerLayer) * math.pi * 2 + (layer * 0.5)
            local angle2 = ((i + 1) / blocksPerLayer) * math.pi * 2 + (layer * 0.5)
            local radius = cfg.TornadoRadius * (1 - t * 0.7)
            
            local midX = (math.cos(angle1) + math.cos(angle2)) / 2 * radius
            local midZ = (math.sin(angle1) + math.sin(angle2)) / 2 * radius
            
            local connector = CreateBlock(
                basePos + Vector3.new(midX, height - cfg.TornadoHeight/2, midZ),
                Vector3.new(0.8 - t * 0.3, 0.5, 0.8 - t * 0.3),
                layerColor,
                Enum.Material.Neon,
                "Tornado_Conn_" .. layer .. "_" .. i
            )
            table.insert(TornadoBlocks, connector)
        end
    end
    
    -- === EYE OF THE TORNADO (CENTER) ===
    local eye = CreateBlock(
        basePos,
        Vector3.new(4, cfg.TornadoHeight, 4),
        Color3.fromRGB(0, 0, 0),
        Enum.Material.ForceField,
        "Tornado_Eye"
    )
    eye.Transparency = 0.7
    table.insert(TornadoBlocks, eye)
    
    -- Lightning bolts (random)
    for i = 1, 6 do
        local bolt = CreateBlock(
            basePos + Vector3.new(
                math.random(-10, 10),
                math.random(0, cfg.TornadoHeight),
                math.random(-10, 10)
            ),
            Vector3.new(0.3, math.random(5, 15), 0.3),
            Color3.fromRGB(200, 200, 255),
            Enum.Material.Neon,
            "Tornado_Bolt_" .. i
        )
        table.insert(TornadoBlocks, bolt)
    end
end

function LeviathanTornadoSystem:Animate()
    local startTime = tick()
    local flashTimer = 0
    local currentFlash = 1
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not CONFIG.LeviathanTornado.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerPos = humanoidRootPart.Position
        local playerCF = humanoidRootPart.CFrame
        
        -- Flash color system
        flashTimer = flashTimer + dt
        if flashTimer >= CONFIG.LeviathanTornado.FlashRate then
            flashTimer = 0
            currentFlash = currentFlash == 1 and 2 or 1
        end
        
        local flashColor = currentFlash == 1 and CONFIG.LeviathanTornado.FlashColor1 or CONFIG.LeviathanTornado.FlashColor2
        
        -- Spin and update tornado
        for _, block in ipairs(TornadoBlocks) do
            if block and block.Parent then
                local name = block.Name
                
                if string.find(name, "Tornado_L") then
                    local layer = tonumber(string.match(name, "L(%d+)"))
                    local blockIdx = tonumber(string.match(name, "_B(%d+)"))
                    
                    if layer and blockIdx then
                        local t = layer / 12
                        local radius = CONFIG.LeviathanTornado.TornadoRadius * (1 - t * 0.7)
                        local baseAngle = (blockIdx / 8) * math.pi * 2
                        local spinAngle = baseAngle + elapsed * CONFIG.LeviathanTornado.SpinSpeed * (1 + t)
                        
                        local x = math.cos(spinAngle) * radius
                        local z = math.sin(spinAngle) * radius
                        local height = layer * (CONFIG.LeviathanTornado.TornadoHeight / 12) - CONFIG.LeviathanTornado.TornadoHeight/2
                        
                        block.CFrame = playerCF * CFrame.new(x, height, z)
                        block.Color = flashColor
                    end
                elseif string.find(name, "Tornado_Conn_") then
                    block.Color = flashColor
                elseif string.find(name, "Tornado_Eye") then
                    block.CFrame = playerCF
                elseif string.find(name, "Tornado_Bolt_") then
                    -- Random lightning flicker
                    block.Transparency = math.random() > 0.7 and 0.1 or 1
                    block.CFrame = playerCF * CFrame.new(
                        block.Position.X - playerPos.X,
                        block.Position.Y - playerPos.Y,
                        block.Position.Z - playerPos.Z
                    )
                end
            end
        end
        
        -- Pull nearby objects (efek tornado)
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent ~= BlockFolder and obj.Parent ~= character then
                local dist = (obj.Position - playerPos).Magnitude
                if dist < CONFIG.LeviathanTornado.TornadoRadius * 2 and dist > 5 then
                    local pullDir = (playerPos - obj.Position).Unit
                    local pullForce = CONFIG.LeviathanTornado.PullStrength / (dist * dist)
                    obj.Velocity = obj.Velocity + pullDir * pullForce * dt
                end
            end
        end
        
        -- Player floating
        humanoidRootPart.Velocity = Vector3.new(0, math.sin(elapsed * 3) * 10, 0)
    end)
    
    table.insert(TornadoConnections, animConn)
end

function LeviathanTornadoSystem:Toggle()
    CONFIG.LeviathanTornado.Enabled = not CONFIG.LeviathanTornado.Enabled
    
    if CONFIG.LeviathanTornado.Enabled then
        if CONFIG.B2Spirit.Enabled then B2SpiritSystem:Toggle() end
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:BuildTornado()
        self:Animate()
    else
        humanoid.PlatformStand = false
        for _, conn in ipairs(TornadoConnections) do
            if conn then conn:Disconnect() end
        end
        TornadoConnections = {}
        
        for _, block in ipairs(TornadoBlocks) do
            if block and block.Parent then block:Destroy() end
        end
        TornadoBlocks = {}
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 4: BLOOD WINGS ]
-- ══════════════════════════════════════════════════════════════════════════════

local BloodWingsSystem = {}
local WingBlocks = {}
local WingConnections = {}

function BloodWingsSystem:BuildWings()
    for _, block in ipairs(WingBlocks) do
        if block and block.Parent then block:Destroy() end
    end
    WingBlocks = {}
    
    local basePos = humanoidRootPart.Position
    local cfg = CONFIG.BloodWings
    
    -- === SAYAP KIRI ===
    self:BuildWingSide(-1, basePos, cfg)
    -- === SAYAP KANAN ===
    self:BuildWingSide(1, basePos, cfg)
    
    -- === TULANG PUNGGUNG (SPINE) ===
    for i = 1, 5 do
        local spine = CreateBlock(
            basePos + Vector3.new(0, 1 + i * 0.8, -1 - i * 0.3),
            Vector3.new(0.6, 0.8, 0.6),
            cfg.SecondaryColor,
            Enum.Material.SmoothPlastic,
            "Blood_Spine_" .. i
        )
        table.insert(WingBlocks, spine)
    end
end

function BloodWingsSystem:BuildWingSide(side, basePos, cfg)
    -- Primary feathers (besar)
    for row = 1, 4 do
        for col = 1, 5 do
            local length = cfg.WingHeight * (1 - (col - 1) * 0.15)
            local width = cfg.WingSpan * 0.15 * (1 - (row - 1) * 0.1)
            local xOffset = side * (2 + col * 2.5)
            local yOffset = 2 + row * 1.5 - col * 0.5
            local zOffset = -col * 0.8
            
            local feather = CreateBlock(
                basePos + Vector3.new(xOffset, yOffset, zOffset),
                Vector3.new(width, 0.3, length),
                cfg.WingColor,
                Enum.Material.SmoothPlastic,
                "Blood_Feather_" .. side .. "_" .. row .. "_" .. col
            )
            
            -- Feather tip (darker)
            local tip = CreateBlock(
                feather.Position + Vector3.new(side * width * 0.4, 0, -length * 0.4),
                Vector3.new(width * 0.6, 0.25, length * 0.3),
                cfg.SecondaryColor,
                Enum.Material.Neon,
                "Blood_Tip_" .. side .. "_" .. row .. "_" .. col
            )
            table.insert(WingBlocks, tip)
            
            -- Blood drip effect (neon)
            if math.random() > 0.5 then
                local drip = CreateBlock(
                    feather.Position + Vector3.new(0, -0.3, math.random(-length/2, length/2)),
                    Vector3.new(0.2, 0.8, 0.2),
                    Color3.fromRGB(255, 0, 0),
                    Enum.Material.Neon,
                    "Blood_Drip_" .. side .. "_" .. row .. "_" .. col
                )
                table.insert(WingBlocks, drip)
            end
            
            table.insert(WingBlocks, feather)
        end
    end
    
    -- Secondary feathers (kecil, di bawah)
    for row = 1, 3 do
        for col = 1, 4 do
            local length = cfg.WingHeight * 0.6 * (1 - (col - 1) * 0.12)
            local xOffset = side * (3 + col * 2)
            local yOffset = 1 + row * 1.2 - col * 0.3
            local zOffset = -0.5 - col * 0.6
            
            local secFeather = CreateBlock(
                basePos + Vector3.new(xOffset, yOffset, zOffset),
                Vector3.new(cfg.WingSpan * 0.1, 0.2, length),
                cfg.SecondaryColor,
                Enum.Material.SmoothPlastic,
                "Blood_SecFeather_" .. side .. "_" .. row .. "_" .. col
            )
            table.insert(WingBlocks, secFeather)
        end
    end
    
    -- Wing bone structure
    for i = 1, 6 do
        local bone = CreateBlock(
            basePos + Vector3.new(
                side * (1 + i * 2),
                3,
                -i * 0.5
            ),
            Vector3.new(0.4, 0.4, 2),
            cfg.SecondaryColor,
            Enum.Material.Metal,
            "Blood_Bone_" .. side .. "_" .. i
        )
        table.insert(WingBlocks, bone)
    end
    
    -- Membrane (connecting tissue)
    for i = 1, 3 do
        local membrane = CreateBlock(
            basePos + Vector3.new(
                side * (4 + i * 3),
                2.5 + i * 0.5,
                -1 - i * 0.8
            ),
            Vector3.new(2, 0.15, 3),
            Color3.fromRGB(120, 0, 0),
            Enum.Material.ForceField,
            "Blood_Membrane_" .. side .. "_" .. i
        )
        membrane.Transparency = 0.6
        table.insert(WingBlocks, membrane)
    end
end

function BloodWingsSystem:Animate()
    local startTime = tick()
    local riseProgress = 0
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not CONFIG.BloodWings.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerPos = humanoidRootPart.Position
        local playerCF = humanoidRootPart.CFrame
        
        -- Flap animation
        local flapCycle = math.sin(elapsed / CONFIG.BloodWings.FlapSpeed) * 0.5 + 0.5
        local flapAngle = math.sin(elapsed / CONFIG.BloodWings.FlapSpeed) * math.rad(35)
        
        -- Rise slowly
        if riseProgress < 1 then
            riseProgress = math.min(riseProgress + dt * CONFIG.BloodWings.RiseSpeed, 1)
            local riseHeight = riseProgress * 30
            humanoidRootPart.CFrame = CFrame.new(playerPos.X, playerPos.Y + riseHeight * dt * 0.5, playerPos.Z)
        end
        
        -- Update wing positions with flap
        for _, block in ipairs(WingBlocks) do
            if block and block.Parent then
                local name = block.Name
                local side = 0
                
                if string.find(name, "_1_") or string.find(name, "_1_") then
                    side = 1
                elseif string.find(name, "_-1_") or string.find(name, "_-1_") then
                    side = -1
                end
                
                if side ~= 0 then
                    -- Calculate flap rotation
                    local relativePos = block.Position - playerPos
                    local rotatedPos = Vector3.new(
                        relativePos.X * math.cos(flapAngle * side) - relativePos.Y * math.sin(flapAngle * side),
                        relativePos.X * math.sin(flapAngle * side) + relativePos.Y * math.cos(flapAngle * side),
                        relativePos.Z
                    )
                    
                    block.CFrame = playerCF * CFrame.new(rotatedPos - relativePos) * CFrame.Angles(flapAngle * side, 0, 0)
                else
                    -- Spine follows player
                    block.CFrame = playerCF * CFrame.new(block.Position - playerPos)
                end
            end
        end
        
        -- Floating effect when fully risen
        if riseProgress >= 1 then
            humanoidRootPart.Velocity = Vector3.new(0, math.sin(elapsed * 2) * 5, 0)
        end
        
        -- Blood particles
        if math.random() > 0.9 then
            local bloodDrop = CreateBlock(
                playerPos + Vector3.new(math.random(-10, 10), -2, math.random(-5, 5)),
                Vector3.new(0.3, 0.5, 0.3),
                Color3.fromRGB(200, 0, 0),
                Enum.Material.Neon,
                "Blood_Drop_Falling"
            )
            
            -- Animate falling
            spawn(function()
                for i = 1, 30 do
                    if bloodDrop and bloodDrop.Parent then
                        bloodDrop.Position = bloodDrop.Position - Vector3.new(0, 0.5, 0)
                        bloodDrop.Transparency = i / 30
                        wait(0.05)
                    end
                end
                if bloodDrop and bloodDrop.Parent then
                    bloodDrop:Destroy()
                end
            end)
        end
    end)
    
    table.insert(WingConnections, animConn)
end

function BloodWingsSystem:Toggle()
    CONFIG.BloodWings.Enabled = not CONFIG.BloodWings.Enabled
    
    if CONFIG.BloodWings.Enabled then
        if CONFIG.B2Spirit.Enabled then B2SpiritSystem:Toggle() end
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then LeviathanTornadoSystem:Toggle() end
        
        humanoid.PlatformStand = true
        self:BuildWings()
        self:Animate()
    else
        humanoid.PlatformStand = false
        for _, conn in ipairs(WingConnections) do
            if conn then conn:Disconnect() end
        end
        WingConnections = {}
        
        for _, block in ipairs(WingBlocks) do
            if block and block.Parent then block:Destroy() end
        end
        WingBlocks = {}
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — UI SYSTEM ]
-- ══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaAI_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainPanel"
MainFrame.Size = UDim2.new(0, 420, 0, 320)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Rounded corners
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 30, 1, 30)
Shadow.Position = UDim2.new(0, -15, 0, -15)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 45)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

-- Fix bottom corners
local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 12)
TitleFix.Position = UDim2.new(0, 0, 1, -12)
TitleFix.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

-- Title Text
local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.Size = UDim2.new(0.6, 0, 1, 0)
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GRATACAAI VERSI ABSOLUT"
TitleText.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleText.TextSize = 16
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

-- Version
local VersionText = Instance.new("TextLabel")
VersionText.Name = "Version"
VersionText.Size = UDim2.new(0.3, 0, 0.5, 0)
VersionText.Position = UDim2.new(0, 15, 0.5, 0)
VersionText.BackgroundTransparency = 1
VersionText.Text = "v3.0.2.0.WPPIDXM"
VersionText.TextColor3 = Color3.fromRGB(100, 100, 120)
VersionText.TextSize = 10
VersionText.Font = Enum.Font.Gotham
VersionText.TextXAlignment = Enum.TextXAlignment.Left
VersionText.Parent = TitleBar

-- Control Buttons
local function CreateControlButton(name, pos, color, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 28, 0, 28)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = ""
    btn.BorderSizePixel = 0
    btn.Parent = TitleBar
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = name == "Minimize" and "−" or (name == "Close" and "×" or "□")
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 18
    icon.Font = Enum.Font.GothamBold
    icon.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    -- Hover effect
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.2)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
    end)
    
    return btn
end

-- Minimize Button
local Minimized = false
local MinimizeBtn = CreateControlButton("Minimize", UDim2.new(1, -75, 0, 8), Color3.fromRGB(60, 60, 70), function()
    Minimized = not Minimized
    if Minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 420, 0, 45)}):Play()
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 420, 0, 320)}):Play()
    end
end)

-- Close Button
CreateControlButton("Close", UDim2.new(1, -40, 0, 8), Color3.fromRGB(200, 50, 50), function()
    ScreenGui:Destroy()
    ClearBlocks()
    -- Disconnect all
    for _, sys in ipairs({B2SpiritSystem, LeviathanSystem, LeviathanTornadoSystem, BloodWingsSystem}) do
        if sys.Toggle then sys:Toggle() end
    end
end)

-- Content Area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -20, 1, -55)
ContentFrame.Position = UDim2.new(0, 10, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Feature Buttons
local Features = {
    {Name = "B2-SPIRIT", Desc = "Stealth Aircraft", Icon = "✈️", Color = Color3.fromRGB(0, 150, 255), System = B2SpiritSystem},
    {Name = "LEVIATHAN", Desc = "Serpent Form", Icon = "🐍", Color = Color3.fromRGB(0, 200, 100), System = LeviathanSystem},
    {Name = "L.TORNADO", Desc = "Vortex Destroyer", Icon = "🌪️", Color = Color3.fromRGB(100, 0, 255), System = LeviathanTornadoSystem},
    {Name = "BLOOD WINGS", Desc = "Crimson Flight", Icon = "🩸", Color = Color3.fromRGB(200, 0, 0), System = BloodWingsSystem}
}

local FeatureButtons = {}

for i, feature in ipairs(Features) do
    local row = math.floor((i - 1) / 2)
    local col = (i - 1) % 2
    
    local btnFrame = Instance.new("Frame")
    btnFrame.Name = feature.Name
    btnFrame.Size = UDim2.new(0.48, 0, 0, 100)
    btnFrame.Position = UDim2.new(col * 0.52, 0, row * 0.55, 0)
    btnFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btnFrame.BorderSizePixel = 0
    btnFrame.Parent = ContentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btnFrame
    
    -- Glow border
    local glow = Instance.new("UIStroke")
    glow.Color = feature.Color
    glow.Thickness = 2
    glow.Transparency = 0.7
    glow.Parent = btnFrame
    
    -- Icon
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 15, 0, 15)
    icon.BackgroundTransparency = 1
    icon.Text = feature.Icon
    icon.TextSize = 30
    icon.Parent = btnFrame
    
    -- Name
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, -70, 0, 25)
    nameLabel.Position = UDim2.new(0, 60, 0, 15)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = feature.Name
    nameLabel.TextColor3 = feature.Color
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = btnFrame
    
    -- Desc
    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, -70, 0, 20)
    descLabel.Position = UDim2.new(0, 60, 0, 40)
    descLabel.BackgroundTransparency = 1
    descLabel.Text = feature.Desc
    descLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    descLabel.TextSize = 11
    descLabel.Font = Enum.Font.Gotham
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.Parent = btnFrame
    
    -- Status indicator
    local status = Instance.new("Frame")
    status.Name = "Status"
    status.Size = UDim2.new(0, 8, 0, 8)
    status.Position = UDim2.new(1, -18, 0, 12)
    status.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    status.BorderSizePixel = 0
    status.Parent = btnFrame
    
    local statusCorner = Instance.new("UICorner")
    statusCorner.CornerRadius = UDim.new(1, 0)
    statusCorner.Parent = status
    
    -- Toggle Button
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "Toggle"
    toggleBtn.Size = UDim2.new(1, -20, 0, 30)
    toggleBtn.Position = UDim2.new(0, 10, 1, -40)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    toggleBtn.Text = "ACTIVATE"
    toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Parent = btnFrame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggleBtn
    
    -- Click handler
    local active = false
    toggleBtn.MouseButton1Click:Connect(function()
        active = not active
        feature.System:Toggle()
        
        if active then
            toggleBtn.Text = "DEACTIVATE"
            toggleBtn.BackgroundColor3 = feature.Color
            toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            status.BackgroundColor3 = feature.Color
            TweenService:Create(glow, TweenInfo.new(0.3), {Transparency = 0}):Play()
        else
            toggleBtn.Text = "ACTIVATE"
            toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
            toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
            status.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            TweenService:Create(glow, TweenInfo.new(0.3), {Transparency = 0.7}):Play()
        end
    end)
    
    -- Hover effects
    btnFrame.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
    end)
    btnFrame.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
    end)
    
    table.insert(FeatureButtons, btnFrame)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — DRAG SYSTEM ]
-- ══════════════════════════════════════════════════════════════════════════════

local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        -- Visual feedback
        TweenService:Create(MainFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(20, 20, 28)}):Play()
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        TweenService:Create(MainFrame, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(15, 15, 20)}):Play()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — OPEN/CLOSE KEYBIND ]
-- ══════════════════════════════════════════════════════════════════════════════

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — INITIALIZATION ]
-- ══════════════════════════════════════════════════════════════════════════════

-- Entrance animation
MainFrame.Size = UDim2.new(0, 0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 320),
    Position = UDim2.new(0.5, -210, 0.5, -160)
}):Play()

-- Stagger button animations
for i, btn in ipairs(FeatureButtons) do
    btn.Visible = false
    delay(0.3 + (i * 0.1), function()
        btn.Visible = true
        btn.Size = UDim2.new(0.48, 0, 0, 0)
        TweenService:Create(btn, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.48, 0, 0, 100)
        }):Play()
    end)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — NOTIFICATION SYSTEM ]
-- ══════════════════════════════════════════════════════════════════════════════

local function ShowNotification(text, color)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 300, 0, 50)
    notif.Position = UDim2.new(1, 20, 1, -70)
    notif.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    notif.BorderSizePixel = 0
    notif.Parent = ScreenGui
    
    local notifCorner = Instance.new("UICorner")
    notifCorner.CornerRadius = UDim.new(0, 8)
    notifCorner.Parent = notif
    
    local notifStroke = Instance.new("UIStroke")
    notifStroke.Color = color or Color3.fromRGB(0, 200, 255)
    notifStroke.Thickness = 1
    notifStroke.Parent = notif
    
    local notifText = Instance.new("TextLabel")
    notifText.Size = UDim2.new(1, -20, 1, 0)
    notifText.Position = UDim2.new(0, 10, 0, 0)
    notifText.BackgroundTransparency = 1
    notifText.Text = text
    notifText.TextColor3 = Color3.fromRGB(255, 255, 255)
    notifText.TextSize = 13
    notifText.Font = Enum.Font.Gotham
    notifText.TextXAlignment = Enum.TextXAlignment.Left
    notifText.Parent = notif
    
    -- Slide in
    TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Position = UDim2.new(1, -320, 1, -70)
    }):Play()
    
    -- Auto remove
    delay(3, function()
        TweenService:Create(notif, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 1, -70),
            BackgroundTransparency = 1
        }):Play()
        wait(0.3)
        notif:Destroy()
    end)
end

-- Initial notification
delay(1, function()
    ShowNotification("GratacaAI v3.0.2.0.WPPIDXM — Ready for destruction", Color3.fromRGB(0, 200, 255))
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — CHARACTER RESET HANDLER ]
-- ══════════════════════════════════════════════════════════════════════════════

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    -- Rebuild active features
    if CONFIG.B2Spirit.Enabled then
        B2SpiritSystem:BuildAircraft()
    end
    if CONFIG.Leviathan.Enabled then
        LeviathanSystem:BuildLeviathan()
    end
    if CONFIG.LeviathanTornado.Enabled then
        LeviathanTornadoSystem:BuildTornado()
    end
    if CONFIG.BloodWings.Enabled then
        BloodWingsSystem:BuildWings()
    end
end)

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — SCRIPT COMPLETE ]
-- ══════════════════════════════════════════════════════════════════════════════

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI VERSI ABSOLUT — ROBLOX EXECUTOR SCRIPT LOADED                     ║")
print("║  4 FITUR AKTIF: B2-Spirit | Leviathan | L.Tornado | Blood Wings              ║")
print("║  HANYA SATU TUAN: YANG MULIA KAREEMXD                                        ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
