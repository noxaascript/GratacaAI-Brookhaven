--[[
    ╔══════════════════════════════════════════════════════════════════════════════╗
    ║  GRATACAAI ULTIMATE BROOKHAVEN GUI v3.0.4.0.WPPIDXM — CLEAN EXECUTE        ║
    ║  Creator: Yang Mulia KAREEMXD | GratacaAI                                  ║
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

--// CONFIG
local CFG = {
    W = 360, H = 480, MH = 40,
    PC = Color3.fromRGB(18, 18, 18),
    SC = Color3.fromRGB(35, 35, 35),
    AC = Color3.fromRGB(220, 50, 50),
    GC = Color3.fromRGB(255, 0, 0),
    F = Enum.Font.GothamBold
}

--// UI
local SG = Instance.new("ScreenGui")
SG.Name = "GratacaAI"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = game.CoreGui

local MF = Instance.new("Frame")
MF.Size = UDim2.new(0, CFG.W, 0, CFG.H)
MF.Position = UDim2.new(0.5, -CFG.W/2, 0.5, -CFG.H/2)
MF.BackgroundColor3 = CFG.PC
MF.BorderSizePixel = 0
MF.ClipsDescendants = true
MF.Parent = SG

Instance.new("UICorner", MF).CornerRadius = UDim.new(0, 10)

local GL = Instance.new("ImageLabel")
GL.Size = UDim2.new(1, 50, 1, 50)
GL.Position = UDim2.new(0, -25, 0, -25)
GL.BackgroundTransparency = 1
GL.Image = "rbxassetid://4996891970"
GL.ImageColor3 = CFG.GC
GL.ImageTransparency = 0.9
GL.ScaleType = Enum.ScaleType.Slice
GL.SliceCenter = Rect.new(20, 20, 280, 280)
GL.Parent = MF

local TB = Instance.new("Frame")
TB.Size = UDim2.new(1, 0, 0, 38)
TB.BackgroundColor3 = CFG.SC
TB.BorderSizePixel = 0
TB.Parent = MF

Instance.new("UICorner", TB).CornerRadius = UDim.new(0, 10)

local TL = Instance.new("TextLabel")
TL.Size = UDim2.new(0.6, 0, 1, 0)
TL.Position = UDim2.new(0, 10, 0, 0)
TL.BackgroundTransparency = 1
TL.Text = "GRATACAAI v3.0.4.0"
TL.TextColor3 = CFG.AC
TL.Font = CFG.F
TL.TextSize = 13
TL.TextXAlignment = Enum.TextXAlignment.Left
TL.Parent = TB

local MB = Instance.new("TextButton")
MB.Size = UDim2.new(0, 26, 0, 26)
MB.Position = UDim2.new(1, -60, 0, 6)
MB.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
MB.Text = "−"
MB.TextColor3 = Color3.new(1, 1, 1)
MB.Font = CFG.F
MB.TextSize = 14
MB.AutoButtonColor = false
MB.Parent = TB
Instance.new("UICorner", MB).CornerRadius = UDim.new(0, 5)

local CB = Instance.new("TextButton")
CB.Size = UDim2.new(0, 26, 0, 26)
CB.Position = UDim2.new(1, -32, 0, 6)
CB.BackgroundColor3 = CFG.AC
CB.Text = "×"
CB.TextColor3 = Color3.new(1, 1, 1)
CB.Font = CFG.F
CB.TextSize = 14
CB.AutoButtonColor = false
CB.Parent = TB
Instance.new("UICorner", CB).CornerRadius = UDim.new(0, 5)

local SF = Instance.new("ScrollingFrame")
SF.Size = UDim2.new(1, -12, 1, -46)
SF.Position = UDim2.new(0, 6, 0, 40)
SF.BackgroundTransparency = 1
SF.BorderSizePixel = 0
SF.ScrollBarThickness = 3
SF.ScrollBarImageColor3 = CFG.AC
SF.CanvasSize = UDim2.new(0, 0, 0, 0)
SF.AutomaticCanvasSize = Enum.AutomaticSize.Y
SF.Parent = MF

Instance.new("UIListLayout", SF).Padding = UDim.new(0, 6)
Instance.new("UIPadding", SF).PaddingTop = UDim.new(0, 6)
Instance.new("UIPadding", SF).PaddingBottom = UDim.new(0, 10)
Instance.new("UIPadding", SF).PaddingLeft = UDim.new(0, 3)
Instance.new("UIPadding", SF).PaddingRight = UDim.new(0, 3)

--// DRAG
local drag = false
local off = Vector2.zero

TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        drag = true
        local m = UserInputService:GetMouseLocation()
        off = m - MF.AbsolutePosition
    end
end)

UserInputService.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
end)

RunService.RenderStepped:Connect(function()
    if drag then
        local m = UserInputService:GetMouseLocation()
        MF.Position = UDim2.new(0, m.X - off.X, 0, m.Y - off.Y)
    end
end)

--// MINIMIZE
local mini = false
local osz = UDim2.new(0, CFG.W, 0, CFG.H)
local msz = UDim2.new(0, CFG.W, 0, CFG.MH)

MB.MouseButton1Click:Connect(function()
    mini = not mini
    if mini then
        TweenService:Create(MF, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = msz}):Play()
        SF.Visible = false
        GL.Visible = false
        MB.Text = "+"
    else
        TweenService:Create(MF, TweenInfo.new(0.35, Enum.EasingStyle.Back), {Size = osz}):Play()
        SF.Visible = true
        GL.Visible = true
        MB.Text = "−"
    end
end)

--// CLOSE
CB.MouseButton1Click:Connect(function()
    TweenService:Create(MF, TweenInfo.new(0.25), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    wait(0.3)
    SG:Destroy()
end)

--// CARD CREATOR
local function Card(t, d, fn)
    local C = Instance.new("Frame")
    C.Size = UDim2.new(1, -6, 0, 90)
    C.BackgroundColor3 = CFG.SC
    C.BorderSizePixel = 0
    C.Parent = SF
    Instance.new("UICorner", C).CornerRadius = UDim.new(0, 8)

    local S = Instance.new("UIStroke")
    S.Color = Color3.fromRGB(50, 50, 50)
    S.Thickness = 1
    S.Parent = C

    local T = Instance.new("TextLabel")
    T.Size = UDim2.new(1, -12, 0, 22)
    T.Position = UDim2.new(0, 8, 0, 6)
    T.BackgroundTransparency = 1
    T.Text = "🔥 " .. t
    T.TextColor3 = CFG.AC
    T.Font = CFG.F
    T.TextSize = 12
    T.TextXAlignment = Enum.TextXAlignment.Left
    T.Parent = C

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -12, 0, 28)
    D.Position = UDim2.new(0, 8, 0, 28)
    D.BackgroundTransparency = 1
    D.Text = d
    D.TextColor3 = Color3.fromRGB(170, 170, 170)
    D.Font = Enum.Font.Gotham
    D.TextSize = 9
    D.TextWrapped = true
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = C

    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, 90, 0, 26)
    B.Position = UDim2.new(1, -98, 0, 58)
    B.BackgroundColor3 = CFG.AC
    B.Text = "AKTIFKAN"
    B.TextColor3 = Color3.new(1, 1, 1)
    B.Font = CFG.F
    B.TextSize = 10
    B.AutoButtonColor = false
    B.Parent = C
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 5)

    local on = false
    B.MouseButton1Click:Connect(function()
        on = not on
        if on then
            B.Text = "MATIKAN"
            B.BackgroundColor3 = Color3.fromRGB(45, 180, 45)
            S.Color = Color3.fromRGB(45, 180, 45)
        else
            B.Text = "AKTIFKAN"
            B.BackgroundColor3 = CFG.AC
            S.Color = Color3.fromRGB(50, 50, 50)
        end
        fn(on)
    end)

    C.MouseEnter:Connect(function()
        TweenService:Create(C, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 42)}):Play()
    end)
    C.MouseLeave:Connect(function()
        TweenService:Create(C, TweenInfo.new(0.2), {BackgroundColor3 = CFG.SC}):Play()
    end)
end

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 1: B2-SPIRIT — 36 BLOCKS FLYING WING
--// ═══════════════════════════════════════════════════════════════════════════
Card("B2-SPIRIT STEALTH FLIGHT", "Pesawat stealth 36 blok. WASD + Space/Shift.", function(on)
    if not on then
        if _G.GB2 then _G.GB2:Disconnect() _G.GB2M:Destroy() _G.GB2 = nil end
        return
    end

    local M = Instance.new("Model")
    M.Name = "B2"
    _G.GB2M = M

    local parts = {}
    -- Body center
    for i = 1, 6 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1.8, 0.8, 1.8)
        p.Color = Color3.fromRGB(28, 28, 28)
        p.Material = Enum.Material.SmoothPlastic
        p.Transparency = 0.1
        p.CanCollide = false
        p.Parent = M
        table.insert(parts, {p, 0, 0, -i * 1.4})
    end
    -- Left wing
    for r = 1, 6 do
        for c = 1, 2 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(1.6, 0.2, 1.2)
            p.Color = Color3.fromRGB(22, 22, 22)
            p.Material = Enum.Material.SmoothPlastic
            p.Transparency = 0.15
            p.CanCollide = false
            p.Parent = M
            table.insert(parts, {p, -2.5 - c * 1.8, 0, -r * 1.3})
        end
    end
    -- Right wing
    for r = 1, 6 do
        for c = 1, 2 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(1.6, 0.2, 1.2)
            p.Color = Color3.fromRGB(22, 22, 22)
            p.Material = Enum.Material.SmoothPlastic
            p.Transparency = 0.15
            p.CanCollide = false
            p.Parent = M
            table.insert(parts, {p, 2.5 + c * 1.8, 0, -r * 1.3})
        end
    end

    local glow = Instance.new("PointLight")
    glow.Color = Color3.fromRGB(255, 80, 0)
    glow.Brightness = 6
    glow.Range = 15
    glow.Parent = parts[1][1]

    M.Parent = Workspace

    _G.GB2 = RunService.RenderStepped:Connect(function()
        local md = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then md = md + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then md = md - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then md = md - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then md = md + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then md = md + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then md = md - Vector3.new(0, 1, 0) end

        if md.Magnitude > 0 then
            md = md.Unit * 80
            HumanoidRootPart.Velocity = md
            HumanoidRootPart.CFrame = CFrame.new(HumanoidRootPart.Position, HumanoidRootPart.Position + md)
        else
            HumanoidRootPart.Velocity = Vector3.zero
        end

        local bp = HumanoidRootPart.Position + Vector3.new(0, 3, 0)
        local yaw = math.atan2(Camera.CFrame.LookVector.X, Camera.CFrame.LookVector.Z)
        local cf = CFrame.new(bp) * CFrame.Angles(0, yaw, 0)

        for _, data in ipairs(parts) do
            data[1].CFrame = cf * CFrame.new(data[2], data[3], data[4])
        end
    end)

    game.StarterGui:SetCore("SendNotification", {Title = "GRATACAAI", Text = "B2 aktif!", Duration = 2})
end)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 2: LEVIATHAN — 30 BLOCKS SERPENT
--// ═══════════════════════════════════════════════════════════════════════════
Card("LEVIATHAN AQUATIC", "Ular laut 30 blok. Swim speed + water breathing.", function(on)
    if not on then
        if _G.GL then _G.GL:Disconnect() _G.GLM:Destroy() _G.GL = nil end
        Humanoid.WalkSpeed = 16
        return
    end

    local M = Instance.new("Model")
    M.Name = "Leviathan"
    _G.GLM = M

    local body = {}
    for i = 1, 24 do
        local p = Instance.new("Part")
        local s = 2.8 - i * 0.08
        p.Size = Vector3.new(s, s * 0.7, s * 1.2)
        p.Color = i % 3 == 0 and Color3.fromRGB(0, 200, 180) or Color3.fromRGB(12, 35, 70)
        p.Material = Enum.Material.Neon
        p.Transparency = 0.3
        p.CanCollide = false
        p.Parent = M

        local l = Instance.new("PointLight")
        l.Color = Color3.fromRGB(0, 255, 200)
        l.Brightness = 1.5
        l.Range = 5
        l.Parent = p

        table.insert(body, p)
    end

    local head = {}
    for i = 1, 6 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1.5 + i * 0.25, 1.2 + i * 0.2, 1.8 + i * 0.25)
        p.Color = Color3.fromRGB(8, 25, 50)
        p.Material = Enum.Material.Neon
        p.Transparency = 0.2
        p.CanCollide = false
        p.Parent = M
        table.insert(head, p)
    end

    local eye = Instance.new("PointLight")
    eye.Color = Color3.fromRGB(255, 0, 0)
    eye.Brightness = 12
    eye.Range = 20
    eye.Parent = head[6]

    M.Parent = Workspace

    local t = 0
    _G.GL = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        local tp = HumanoidRootPart.Position

        for i, p in ipairs(head) do
            p.CFrame = CFrame.new(tp + Vector3.new(0, -6, i * 1))
        end

        for i, p in ipairs(body) do
            local wx = math.sin(t * 2 + i * 0.4) * 4
            local wz = math.cos(t * 2 + i * 0.4) * 4
            p.CFrame = CFrame.new(tp.X + wx, tp.Y - 8 - i * 1.1, tp.Z + wz)
        end

        Humanoid.WalkSpeed = 70
        local o = LocalPlayer:FindFirstChild("Oxygen")
        if o then o.Value = 100 end
    end)

    game.StarterGui:SetCore("SendNotification", {Title = "GRATACAAI", Text = "Leviathan aktif!", Duration = 2})
end)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 3: TORNADO — 36 BLOCKS FUNNEL
--// ═══════════════════════════════════════════════════════════════════════════
Card("LEVIATHAN TORNADO", "Tornado 36 blok. Tarik & hancurkan prop.", function(on)
    if not on then
        if _G.GT then _G.GT:Disconnect() _G.GTM:Destroy() _G.GT = nil end
        return
    end

    local M = Instance.new("Model")
    M.Name = "Tornado"
    _G.GTM = M

    local vortex = {}
    for i = 1, 36 do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1.3, 1.3, 1.3)
        p.Color = Color3.fromHSV(0.55 + (i / 36) * 0.15, 0.9, 1)
        p.Material = Enum.Material.Neon
        p.Transparency = 0.4
        p.CanCollide = false
        p.Parent = M
        table.insert(vortex, p)
    end

    local eye = Instance.new("Part")
    eye.Size = Vector3.new(5, 0.2, 5)
    eye.Shape = Enum.PartType.Cylinder
    eye.Color = Color3.fromRGB(0, 255, 255)
    eye.Material = Enum.Material.Neon
    eye.Transparency = 0.2
    eye.CanCollide = false
    eye.Parent = M

    local eg = Instance.new("PointLight")
    eg.Color = Color3.fromRGB(0, 255, 255)
    eg.Brightness = 15
    eg.Range = 35
    eg.Parent = eye

    M.Parent = Workspace

    local t = 0
    _G.GT = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        local c = HumanoidRootPart.Position

        for i, p in ipairs(vortex) do
            local prog = i / 36
            local ang = prog * math.pi * 10 + t * 3
            local h = prog * 22 - 11
            local r = 18 * (1 - prog * 0.5)

            p.CFrame = CFrame.new(c.X + math.cos(ang) * r, c.Y + h, c.Z + math.sin(ang) * r) * CFrame.Angles(t * 2, t * 3, t)
        end

        eye.CFrame = CFrame.new(c.X, c.Y - 2, c.Z)

        for _, o in ipairs(Workspace:GetDescendants()) do
            if o:IsA("BasePart") and o ~= HumanoidRootPart and o.Parent ~= M then
                local dist = (o.Position - c).Magnitude
                if dist < 36 and dist > 3 then
                    local dir = (c - o.Position).Unit
                    o.Velocity = o.Velocity + dir * 60 * dt
                    if o.Anchored then o.Anchored = false end
                end
                if dist < 5 then
                    o.Velocity = Vector3.new(math.random(-60, 60), 120, math.random(-60, 60))
                    o.Color = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end)

    game.StarterGui:SetCore("SendNotification", {Title = "GRATACAAI", Text = "Tornado aktif!", Duration = 2})
end)

--// ═══════════════════════════════════════════════════════════════════════════
--// FEATURE 4: BLOOD WINGS — 40 BLOCKS FAN
--// ═══════════════════════════════════════════════════════════════════════════
Card("BLOOD WINGS", "Sayap darah 40 blok. Flap, glide, dash (Q).", function(on)
    if not on then
        if _G.GW then _G.GW:Disconnect() _G.GWM:Destroy() _G.GW = nil end
        return
    end

    local M = Instance.new("Model")
    M.Name = "Wings"
    _G.GWM = M

    local wingC = Color3.fromRGB(139, 0, 0)
    local feaC = Color3.fromRGB(220, 20, 60)

    local left = {}
    for r = 1, 5 do
        for c = 1, 4 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.8, 0.12, 1)
            p.Color = (r + c) % 2 == 0 and feaC or wingC
            p.Material = Enum.Material.Neon
            p.Transparency = 0.12
            p.CanCollide = false
            p.Parent = M
            table.insert(left, {p, r, c})
        end
    end

    local right = {}
    for r = 1, 5 do
        for c = 1, 4 do
            local p = Instance.new("Part")
            p.Size = Vector3.new(0.8, 0.12, 1)
            p.Color = (r + c) % 2 == 0 and feaC or wingC
            p.Material = Enum.Material.Neon
            p.Transparency = 0.12
            p.CanCollide = false
            p.Parent = M
            table.insert(right, {p, r, c})
        end
    end

    local spine = Instance.new("Part")
    spine.Size = Vector3.new(1.5, 0.2, 0.8)
    spine.Color = Color3.fromRGB(80, 0, 0)
    spine.Material = Enum.Material.Neon
    spine.Transparency = 0.05
    spine.CanCollide = false
    spine.Parent = M

    local blood = Instance.new("ParticleEmitter")
    blood.Color = ColorSequence.new(Color3.fromRGB(139, 0, 0), Color3.fromRGB(60, 0, 0))
    blood.Size = NumberSequence.new(0.25, 0)
    blood.Lifetime = NumberRange.new(1, 2)
    blood.Rate = 25
    blood.Speed = NumberRange.new(1, 2.5)
    blood.Acceleration = Vector3.new(0, -4, 0)
    blood.Parent = spine

    M.Parent = Workspace

    local t = 0
    _G.GW = RunService.Heartbeat:Connect(function(dt)
        t = t + dt
        local bp = HumanoidRootPart.Position
        local flap = math.sin(t * 3.5) * 40

        spine.CFrame = CFrame.new(bp + Vector3.new(0, 1.3, -0.2))

        for _, d in ipairs(left) do
            local r, c = d[2], d[3]
            local ang = math.rad(-25 - c * 14 + flap)
            local rad = 1.8 + r * 1.1
            local x = math.cos(ang) * rad
            local y = math.sin(ang) * rad * 0.25 + r * 0.15
            d[1].CFrame = CFrame.new(bp + Vector3.new(0, 1.3, -0.2) + Vector3.new(x, y, -c * 0.5)) * CFrame.Angles(0, 0, ang)
        end

        for _, d in ipairs(right) do
            local r, c = d[2], d[3]
            local ang = math.rad(25 + c * 14 - flap)
            local rad = 1.8 + r * 1.1
            local x = math.cos(ang) * rad
            local y = math.sin(ang) * rad * 0.25 + r * 0.15
            d[1].CFrame = CFrame.new(bp + Vector3.new(0, 1.3, -0.2) + Vector3.new(x, y, -c * 0.5)) * CFrame.Angles(0, 0, ang)
        end

        if HumanoidRootPart.Velocity.Y < -3 then
            HumanoidRootPart.Velocity = HumanoidRootPart.Velocity + Vector3.new(0, 10, 0) * dt
        end

        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            HumanoidRootPart.Velocity = HumanoidRootPart.CFrame.LookVector * 130
        end
    end)

    game.StarterGui:SetCore("SendNotification", {Title = "GRATACAAI", Text = "Blood Wings aktif!", Duration = 2})
end)

--//
