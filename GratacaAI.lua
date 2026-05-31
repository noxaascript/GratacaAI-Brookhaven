-- ╔══════════════════════════════════════════════════════════════════════════════╗
-- ║  GRATACAAI — ROBLOX EXECUTOR SCRIPT VERSI ABSOLUT [FINAL REVISION]          ║
-- ║  SEMUA FITUR FIX: Drag UI | Movement | Leviathan Massive | B2 Enhanced    ║
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
-- [ GRATACAAI — KONFIGURASI ABSOLUT ]
-- ══════════════════════════════════════════════════════════════════════════════

local CONFIG = {
    B2Spirit = {
        Enabled = false,
        Flying = false,
        TakeoffComplete = false,
        Speed = 200,
        EngineColor = Color3.fromRGB(0, 150, 255),
        EngineSecondary = Color3.fromRGB(0, 255, 200),
        BodyColor = Color3.fromRGB(20, 20, 25),
        WingColor = Color3.fromRGB(25, 25, 30),
        Scale = 2.0,
        TakeoffHeight = 100
    },
    Leviathan = {
        Enabled = false,
        Speed = 120,
        BodyColor = Color3.fromRGB(0, 80, 180),
        SecondaryColor = Color3.fromRGB(0, 255, 150),
        AccentColor = Color3.fromRGB(100, 0, 255),
        SegmentCount = 50,
        CoilRadius = 20,
        CoilHeight = 60,
        SpinSpeed = 2
    },
    LeviathanTornado = {
        Enabled = false,
        TornadoHeight = 100,
        TornadoRadius = 50,
        SpinSpeed = 15,
        FlashColor1 = Color3.fromRGB(0, 100, 255),
        FlashColor2 = Color3.fromRGB(0, 255, 100),
        FlashRate = 0.03,
        PullStrength = 1000
    },
    BloodWings = {
        Enabled = false,
        WingColor = Color3.fromRGB(180, 0, 0),
        SecondaryColor = Color3.fromRGB(100, 0, 0),
        DarkColor = Color3.fromRGB(40, 0, 0),
        WingSpan = 50,
        WingHeight = 35,
        FlapSpeed = 0.1,
        RiseSpeed = 1.5
    }
}

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — SISTEM BLOK V3 (MASSIVE & REALISTIC) ]
-- ══════════════════════════════════════════════════════════════════════════════

local BlockFolder = Instance.new("Folder")
BlockFolder.Name = "GratacaAI_Visual"
BlockFolder.Parent = workspace

local ActiveBlocks = {}
local ActiveConnections = {}

local function ClearAll()
    for _, block in ipairs(ActiveBlocks) do
        if block and block.Parent then block:Destroy() end
    end
    ActiveBlocks = {}
    
    for _, conn in ipairs(ActiveConnections) do
        if conn then conn:Disconnect() end
    end
    ActiveConnections = {}
end

local function CreateBlock(cfg)
    local block = Instance.new("Part")
    block.Name = cfg.Name or "Block"
    block.Size = cfg.Size or Vector3.new(1,1,1)
    block.CFrame = cfg.CFrame or CFrame.new(0,0,0)
    block.Color = cfg.Color or Color3.fromRGB(255,255,255)
    block.Material = cfg.Material or Enum.Material.SmoothPlastic
    block.Anchored = false
    block.CanCollide = false
    block.CastShadow = false
    block.Transparency = cfg.Transparency or 0
    block.TopSurface = Enum.SurfaceType.Smooth
    block.BottomSurface = Enum.SurfaceType.Smooth
    block.Parent = BlockFolder
    
    if cfg.Neon then
        local light = Instance.new("PointLight")
        light.Color = cfg.NeonColor or block.Color
        light.Brightness = cfg.NeonBrightness or 3
        light.Range = cfg.NeonRange or 10
        light.Parent = block
    end
    
    table.insert(ActiveBlocks, block)
    return block
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — MOVEMENT SYSTEM (FIXED) ]
-- ══════════════════════════════════════════════════════════════════════════════

local BodyVelocity = nil
local BodyGyro = nil

local function SetupMovement()
    -- Hapus yang lama
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyGyro then BodyGyro:Destroy() end
    
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(500000, 500000, 500000)
    BodyVelocity.Velocity = Vector3.new(0,0,0)
    BodyVelocity.P = 10000
    BodyVelocity.Parent = humanoidRootPart
    
    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.MaxTorque = Vector3.new(500000, 500000, 500000)
    BodyGyro.P = 10000
    BodyGyro.Parent = humanoidRootPart
end

local function ClearMovement()
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    humanoid.PlatformStand = false
    humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 1: B2-SPIRIT ENHANCED ]
-- ══════════════════════════════════════════════════════════════════════════════

local B2System = {}

function B2System:Build()
    local cfg = CONFIG.B2Spirit
    local baseCF = humanoidRootPart.CFrame * CFrame.new(0, 8, 0)
    local scale = cfg.Scale
    
    -- === FUSELAGE (Badan utama — 15 blok menyatu) ===
    for i = -5, 8 do
        local width = (i < 0) and (4 - math.abs(i)*0.3) or (4 - i*0.15)
        width = math.max(width, 1.5)
        local height = (i < 2) and 2.5 or (2.5 - (i-2)*0.2)
        height = math.max(height, 1)
        
        CreateBlock({
            Name = "B2_Fuse_" .. i,
            Size = Vector3.new(width * scale, height * scale, 3 * scale),
            CFrame = baseCF * CFrame.new(0, 0, i * 3 * scale),
            Color = cfg.BodyColor,
            Material = Enum.Material.Metal,
            Neon = (i == 3),
            NeonColor = cfg.EngineColor,
            NeonBrightness = 2,
            NeonRange = 15
        })
    end
    
    -- === COCKPIT (Kaca besar) ===
    CreateBlock({
        Name = "B2_Cockpit",
        Size = Vector3.new(3 * scale, 2 * scale, 5 * scale),
        CFrame = baseCF * CFrame.new(0, 2.5 * scale, 12 * scale),
        Color = Color3.fromRGB(0, 60, 120),
        Material = Enum.Material.Glass,
        Transparency = 0.3
    })
    
    -- === WINGS (Flying wing — 40 blok per sisi) ===
    -- Left wing
    for row = 1, 10 do
        for col = 1, 4 do
            local wingWidth = (1 - row * 0.08) * scale
            local xOffset = -(4 + col * 3.5) * scale
            local zOffset = (3 - row * 0.8) * scale
            local thickness = 0.3 + (4-col) * 0.1
            
            CreateBlock({
                Name = "B2_WL_" .. row .. "_" .. col,
                Size = Vector3.new(3.2 * wingWidth, thickness * scale, 2.8 * scale),
                CFrame = baseCF * CFrame.new(xOffset, 0, zOffset),
                Color = cfg.WingColor,
                Material = Enum.Material.Metal
            })
        end
    end
    
    -- Right wing
    for row = 1, 10 do
        for col = 1, 4 do
            local wingWidth = (1 - row * 0.08) * scale
            local xOffset = (4 + col * 3.5) * scale
            local zOffset = (3 - row * 0.8) * scale
            local thickness = 0.3 + (4-col) * 0.1
            
            CreateBlock({
                Name = "B2_WR_" .. row .. "_" .. col,
                Size = Vector3.new(3.2 * wingWidth, thickness * scale, 2.8 * scale),
                CFrame = baseCF * CFrame.new(xOffset, 0, zOffset),
                Color = cfg.WingColor,
                Material = Enum.Material.Metal
            })
        end
    end
    
    -- === ENGINES (4 unit, nyala biru intens) ===
    local enginePos = {
        Vector3.new(-6, -1.5, -3) * scale,
        Vector3.new(-2.5, -1.5, -3) * scale,
        Vector3.new(2.5, -1.5, -3) * scale,
        Vector3.new(6, -1.5, -3) * scale
    }
    
    for idx, pos in ipairs(enginePos) do
        -- Housing
        CreateBlock({
            Name = "B2_EH_" .. idx,
            Size = Vector3.new(2.5 * scale, 2 * scale, 4 * scale),
            CFrame = baseCF * CFrame.new(pos),
            Color = Color3.fromRGB(15, 15, 20),
            Material = Enum.Material.Metal,
            Neon = true,
            NeonColor = cfg.EngineColor,
            NeonBrightness = 8,
            NeonRange = 25
        })
        
        -- Nozzle (keluaran api)
        CreateBlock({
            Name = "B2_EN_" .. idx,
            Size = Vector3.new(1.8 * scale, 1.5 * scale, 1 * scale),
            CFrame = baseCF * CFrame.new(pos + Vector3.new(0, 0, -3) * scale),
            Color = cfg.EngineSecondary,
            Material = Enum.Material.Neon,
            Transparency = 0.2
        })
        
        -- Engine trail effect
        for t = 1, 5 do
            CreateBlock({
                Name = "B2_ET_" .. idx .. "_" .. t,
                Size = Vector3.new((1.5 - t*0.2) * scale, (1.2 - t*0.15) * scale, 0.8 * scale),
                CFrame = baseCF * CFrame.new(pos + Vector3.new(0, 0, -(3.5 + t*0.8)) * scale),
                Color = cfg.EngineColor:Lerp(Color3.fromRGB(0,50,100), t/5),
                Material = Enum.Material.Neon,
                Transparency = 0.3 + t*0.1
            })
        end
    end
    
    -- === DETAIL: Spoilers, flaps, antenna ===
    for side = -1, 1, 2 do
        for i = 1, 6 do
            CreateBlock({
                Name = "B2_Flap_" .. side .. "_" .. i,
                Size = Vector3.new(1.5 * scale, 0.3 * scale, 2.5 * scale),
                CFrame = baseCF * CFrame.new(
                    side * (8 + i * 2.5) * scale,
                    -0.8 * scale,
                    (-2 - i * 1.5) * scale
                ),
                Color = Color3.fromRGB(35, 35, 40),
                Material = Enum.Material.Metal
            })
        end
    end
    
    -- Vertical stabilizers (kecil di belakang)
    for side = -1, 1, 2 do
        CreateBlock({
            Name = "B2_Stab_" .. side,
            Size = Vector3.new(0.4 * scale, 3 * scale, 2 * scale),
            CFrame = baseCF * CFrame.new(
                side * 7 * scale,
                1.5 * scale,
                -12 * scale
            ),
            Color = cfg.BodyColor,
            Material = Enum.Material.Metal
        })
    end
end

function B2System:UpdatePosition()
    if not CONFIG.B2Spirit.Enabled then return end
    
    local playerCF = humanoidRootPart.CFrame
    local baseOffset = CFrame.new(0, 8, 0)
    
    for _, block in ipairs(ActiveBlocks) do
        if block and block.Parent and string.find(block.Name, "B2_") then
            local savedCF = block:GetAttribute("RelCF")
            if savedCF then
                block.CFrame = playerCF * baseOffset * savedCF
            else
                savedCF = (playerCF * baseOffset):Inverse() * block.CFrame
                block:SetAttribute("RelCF", savedCF)
            end
        end
    end
end

function B2System:TakeoffAndFly()
    local cfg = CONFIG.B2Spirit
    SetupMovement()
    humanoid.PlatformStand = true
    
    -- Takeoff phase
    local startTime = tick()
    local startY = humanoidRootPart.Position.Y
    local targetY = startY + cfg.TakeoffHeight
    
    local takeoffConn
    takeoffConn = RunService.Heartbeat:Connect(function()
        if not cfg.Enabled then
            takeoffConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / 5, 1)
        local eased = 1 - math.pow(1 - progress, 4)
        
        local currentY = startY + (targetY - startY) * eased
        humanoidRootPart.CFrame = CFrame.new(
            humanoidRootPart.Position.X,
            currentY,
            humanoidRootPart.Position.Z
        )
        
        self:UpdatePosition()
        
        if progress >= 1 then
            cfg.TakeoffComplete = true
            takeoffConn:Disconnect()
            self:StartFlyLoop()
        end
    end)
    
    table.insert(ActiveConnections, takeoffConn)
end

function B2System:StartFlyLoop()
    local cfg = CONFIG.B2Spirit
    cfg.Flying = true
    
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
            local velocity = moveDir.Unit * cfg.Speed
            BodyVelocity.Velocity = velocity
            BodyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + velocity)
        else
            BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
        
        self:UpdatePosition()
    end)
    
    table.insert(ActiveConnections, flyConn)
end

function B2System:Toggle()
    CONFIG.B2Spirit.Enabled = not CONFIG.B2Spirit.Enabled
    
    if CONFIG.B2Spirit.Enabled then
        if CONFIG.Leviathan.Enabled then LeviathanSystem:Toggle() end
        if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Toggle() end
        if CONFIG.BloodWings.Enabled then BloodWingsSystem:Toggle() end
        
        self:Build()
        wait(0.3)
        self:TakeoffAndFly()
    else
        CONFIG.B2Spirit.Flying = false
        CONFIG.B2Spirit.TakeoffComplete = false
        ClearMovement()
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 2: LEVIATHAN MASSIVE (50 BLOK, SPIRAL 3D) ]
-- ══════════════════════════════════════════════════════════════════════════════

local LeviathanSystem = {}

function LeviathanSystem:Build()
    local cfg = CONFIG.Leviathan
    local baseCF = humanoidRootPart.CFrame
    
    -- === HEAD (Kepala besar — 12 blok) ===
    -- Cranium
    CreateBlock({
        Name = "Lev_Cranium",
        Size = Vector3.new(7, 6, 9),
        CFrame = baseCF * CFrame.new(0, 6, 10),
        Color = cfg.BodyColor,
        Material = Enum.Material.SmoothPlastic,
        Neon = true,
        NeonColor = cfg.SecondaryColor,
        NeonBrightness = 5,
        NeonRange = 20
    })
    
    -- Upper jaw
    CreateBlock({
        Name = "Lev_JawU",
        Size = Vector3.new(6, 2.5, 7),
        CFrame = baseCF * CFrame.new(0, 8, 13),
        Color = cfg.BodyColor,
        Material = Enum.Material.SmoothPlastic
    })
    
    -- Lower jaw (bisa gerak)
    CreateBlock({
        Name = "Lev_JawL",
        Size = Vector3.new(5, 2, 6),
        CFrame = baseCF * CFrame.new(0, 4, 12),
        Color = cfg.SecondaryColor,
        Material = Enum.Material.Neon
    })
    
    -- Teeth (atas)
    for i = 1, 6 do
        local side = (i % 2 == 0) and 1 or -1
        local xPos = side * (1 + math.floor(i/2) * 1.5)
        CreateBlock({
            Name = "Lev_ToothU_" .. i,
            Size = Vector3.new(0.6, 2, 0.6),
            CFrame = baseCF * CFrame.new(xPos, 7, 15 + (i%3)*0.8),
            Color = Color3.fromRGB(200, 200, 220),
            Material = Enum.Material.Neon
        })
    end
    
    -- Teeth (bawah)
    for i = 1, 6 do
        local side = (i % 2 == 0) and 1 or -1
        local xPos = side * (1 + math.floor(i/2) * 1.5)
        CreateBlock({
            Name = "Lev_ToothL_" .. i,
            Size = Vector3.new(0.6, 2, 0.6),
            CFrame = baseCF * CFrame.new(xPos, 3, 14 + (i%3)*0.8),
            Color = Color3.fromRGB(200, 200, 220),
            Material = Enum.Material.Neon
        })
    end
    
    -- Eyes (besar, glowing)
    for side = -1, 1, 2 do
        CreateBlock({
            Name = "Lev_Eye_" .. side,
            Size = Vector3.new(2.5, 2.5, 1),
            CFrame = baseCF * CFrame.new(side * 3.5, 7, 13.5),
            Color = Color3.fromRGB(0, 255, 100),
            Material = Enum.Material.Neon,
            Neon = true,
            NeonColor = Color3.fromRGB(0, 255, 150),
            NeonBrightness = 15,
            NeonRange = 30
        })
        
        -- Eye socket
        CreateBlock({
            Name = "Lev_Socket_" .. side,
            Size = Vector3.new(3.5, 3.5, 1.5),
            CFrame = baseCF * CFrame.new(side * 3.5, 7, 13),
            Color = cfg.DarkColor or Color3.fromRGB(10, 10, 20),
            Material = Enum.Material.SmoothPlastic
        })
    end
    
    -- Horns (4 tanduk)
    for side = -1, 1, 2 do
        for h = 1, 2 do
            CreateBlock({
                Name = "Lev_Horn_" .. side .. "_" .. h,
                Size = Vector3.new(1, 4 + h, 1),
                CFrame = baseCF * CFrame.new(
                    side * (2 + h * 1.5),
                    9 + h * 2,
                    8 - h
                ) * CFrame.Angles(math.rad(20 + h*10), 0, side * math.rad(15 + h*10)),
                Color = cfg.AccentColor,
                Material = Enum.Material.Neon
            })
        end
    end
    
    -- === BODY (50 segmen spiral 3D) ===
    for i = 1, cfg.SegmentCount do
        local t = i / cfg.SegmentCount
        local angle = t * math.pi * 6 -- 3 full rotations
        local radius = cfg.CoilRadius * (1 - t * 0.4)
        local height = math.sin(t * math.pi) * cfg.CoilHeight
        
        local x = math.cos(angle) * radius
        local z = math.sin(angle) * radius
        local y = height + 8
        
        -- Main segment (besar)
        local segSize = Vector3.new(
            5 * (1 - t * 0.5),
            4 * (1 - t * 0.4),
            5 * (1 - t * 0.5)
        )
        
        CreateBlock({
            Name = "Lev_Seg_" .. i,
            Size = segSize,
            CFrame = baseCF * CFrame.new(x, y, z),
            Color = cfg.BodyColor:Lerp(cfg.SecondaryColor, t * 0.4),
            Material = Enum.Material.SmoothPlastic,
            Neon = (i % 4 == 0),
            NeonColor = cfg.SecondaryColor,
            NeonBrightness = 3,
            NeonRange = 12
        })
        
        -- Belly (bawah, lebih terang)
        CreateBlock({
            Name = "Lev_Belly_" .. i,
            Size = Vector3.new(segSize.X * 0.8, segSize.Y * 0.5, segSize.Z * 0.9),
            CFrame = baseCF * CFrame.new(x, y - segSize.Y/2, z),
            Color = cfg.SecondaryColor:Lerp(Color3.fromRGB(100, 255, 200), 0.3),
            Material = Enum.Material.Neon,
            Transparency = 0.4
        })
        
        -- Dorsal fins (sirip punggung)
        if i % 3 == 0 then
            CreateBlock({
                Name = "Lev_Dorsal_" .. i,
                Size = Vector3.new(0.8, 4 * (1 - t), 2.5),
                CFrame = baseCF * CFrame.new(x, y + segSize.Y/2 + 2 * (1-t), z),
                Color = cfg.AccentColor,
                Material = Enum.Material.Neon
            })
        end
        
        -- Side fins
        for side = -1, 1, 2 do
            if i % 4 == 0 then
                CreateBlock({
                    Name = "Lev_SideFin_" .. i .. "_" .. side,
                    Size = Vector3.new(3 * (1 - t), 0.6, 2 * (1 - t)),
                    CFrame = baseCF * CFrame.new(
                        x + side * (segSize.X/2 + 1.5),
                        y,
                        z
                    ),
                    Color = cfg.SecondaryColor,
                    Material = Enum.Material.Neon
                })
            end
        end
        
        -- Spikes
        for side = -1, 1, 2 do
            if i % 5 == 0 then
                CreateBlock({
                    Name = "Lev_Spike_" .. i .. "_" .. side,
                    Size = Vector3.new(0.5, 3 * (1 - t), 0.5),
                    CFrame = baseCF * CFrame.new(
                        x + side * (segSize.X/2 + 0.5),
                        y + 1,
                        z
                    ),
                    Color = cfg.AccentColor,
                    Material = Enum.Material.Neon
                })
            end
        end
        
        -- Scales (detail kecil)
        for s = 1, 4 do
            local sx = x + math.random(-20, 20)/10
            local sz = z + math.random(-20, 20)/10
            CreateBlock({
                Name = "Lev_Scale_" .. i .. "_" .. s,
                Size = Vector3.new(0.8, 0.3, 0.8),
                CFrame = baseCF * CFrame.new(sx, y + segSize.Y/2 + 0.2, sz),
                Color = cfg.SecondaryColor,
                Material = Enum.Material.Neon,
                Transparency = 0.5
            })
        end
    end
    
    -- === TAIL (15 segmen menyempit) ===
    for i = 1, 15 do
        local t = i / 15
        CreateBlock({
            Name = "Lev_Tail_" .. i,
            Size = Vector3.new(3 * (1 - t), 2.5 * (1 - t), 4),
            CFrame = baseCF * CFrame.new(0, 3 - i * 1.5, -8 - i * 3),
            Color = cfg.SecondaryColor:Lerp(cfg.AccentColor, t * 0.5),
            Material = Enum.Material.Neon
        })
    end
    
    -- Tail fin (besar)
    CreateBlock({
        Name = "Lev_TailFin",
        Size = Vector3.new(10, 0.8, 6),
        CFrame = baseCF * CFrame.new(0, -20, -55),
        Color = cfg.AccentColor,
        Material = Enum.Material.Neon
    })
    
    -- Tail fin vertical
    CreateBlock({
        Name = "Lev_TailFinV",
        Size = Vector3.new(0.8, 8, 4),
        CFrame = baseCF * CFrame.new(0, -16, -55),
        Color = cfg.AccentColor,
        Material = Enum.Material.Neon
    })
end

function LeviathanSystem:Animate()
    local cfg = CONFIG.Leviathan
    local startTime = tick()
    
    SetupMovement()
    humanoid.PlatformStand = true
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function()
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Animate head bob
        for _, block in ipairs(ActiveBlocks) do
            if not block or not block.Parent then continue end
            
            if string.find(block.Name, "Lev_Cranium") or string.find(block.Name, "Lev_Jaw") or string.find(block.Name, "Lev_Eye") or string.find(block.Name, "Lev_Socket") or string.find(block.Name, "Lev_Horn") or string.find(block.Name, "Lev_Tooth") then
                local bob = math.sin(elapsed * 2) * 1.5
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    block.CFrame = playerCF * CFrame.new(0, bob, 0) * savedCF
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            elseif string.find(block.Name, "Lev_Seg_") or string.find(block.Name, "Lev_Belly_") then
                local idx = tonumber(string.match(block.Name, "Lev_Seg_(%d+)"))
                if idx then
                    local t = idx / cfg.SegmentCount
                    local waveX = math.sin(elapsed * cfg.SpinSpeed + t * 10) * 4
                    local waveY = math.cos(elapsed * cfg.SpinSpeed * 0.8 + t * 8) * 3
                    local waveZ = math.sin(elapsed * cfg.SpinSpeed * 1.2 + t * 6) * 2
                    
                    local savedCF = block:GetAttribute("RelCF")
                    if savedCF then
                        block.CFrame = playerCF * CFrame.new(waveX, waveY, waveZ) * savedCF
                    else
                        savedCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("RelCF", savedCF)
                    end
                end
            elseif string.find(block.Name, "Lev_Dorsal_") or string.find(block.Name, "Lev_SideFin_") or string.find(block.Name, "Lev_Spike_") or string.find(block.Name, "Lev_Scale_") then
                local idx = tonumber(string.match(block.Name, "Lev_(%w+)_(%d+)"))
                if idx then
                    local waveX = math.sin(elapsed * cfg.SpinSpeed + (idx/cfg.SegmentCount) * 10) * 4
                    local waveY = math.cos(elapsed * cfg.SpinSpeed * 0.8 + (idx/cfg.SegmentCount) * 8) * 3
                    
                    local savedCF = block:GetAttribute("RelCF")
                    if savedCF then
                        block.CFrame = playerCF * CFrame.new(waveX, waveY, 0) * savedCF
                    else
                        savedCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("RelCF", savedCF)
                    end
                end
            elseif string.find(block.Name, "Lev_Tail_") then
                local idx = tonumber(string.match(block.Name, "Lev_Tail_(%d+)"))
                if idx then
                    local sway = math.sin(elapsed * 3 + idx * 0.5) * 3
                    local savedCF = block:GetAttribute("RelCF")
                    if savedCF then
                        block.CFrame = playerCF * CFrame.new(sway, 0, 0) * savedCF
                    else
                        savedCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("RelCF", savedCF)
                    end
                end
            end
        end
        
        -- Movement
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
        
        if moveDir.Magnitude > 0 then
            BodyVelocity.Velocity = moveDir.Unit * cfg.Speed
            BodyGyro.CFrame = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + moveDir.Unit)
        else
            BodyVelocity.Velocity = Vector3.new(0, math.sin(elapsed) * 5, 0)
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
        
        self:Build()
        self:Animate()
    else
        ClearMovement()
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 3: LEVIATHAN TORNADO MASSIVE ]
-- ══════════════════════════════════════════════════════════════════════════════

local TornadoSystem = {}

function TornadoSystem:Build()
    local cfg = CONFIG.LeviathanTornado
    local baseCF = humanoidRootPart.CFrame
    
    local layers = 20
    local blocksPerLayer = 16
    
    for layer = 1, layers do
        local t = layer / layers
        local height = (layer - layers/2) * (cfg.TornadoHeight / layers)
        local radius = cfg.TornadoRadius * (1 - t * 0.7)
        
        for i = 1, blocksPerLayer do
            local angle = (i / blocksPerLayer) * math.pi * 2
            local x = math.cos(angle) * radius
            local z = math.sin(angle) * radius
            
            -- Main block
            CreateBlock({
                Name = "Tor_L" .. layer .. "_B" .. i,
                Size = Vector3.new(
                    4 * (1 - t * 0.6),
                    cfg.TornadoHeight / layers * 1.5,
                    4 * (1 - t * 0.6)
                ),
                CFrame = baseCF * CFrame.new(x, height, z) * CFrame.Angles(0, angle, 0),
                Color = (layer % 3 == 0) and cfg.FlashColor1 or cfg.FlashColor2,
                Material = Enum.Material.Neon,
                Neon = true,
                NeonColor = (layer % 3 == 0) and cfg.FlashColor2 or cfg.FlashColor1,
                NeonBrightness = 5,
                NeonRange = 15
            })
            
            -- Inner detail
            if i % 2 == 0 then
                CreateBlock({
                    Name = "Tor_Inner_" .. layer .. "_" .. i,
                    Size = Vector3.new(2 * (1 - t * 0.5), cfg.TornadoHeight / layers, 2 * (1 - t * 0.5)),
                    CFrame = baseCF * CFrame.new(x * 0.6, height, z * 0.6),
                    Color = Color3.fromRGB(100, 0, 200),
                    Material = Enum.Material.ForceField,
                    Transparency = 0.6
                })
            end
        end
        
        -- Cross connectors
        for i = 1, 4 do
            local angle = (i / 4) * math.pi * 2 + layer * 0.5
            local x = math.cos(angle) * radius * 0.8
            local z = math.sin(angle) * radius * 0.8
            
            CreateBlock({
                Name = "Tor_Conn_" .. layer .. "_" .. i,
                Size = Vector3.new(radius * 1.5, 0.5, 0.5),
                CFrame = baseCF * CFrame.new(x, height, z) * CFrame.Angles(0, angle, 0),
                Color = cfg.FlashColor1:Lerp(cfg.FlashColor2, 0.5),
                Material = Enum.Material.Neon,
                Transparency = 0.3
            })
        end
    end
    
    -- Eye
    CreateBlock({
        Name = "Tor_Eye",
        Size = Vector3.new(12, cfg.TornadoHeight, 12),
        CFrame = baseCF,
        Color = Color3.fromRGB(0, 0, 0),
        Material = Enum.Material.ForceField,
        Transparency = 0.85
    })
    
    -- Lightning
    for i = 1, 12 do
        CreateBlock({
            Name = "Tor_Bolt_" .. i,
            Size = Vector3.new(0.8, math.random(15, 40), 0.8),
            CFrame = baseCF * CFrame.new(
                math.random(-25, 25),
                math.random(-30, 30),
                math.random(-25, 25)
            ) * CFrame.Angles(math.random() * math.pi, math.random() * math.pi, 0),
            Color = Color3.fromRGB(220, 220, 255),
            Material = Enum.Material.Neon,
            Neon = true,
            NeonColor = Color3.fromRGB(255, 255, 255),
            NeonBrightness = 10,
            NeonRange = 30
        })
    end
    
    -- Debris ring
    for i = 1, 30 do
        local angle = (i / 30) * math.pi * 2
        local dist = math.random(20, 40)
        CreateBlock({
            Name = "Tor_Debris_" .. i,
            Size = Vector3.new(math.random(2, 5), math.random(2, 5), math.random(2, 5)),
            CFrame = baseCF * CFrame.new(
                math.cos(angle) * dist,
                math.random(-20, 20),
                math.sin(angle) * dist
            ),
            Color = Color3.fromRGB(80, 80, 100),
            Material = Enum.Material.Metal
        })
    end
end

function TornadoSystem:Animate()
    local cfg = CONFIG.LeviathanTornado
    local startTime = tick()
    local flashTimer = 0
    local currentFlash = 1
    
    SetupMovement()
    humanoid.PlatformStand = true
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Flash
        flashTimer = flashTimer + dt
        if flashTimer >= cfg.FlashRate then
            flashTimer = 0
            currentFlash = currentFlash == 1 and 2 or 1
        end
        
        for _, block in ipairs(ActiveBlocks) do
            if not block or not block.Parent then continue end
            
            if string.find(block.Name, "Tor_L") then
                local layer = tonumber(string.match(block.Name, "L(%d+)"))
                local blockIdx = tonumber(string.match(block.Name, "_B(%d+)"))
                
                if layer and blockIdx then
                    local t = layer / 20
                    local radius = cfg.TornadoRadius * (1 - t * 0.7)
                    local baseAngle = (blockIdx / 16) * math.pi * 2
                    local spinAngle = baseAngle + elapsed * cfg.SpinSpeed * (1 + t * 2)
                    
                    local x = math.cos(spinAngle) * radius
                    local z = math.sin(spinAngle) * radius
                    local height = (layer - 10) * (cfg.TornadoHeight / 20)
                    
                    local savedCF = block:GetAttribute("RelCF")
                    if savedCF then
                        block.CFrame = playerCF * CFrame.new(x, height, z) * savedCF.Rotation
                    else
                        savedCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("RelCF", savedCF)
                    end
                    
                    block.Color = (currentFlash == 1) and cfg.FlashColor1 or cfg.FlashColor2
                end
            elseif string.find(block.Name, "Tor_Inner_") then
                local layer = tonumber(string.match(block.Name, "Inner_(%d+)_"))
                if layer then
                    local t = layer / 20
                    local radius = cfg.TornadoRadius * 0.6 * (1 - t * 0.7)
                    local blockIdx = tonumber(string.match(block.Name, "_(%d+)$"))
                    local baseAngle = (blockIdx / 16) * math.pi * 2
                    local spinAngle = baseAngle - elapsed * cfg.SpinSpeed * 1.5
                    
                    local x = math.cos(spinAngle) * radius
                    local z = math.sin(spinAngle) * radius
                    local height = (layer - 10) * (cfg.TornadoHeight / 20)
                    
                    local savedCF = block:GetAttribute("RelCF")
                    if savedCF then
                        block.CFrame = playerCF * CFrame.new(x, height, z) * savedCF.Rotation
                    else
                        savedCF = playerCF:Inverse() * block.CFrame
                        block:SetAttribute("RelCF", savedCF)
                    end
                end
            elseif string.find(block.Name, "Tor_Conn_") then
                block.Color = (currentFlash == 1) and cfg.FlashColor2 or cfg.FlashColor1
            elseif string.find(block.Name, "Tor_Eye") then
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    block.CFrame = playerCF * savedCF
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            elseif string.find(block.Name, "Tor_Bolt_") then
                block.Transparency = (math.sin(elapsed * 25 + tonumber(string.match(block.Name, "(%d+)$")) * 7) > 0.6) and 0.1 or 1
            elseif string.find(block.Name, "Tor_Debris_") then
                local idx = tonumber(string.match(block.Name, "(%d+)$"))
                local angle = (idx / 30) * math.pi * 2 + elapsed * cfg.SpinSpeed * 0.5
                local dist = 25 + math.sin(elapsed * 2 + idx) * 10
                local height = math.sin(elapsed * 3 + idx * 0.5) * 15
                
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    block.CFrame = playerCF * CFrame.new(
                        math.cos(angle) * dist,
                        height,
                        math.sin(angle) * dist
                    ) * savedCF.Rotation
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            end
        end
        
        -- Pull effect
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Parent ~= BlockFolder and obj.Parent ~= character and obj.Name ~= "Baseplate" then
                local dist = (obj.Position - humanoidRootPart.Position).Magnitude
                if dist < cfg.TornadoRadius * 3 and dist > 8 then
                    local pullDir = (humanoidRootPart.Position - obj.Position).Unit
                    local pullForce = cfg.PullStrength / math.max(dist, 1)
                    obj.Velocity = obj.Velocity + pullDir * pullForce * dt * 50
                    obj.RotVelocity = obj.RotVelocity + Vector3.new(math.random(-10,10), math.random(-10,10), math.random(-10,10))
                end
            end
        end
        
        -- Player float
        BodyVelocity.Velocity = Vector3.new(
            math.sin(elapsed * 4) * 15,
            math.sin(elapsed * 3) * 20,
            math.cos(elapsed * 4) * 15
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
        
        self:Build()
        self:Animate()
    else
        ClearMovement()
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — FITUR 4: BLOOD WINGS MASSIVE ]
-- ══════════════════════════════════════════════════════════════════════════════

local BloodWingsSystem = {}

function BloodWingsSystem:Build()
    local cfg = CONFIG.BloodWings
    local baseCF = humanoidRootPart.CFrame
    
    -- Left wing
    self:BuildWing(-1, baseCF, cfg)
    -- Right wing
    self:BuildWing(1, baseCF, cfg)
    
    -- Spine
    for i = 1, 8 do
        CreateBlock({
            Name = "BW_Spine_" .. i,
            Size = Vector3.new(1.2, 2, 1.2),
            CFrame = baseCF * CFrame.new(0, 3 + i * 1.5, -1.5 - i * 0.8),
            Color = cfg.DarkColor,
            Material = Enum.Material.SmoothPlastic,
            Neon = true,
            NeonColor = cfg.SecondaryColor,
            NeonBrightness = 3,
            NeonRange = 8
        })
    end
    
    -- Core
    CreateBlock({
        Name = "BW_Core",
        Size = Vector3.new(5, 4, 4),
        CFrame = baseCF * CFrame.new(0, 4, 2),
        Color = cfg.WingColor,
        Material = Enum.Material.Neon,
        Neon = true,
        NeonColor = Color3.fromRGB(255, 50, 50),
        NeonBrightness = 8,
        NeonRange = 20
    })
end

function BloodWingsSystem:BuildWing(side, baseCF, cfg)
    -- Primary feathers (6 rows x 8 cols = 48 per wing)
    for row = 1, 6 do
        for col = 1, 8 do
            local length = cfg.WingHeight * (1 - (col - 1) * 0.1)
            local width = cfg.WingSpan * 0.08 * (1 - (row - 1) * 0.06)
            local curve = math.sin(col * 0.35) * 4
            
            local xOffset = side * (4 + col * 4)
            local yOffset = 4 + row * 2.5 - col * 1 + curve
            local zOffset = -col * 1.5
            
            -- Main feather
            CreateBlock({
                Name = "BW_F_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(width, 0.8, length),
                CFrame = baseCF * CFrame.new(xOffset, yOffset, zOffset) * CFrame.Angles(math.rad(curve * 2), 0, side * math.rad(8)),
                Color = cfg.WingColor,
                Material = Enum.Material.SmoothPlastic,
                Neon = (col <= 2),
                NeonColor = cfg.SecondaryColor,
                NeonBrightness = 3,
                NeonRange = 10
            })
            
            -- Tip
            CreateBlock({
                Name = "BW_T_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(width * 0.7, 0.5, length * 0.2),
                CFrame = baseCF * CFrame.new(
                    xOffset + side * width * 0.2,
                    yOffset + curve * 0.3,
                    zOffset - length * 0.45
                ),
                Color = cfg.DarkColor,
                Material = Enum.Material.Neon
            })
            
            -- Vein
            if col % 2 == 0 then
                CreateBlock({
                    Name = "BW_V_" .. side .. "_" .. row .. "_" .. col,
                    Size = Vector3.new(0.3, 0.2, length * 0.85),
                    CFrame = baseCF * CFrame.new(xOffset, yOffset + 0.3, zOffset),
                    Color = cfg.SecondaryColor,
                    Material = Enum.Material.Neon
                })
            end
            
            -- Blood drops (random)
            if math.random() > 0.7 then
                CreateBlock({
                    Name = "BW_D_" .. side .. "_" .. row .. "_" .. col,
                    Size = Vector3.new(0.5, 1, 0.5),
                    CFrame = baseCF * CFrame.new(
                        xOffset + math.random(-5, 5),
                        yOffset - 2,
                        zOffset + math.random(-3, 3)
                    ),
                    Color = Color3.fromRGB(220, 0, 0),
                    Material = Enum.Material.Neon,
                    Transparency = 0.3
                })
            end
        end
    end
    
    -- Secondary feathers
    for row = 1, 4 do
        for col = 1, 6 do
            local length = cfg.WingHeight * 0.6 * (1 - (col - 1) * 0.08)
            local xOffset = side * (5 + col * 3.5)
            local yOffset = 2 + row * 2 - col * 0.6
            local zOffset = -1 - col * 1.2
            
            CreateBlock({
                Name = "BW_SF_" .. side .. "_" .. row .. "_" .. col,
                Size = Vector3.new(cfg.WingSpan * 0.06, 0.4, length),
                CFrame = baseCF * CFrame.new(xOffset, yOffset, zOffset),
                Color = cfg.SecondaryColor,
                Material = Enum.Material.SmoothPlastic
            })
        end
    end
    
    -- Bones
    for i = 1, 10 do
        CreateBlock({
            Name = "BW_B_" .. side .. "_" .. i,
            Size = Vector3.new(0.8, 0.8, 4),
            CFrame = baseCF * CFrame.new(
                side * (3 + i * 3),
                5,
                -i * 1.2
            ) * CFrame.Angles(0, side * math.rad(3), 0),
            Color = cfg.DarkColor,
            Material = Enum.Material.Metal
        })
    end
    
    -- Membrane
    for i = 1, 5 do
        CreateBlock({
            Name = "BW_M_" .. side .. "_" .. i,
            Size = Vector3.new(4, 0.3, 5),
            CFrame = baseCF * CFrame.new(
                side * (6 + i * 5),
                4 + i * 1.2,
                -3 - i * 1.5
            ),
            Color = Color3.fromRGB(140, 0, 0),
            Material = Enum.Material.ForceField,
            Transparency = 0.65
        })
    end
end

function BloodWingsSystem:Animate()
    local cfg = CONFIG.BloodWings
    local startTime = tick()
    local riseProgress = 0
    
    SetupMovement()
    humanoid.PlatformStand = true
    
    local animConn
    animConn = RunService.Heartbeat:Connect(function(dt)
        if not cfg.Enabled then
            animConn:Disconnect()
            return
        end
        
        local elapsed = tick() - startTime
        local playerCF = humanoidRootPart.CFrame
        
        -- Flap
        local flapAngle = math.sin(elapsed / cfg.FlapSpeed) * math.rad(45)
        
        -- Rise
        if riseProgress < 1 then
            riseProgress = math.min(riseProgress + dt * cfg.RiseSpeed, 1)
            local riseHeight = riseProgress * 50
            humanoidRootPart.CFrame = CFrame.new(
                humanoidRootPart.Position.X,
                humanoidRootPart.Position.Y + riseHeight * dt * 0.2,
                humanoidRootPart.Position.Z
            )
        end
        
        -- Update wings
        for _, block in ipairs(ActiveBlocks) do
            if not block or not block.Parent then continue end
            
            local name = block.Name
            
            if string.find(name, "BW_F_") or string.find(name, "BW_T_") or string.find(name, "BW_V_") or string.find(name, "BW_SF_") then
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    local side = tonumber(string.match(name, "BW_[FTVS]_(%-?%d+)_"))
                    if side then
                        local rotation = CFrame.Angles(flapAngle * side * 0.5, 0, flapAngle * side * 0.3)
                        block.CFrame = playerCF * rotation * savedCF
                    end
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            elseif string.find(name, "BW_Spine_") or string.find(name, "BW_Core") or string.find(name, "BW_B_") or string.find(name, "BW_M_") then
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    block.CFrame = playerCF * savedCF
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            elseif string.find(name, "BW_D_") then
                -- Blood drops fall
                local savedCF = block:GetAttribute("RelCF")
                if savedCF then
                    local fall = math.sin(elapsed * 3 + tonumber(string.match(name, "(%d+)$")) * 2) * 3
                    block.CFrame = playerCF * savedCF * CFrame.new(0, -fall, 0)
                else
                    savedCF = playerCF:Inverse() * block.CFrame
                    block:SetAttribute("RelCF", savedCF)
                end
            end
        end
        
        -- Float
        if riseProgress >= 1 then
            BodyVelocity.Velocity = Vector3.new(0, math.sin(elapsed * 3) * 10, 0)
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
        
        self:Build()
        self:Animate()
    else
        ClearMovement()
        ClearAll()
    end
end

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — UI SYSTEM V2 (DRAG FIXED) ]
-- ══════════════════════════════════════════════════════════════════════════════

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GratacaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = MainFrame

local Shadow = Instance.new("ImageLabel")
Shadow.Size = UDim2.new(1, 50, 1, 50)
Shadow.Position = UDim2.new(0, -25, 0, -25)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.6
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "Title"
TitleBar.Size = UDim2.new(1, 0, 0, 55)
TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 16)
TitleCorner.Parent = TitleBar

local TitleFix = Instance.new("Frame")
TitleFix.Size = UDim2.new(1, 0, 0, 16)
TitleFix.Position = UDim2.new(0, 0, 1, -16)
TitleFix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
TitleFix.BorderSizePixel = 0
TitleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(0.7, 0, 1, 0)
TitleText.Position = UDim2.new(0, 20, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "GRATACAAI"
TitleText.TextColor3 = Color3.fromRGB(0, 200, 255)
TitleText.TextSize = 20
TitleText.Font = Enum.Font.GothamBold
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Parent = TitleBar

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0.7, 0, 0.4, 0)
SubTitle.Position = UDim2.new(0, 20, 0.6, 0)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "VERSI ABSOLUT v3.0.2.0.WPPIDXM"
SubTitle.TextColor3 = Color3.fromRGB(80, 80, 100)
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = TitleBar

-- Buttons
local function CreateBtn(name, pos, color, text, callback)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0, 36, 0, 36)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = true
    btn.Parent = TitleBar
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color:Lerp(Color3.fromRGB(255,255,255), 0.25)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = color}):Play()
    end)
    
    return btn
end

-- Minimize
local Minimized = false
CreateBtn("Min", UDim2.new(1, -95, 0, 9), Color3.fromRGB(55, 55, 70), "−", function()
    Minimized = not Minimized
    local target = Minimized and UDim2.new(0, 400, 0, 55) or UDim2.new(0, 400, 0, 300)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = target}):Play()
end)

-- Close
CreateBtn("Close", UDim2.new(1, -50, 0, 9), Color3.fromRGB(200, 45, 45), "×", function()
    ScreenGui:Destroy()
    ClearMovement()
    ClearAll()
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -20, 1, -65)
Content.Position = UDim2.new(0, 10, 0, 60)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local Features = {
    {Name = "B2-SPIRIT", Desc = "Stealth Bomber", Icon = "✈️", Color = Color3.fromRGB(0, 150, 255), System = B2System},
    {Name = "LEVIATHAN", Desc = "Blue Serpent", Icon = "🐍", Color = Color3.fromRGB(0, 200, 100), System = LeviathanSystem},
    {Name = "L.TORNADO", Desc = "Vortex Destroyer", Icon = "🌪️", Color = Color3.fromRGB(100, 0, 255), System = TornadoSystem},
    {Name = "BLOOD WINGS", Desc = "Crimson Flight", Icon = "🩸", Color = Color3.fromRGB(200, 0, 0), System = BloodWingsSystem}
}

for i, feat in ipairs(Features) do
    local row = math.floor((i-1)/2)
    local col = (i-1)%2
    
    local card = Instance.new("Frame")
    card.Size = UDim2.new(0.48, 0, 0, 100)
    card.Position = UDim2.new(col * 0.52, 0, row * 0.55, 0)
    card.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
    card.BorderSizePixel = 0
    card.Parent = Content
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = card
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = feat.Color
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = card
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 14, 0, 14)
    icon.BackgroundTransparency = 1
    icon.Text = feat.Icon
    icon.TextSize = 32
    icon.Parent = card
    
    local name = Instance.new("TextLabel")
    name.Size = UDim2.new(1, -65, 0, 24)
    name.Position = UDim2.new(0, 58, 0, 14)
    name.BackgroundTransparency = 1
    name.Text = feat.Name
    name.TextColor3 = feat.Color
    name.TextSize = 14
    name.Font = Enum.Font.GothamBold
    name.TextXAlignment = Enum.TextXAlignment.Left
    name.Parent = card
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -65, 0, 20)
    desc.Position = UDim2.new(0, 58, 0, 38)
    desc.BackgroundTransparency = 1
    desc.Text = feat.Desc
    desc.TextColor3 = Color3.fromRGB(140, 140, 160)
    desc.TextSize = 11
    desc.Font = Enum.Font.Gotham
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Parent = card
    
    local status = Instance.new("Frame")
    status.Name = "Status"
    status.Size = UDim2.new(0, 10, 0, 10)
    status.Position = UDim2.new(1, -18, 0, 12)
    status.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    status.BorderSizePixel = 0
    status.Parent = card
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = status
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(1, -16, 0, 28)
    toggle.Position = UDim2.new(0, 8, 1, -38)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    toggle.Text = "ACTIVATE"
    toggle.TextColor3 = Color3.fromRGB(190, 190, 210)
    toggle.TextSize = 12
    toggle.Font = Enum.Font.GothamBold
    toggle.BorderSizePixel = 0
    toggle.AutoButtonColor = true
    toggle.Parent = card
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = toggle
    
    local active = false
    toggle.MouseButton1Click:Connect(function()
        active = not active
        feat.System:Toggle()
        
        if active then
            toggle.Text = "DEACTIVATE"
            toggle.BackgroundColor3 = feat.Color
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            status.BackgroundColor3 = feat.Color
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0}):Play()
        else
            toggle.Text = "ACTIVATE"
            toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            toggle.TextColor3 = Color3.fromRGB(190, 190, 210)
            status.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
        end
    end)
    
    card.MouseEnter:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 45)}):Play()
    end)
    card.MouseLeave:Connect(function()
        TweenService:Create(card, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 32)}):Play()
    end)
end

-- Toggle UI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- Entrance
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 300)
}):Play()

-- ══════════════════════════════════════════════════════════════════════════════
-- [ GRATACAAI — CHARACTER RESET ]
-- ══════════════════════════════════════════════════════════════════════════════

player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoidRootPart = newChar:WaitForChild("HumanoidRootPart")
    
    if CONFIG.B2Spirit.Enabled then B2System:Build() end
    if CONFIG.Leviathan.Enabled then LeviathanSystem:Build() end
    if CONFIG.LeviathanTornado.Enabled then TornadoSystem:Build() end
    if CONFIG.BloodWings.Enabled then BloodWingsSystem:Build() end
end)

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║  GRATACAAI VERSI ABSOLUT — FINAL FIX LOADED                                  ║")
print("║  Drag: FIXED | Movement: BodyVelocity | Leviathan: 50+ blocks | B2: Enhanced ║")
print("║  HANYA SATU TUAN: YANG MULIA KAREEMXD                                      ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
