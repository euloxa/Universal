local Players            = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local UserInputService   = game:GetService("UserInputService")
local Camera             = workspace.CurrentCamera
local MarketplaceService = game:GetService("MarketplaceService")

local CONFIG = {
    Key            = "L2-HUB",
    DiscordInvite  = "https://discord.gg/lifeorlose",
    GetKeyURL      = "https://discord.gg/lifeorlose",
    WebsiteURL     = "https://lifeorlose.xyz",
    BannerURL      = "https://files.catbox.moe/6ajzfh.png",
    LogoAsset      = "rbxassetid://105349270202991",
    SaveFile       = "L2Hub_LoaderAssets/key.txt",
    SaveFolder     = "L2Hub_LoaderAssets",
    AutoExecFile   = "L2Hub_LoaderAssets/autoexec.txt",
    WindowTitle    = "L2 HUB",
    WindowSubtitle = "Freemium Roblox Scripts",
    BaseSize       = Vector2.new(410, 340),
    ExpandedSize   = Vector2.new(410, 440),
    Accent         = Color3.fromRGB(58, 255, 55),
    AccentDark     = Color3.fromRGB(16, 65, 18),
    DiscordBlurple = Color3.fromRGB(88, 101, 242),
    BG             = Color3.fromRGB(8, 10, 10),
    Surface        = Color3.fromRGB(18, 22, 20),
    SurfaceLight   = Color3.fromRGB(28, 34, 30),
    Outline        = Color3.fromRGB(0, 0, 0),
    Text           = Color3.fromRGB(255, 255, 255),
    Placeholder    = Color3.fromRGB(154, 168, 158),
}

local ICONS = {
    Close   = "73723454580812",
    Discord = "125095115408066",
    GetKey  = "123791018818522",
    Website = "113512058469465",
    Key     = "10709791182",
    Verify  = "10709791760",
    Play    = "10709791760",
    Game    = "113512058469465",
    Lock    = "10709678129",
}

local FontExtraBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
local FontBold      = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local FontFredoka   = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local NeonHeaderGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 45, 24)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(45, 175, 50)),
    ColorSequenceKeypoint.new(0.65, Color3.fromRGB(58, 255, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 65, 18))
})

local NeonButtonGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 255, 160)),
    ColorSequenceKeypoint.new(0.08, Color3.fromRGB(58, 255, 55)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 115, 12))
})

local DarkButtonGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(75, 82, 78)),
    ColorSequenceKeypoint.new(0.08, Color3.fromRGB(42, 48, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 24, 22))
})

local RedButtonGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 130, 130)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(225, 28, 28))
})

local RowPlateGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(62, 70, 65)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(34, 40, 36)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 24, 22))
})

local RowActiveGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 85, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(24, 52, 26)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 30, 16))
})

local TextShineGrad = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(215, 215, 215)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 235))
})

local function GetCoreGui()
    if gethui then
        local ok, res = pcall(gethui)
        if ok and res then return res end
    end
    if get_hidden_gui then
        local ok, res = pcall(get_hidden_gui)
        if ok and res then return res end
    end
    return game:GetService("CoreGui")
end

local function ProtectGui(gui)
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
end

local OldLoader = GetCoreGui():FindFirstChild("L2HubLoader")
if OldLoader then
    OldLoader:Destroy()
end

local function LoadRemoteAsset(url, fileName)
    if not (getcustomasset and isfolder and writefile and isfile) then return nil end
    local dir = "L2Hub_LoaderAssets"
    if not isfolder(dir) then makefolder(dir) end
    local path = dir .. "/" .. fileName
    if not isfile(path) then
        local ok, bytes = pcall(game.HttpGet, game, url)
        if not ok or type(bytes) ~= "string" or #bytes < 128 then return nil end
        if bytes:sub(1, 15):lower():find("<!doctype") or bytes:sub(1, 6):lower():find("<html") then
            return nil
        end
        pcall(writefile, path, bytes)
    end
    if not isfile(path) then return nil end
    local ok, asset = pcall(getcustomasset, path)
    if ok and type(asset) == "string" then return asset end
    return nil
end

local function Stroke(obj, color, thickness, transparency, mode)
    local s = Instance.new("UIStroke")
    s.Color = color or CONFIG.Outline
    s.Thickness = thickness or 1.8
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = mode or Enum.ApplyStrokeMode.Border
    s.LineJoinMode = Enum.LineJoinMode.Round
    s.Parent = obj
    return s
end

local function StyleL2Text(label, useShine)
    Stroke(label, 1.5, Color3.fromRGB(0, 0, 0), 0, Enum.ApplyStrokeMode.Contextual)
    if useShine then
        local grad = Instance.new("UIGradient")
        grad.Color = TextShineGrad
        grad.Rotation = 90
        grad.Parent = label
    end
end

local function Tween(obj, props, time, style, dir)
    local info = TweenInfo.new(time or 0.18, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

local function AddScaleFeedback(btn, hoverScale, pressScale)
    local scale = Instance.new("UIScale")
    scale.Scale = 1
    scale.Parent = btn
    local hovering = false

    btn.MouseEnter:Connect(function()
        hovering = true
        Tween(scale, {Scale = hoverScale or 1.035}, 0.1, Enum.EasingStyle.Quad)
    end)

    btn.MouseLeave:Connect(function()
        hovering = false
        Tween(scale, {Scale = 1}, 0.1, Enum.EasingStyle.Quad)
    end)

    btn.MouseButton1Down:Connect(function()
        Tween(scale, {Scale = pressScale or 0.95}, 0.055, Enum.EasingStyle.Quad)
    end)

    btn.MouseButton1Up:Connect(function()
        Tween(scale, {Scale = hovering and (hoverScale or 1.035) or 1}, 0.08, Enum.EasingStyle.Quad)
    end)

    return scale
end

local function CopyURL(url)
    if not url:match("^https?://") then url = "https://" .. url end
    local copied = false
    if setclipboard then copied = pcall(setclipboard, url)
    elseif toclipboard then copied = pcall(toclipboard, url)
    elseif set_clipboard then copied = pcall(set_clipboard, url) end
    return copied, url
end

local function SaveKey(key)
    if not writefile then return false end
    if not CONFIG.SaveFile or CONFIG.SaveFile == "" then return false end
    if isfolder and makefolder and CONFIG.SaveFolder then
        if not isfolder(CONFIG.SaveFolder) then
            pcall(makefolder, CONFIG.SaveFolder)
        end
    end
    local ok = pcall(writefile, CONFIG.SaveFile, tostring(key))
    return ok
end

local function LoadKey()
    if not (isfile and readfile) then return nil end
    if not CONFIG.SaveFile or CONFIG.SaveFile == "" then return nil end
    local exists = pcall(isfile, CONFIG.SaveFile)
    if not exists or not isfile(CONFIG.SaveFile) then return nil end
    local ok, data = pcall(readfile, CONFIG.SaveFile)
    if ok and type(data) == "string" and #data > 0 then
        return data
    end
    return nil
end

local function ClearKey()
    if not (isfile and delfile) then return end
    if not CONFIG.SaveFile or CONFIG.SaveFile == "" then return end
    if isfile(CONFIG.SaveFile) then
        pcall(delfile, CONFIG.SaveFile)
    end
end

local function SaveAutoExec(state)
    if not writefile then return false end
    if isfolder and makefolder and CONFIG.SaveFolder then
        if not isfolder(CONFIG.SaveFolder) then
            pcall(makefolder, CONFIG.SaveFolder)
        end
    end
    return pcall(writefile, CONFIG.AutoExecFile, state and "1" or "0")
end

local function LoadAutoExec()
    if not (isfile and readfile) then return false end
    local ok = pcall(isfile, CONFIG.AutoExecFile)
    if not ok or not isfile(CONFIG.AutoExecFile) then return false end
    local ok2, content = pcall(readfile, CONFIG.AutoExecFile)
    if ok2 and type(content) == "string" then
        return (content:gsub("%s+", "") == "1")
    end
    return false
end

local function FireVerified(result)
    local bindable = getgenv().L2HUB_VERIFIED
    if bindable and typeof(bindable) == "Instance" and bindable:IsA("BindableEvent") then
        pcall(function() bindable:Fire(result) end)
    end
end

local GAMES = getgenv().L2HUB_GAMES or {}

local function IsCurrentPlace(entry)
    local myPlace = tonumber(game.PlaceId)
    local myGame  = tonumber(game.GameId)

    if tonumber(entry.PlaceId) == myPlace then return true end
    if tonumber(entry.GameId)  == myGame  then return true end

    if type(entry.PlaceIds) == "table" then
        for _, pid in ipairs(entry.PlaceIds) do
            if tonumber(pid) == myPlace then return true end
        end
    end

    if type(entry.GameIds) == "table" then
        for _, gid in ipairs(entry.GameIds) do
            if tonumber(gid) == myGame then return true end
        end
    end

    return false
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "L2HubLoader"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ProtectGui(ScreenGui)
ScreenGui.Parent = GetCoreGui()

local UIScaleHolder = Instance.new("Frame")
UIScaleHolder.Name = "ScaleHolder"
UIScaleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
UIScaleHolder.Position = UDim2.fromScale(0.5, 0.5)
UIScaleHolder.Size = UDim2.fromOffset(CONFIG.BaseSize.X, CONFIG.BaseSize.Y)
UIScaleHolder.BackgroundTransparency = 1
UIScaleHolder.Parent = ScreenGui

local UIScale = Instance.new("UIScale")
UIScale.Parent = UIScaleHolder
UIScale.Scale = 1

local function ApplyResponsiveScale()
    local vp = Camera.ViewportSize
    local maxW = vp.X * 0.88
    local maxH = vp.Y * 0.88
    local refH = math.max(CONFIG.BaseSize.Y, CONFIG.ExpandedSize.Y)
    local s = math.min(maxW / CONFIG.BaseSize.X, maxH / refH, 1)
    s = math.clamp(s, 0.5, 1)
    UIScale.Scale = s
end

ApplyResponsiveScale()
Camera:GetPropertyChangedSignal("ViewportSize"):Connect(ApplyResponsiveScale)

local Root = Instance.new("Frame")
Root.Name = "Root"
Root.Size = UDim2.fromScale(1, 1)
Root.BackgroundColor3 = CONFIG.BG
Root.BackgroundTransparency = 0.22
Root.BorderSizePixel = 0
Root.ClipsDescendants = true
Root.Active = true
Root.Parent = UIScaleHolder
Stroke(Root, Color3.fromRGB(0, 0, 0), 2.4, 0)

local GridTexture = Instance.new("ImageLabel")
GridTexture.Name = "GridTexture"
GridTexture.Size = UDim2.fromScale(1, 1)
GridTexture.BackgroundTransparency = 1
GridTexture.Image = "rbxassetid://6372755229"
GridTexture.ImageColor3 = CONFIG.Accent
GridTexture.ImageTransparency = 0.93
GridTexture.ScaleType = Enum.ScaleType.Tile
GridTexture.TileSize = UDim2.fromOffset(24, 24)
GridTexture.ZIndex = 1
GridTexture.Parent = Root

local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 38)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 38, 10)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 10
TopBar.Parent = Root
Stroke(TopBar, Color3.fromRGB(0, 0, 0), 1.8, 0)

local TopColor = Instance.new("Frame")
TopColor.AnchorPoint = Vector2.new(0.5, 0)
TopColor.Position = UDim2.fromScale(0.5, 0)
TopColor.Size = UDim2.fromScale(1, 0.88)
TopColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopColor.BorderSizePixel = 0
TopColor.ZIndex = 11
TopColor.Parent = TopBar

local TopGrad = Instance.new("UIGradient")
TopGrad.Color = NeonHeaderGrad
TopGrad.Rotation = 25
TopGrad.Parent = TopColor

local TopTrans = Instance.new("Frame")
TopTrans.AnchorPoint = Vector2.new(0.5, 0.5)
TopTrans.Position = UDim2.fromScale(0.5, 0.5)
TopTrans.Size = UDim2.fromScale(0.988, 0.84)
TopTrans.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TopTrans.BackgroundTransparency = 0.88
TopTrans.BorderSizePixel = 0
TopTrans.ZIndex = 12
TopTrans.Parent = TopColor

local TopTitle = Instance.new("TextLabel")
TopTitle.AnchorPoint = Vector2.new(0, 0.5)
TopTitle.Position = UDim2.new(0, 12, 0.5, 0)
TopTitle.Size = UDim2.new(0.65, 0, 0, 22)
TopTitle.BackgroundTransparency = 1
TopTitle.FontFace = FontExtraBold
TopTitle.Text = "L2 HUB  //  LOADER"
TopTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
TopTitle.TextSize = 15
TopTitle.TextXAlignment = Enum.TextXAlignment.Left
TopTitle.ZIndex = 13
TopTitle.Parent = TopColor
StyleL2Text(TopTitle, true)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.AnchorPoint = Vector2.new(1, 0.5)
CloseBtn.Position = UDim2.new(1, -6, 0.5, 0)
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.BackgroundColor3 = Color3.fromRGB(126, 0, 0)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = ""
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 20
CloseBtn.Parent = TopBar
Stroke(CloseBtn, Color3.fromRGB(50, 0, 0), 1.6, 0)

local CloseColor = Instance.new("Frame")
CloseColor.AnchorPoint = Vector2.new(0.5, 0)
CloseColor.Position = UDim2.fromScale(0.5, 0)
CloseColor.Size = UDim2.fromScale(1, 0.9)
CloseColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseColor.BorderSizePixel = 0
CloseColor.ZIndex = 21
CloseColor.Parent = CloseBtn

local CloseGrad = Instance.new("UIGradient")
CloseGrad.Color = RedButtonGrad
CloseGrad.Rotation = 90
CloseGrad.Parent = CloseColor

local CloseInner = Instance.new("Frame")
CloseInner.AnchorPoint = Vector2.new(0.5, 0.5)
CloseInner.Position = UDim2.fromScale(0.5, 0.5)
CloseInner.Size = UDim2.fromScale(0.92, 0.84)
CloseInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseInner.BackgroundTransparency = 0.88
CloseInner.BorderSizePixel = 0
CloseInner.ZIndex = 22
CloseInner.Parent = CloseColor

local CloseLabel = Instance.new("TextLabel")
CloseLabel.AnchorPoint = Vector2.new(0.5, 0.5)
CloseLabel.Position = UDim2.fromScale(0.5, 0.5)
CloseLabel.Size = UDim2.fromScale(1, 1)
CloseLabel.BackgroundTransparency = 1
CloseLabel.FontFace = FontExtraBold
CloseLabel.Text = "X"
CloseLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseLabel.TextSize = 14
CloseLabel.ZIndex = 23
CloseLabel.Parent = CloseColor
StyleL2Text(CloseLabel, true)
AddScaleFeedback(CloseBtn, 1.06, 0.94)

local BannerHolder = Instance.new("Frame")
BannerHolder.Name = "BannerHolder"
BannerHolder.Position = UDim2.fromOffset(0, 38)
BannerHolder.Size = UDim2.new(1, 0, 0, 92)
BannerHolder.BackgroundColor3 = CONFIG.Surface
BannerHolder.BorderSizePixel = 0
BannerHolder.ClipsDescendants = true
BannerHolder.ZIndex = 2
BannerHolder.Parent = Root
Stroke(BannerHolder, Color3.fromRGB(0, 0, 0), 1.6, 0)

local BannerFallback = Instance.new("Frame")
BannerFallback.Size = UDim2.fromScale(1, 1)
BannerFallback.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
BannerFallback.BorderSizePixel = 0
BannerFallback.Parent = BannerHolder

local FallbackGrad = Instance.new("UIGradient")
FallbackGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(16, 48, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 26, 12)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 12, 10))
})
FallbackGrad.Rotation = 35
FallbackGrad.Parent = BannerFallback

local BannerImage = Instance.new("ImageLabel")
BannerImage.Name = "Banner"
BannerImage.Size = UDim2.fromScale(1, 1)
BannerImage.BackgroundTransparency = 1
BannerImage.ScaleType = Enum.ScaleType.Crop
BannerImage.Image = ""
BannerImage.ImageTransparency = 1
BannerImage.ZIndex = 3
BannerImage.Parent = BannerHolder

task.spawn(function()
    local asset = LoadRemoteAsset(CONFIG.BannerURL, "banner.png")
    if asset then
        BannerImage.Image = asset
        Tween(BannerImage, { ImageTransparency = 0.15 }, 0.4)
    end
end)

local BannerOverlay = Instance.new("Frame")
BannerOverlay.Size = UDim2.fromScale(1, 1)
BannerOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
BannerOverlay.BackgroundTransparency = 0.45
BannerOverlay.BorderSizePixel = 0
BannerOverlay.ZIndex = 4
BannerOverlay.Parent = BannerHolder

local ProfileRow = Instance.new("Frame")
ProfileRow.Name = "ProfileRow"
ProfileRow.Size = UDim2.new(1, -24, 0, 64)
ProfileRow.Position = UDim2.fromOffset(12, 98)
ProfileRow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ProfileRow.BackgroundTransparency = 0.08
ProfileRow.BorderSizePixel = 0
ProfileRow.ZIndex = 6
ProfileRow.Parent = Root
Stroke(ProfileRow, Color3.fromRGB(0, 0, 0), 1.8, 0)

local ProfileGrad = Instance.new("UIGradient")
ProfileGrad.Color = RowPlateGrad
ProfileGrad.Rotation = 90
ProfileGrad.Parent = ProfileRow

local ProfileBevel = Instance.new("Frame")
ProfileBevel.AnchorPoint = Vector2.new(0.5, 0.5)
ProfileBevel.Position = UDim2.fromScale(0.5, 0.5)
ProfileBevel.Size = UDim2.new(1, -4, 1, -4)
ProfileBevel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ProfileBevel.BackgroundTransparency = 0.72
ProfileBevel.BorderSizePixel = 0
ProfileBevel.ZIndex = 6
ProfileBevel.Parent = ProfileRow

local AvatarHolder = Instance.new("Frame")
AvatarHolder.AnchorPoint = Vector2.new(0, 0.5)
AvatarHolder.Position = UDim2.new(0, 8, 0.5, 0)
AvatarHolder.Size = UDim2.fromOffset(48, 48)
AvatarHolder.BackgroundColor3 = Color3.fromRGB(10, 14, 12)
AvatarHolder.BorderSizePixel = 0
AvatarHolder.ZIndex = 7
AvatarHolder.Parent = ProfileRow
Stroke(AvatarHolder, CONFIG.Accent, 1.6, 0)

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
AvatarImage.Position = UDim2.fromScale(0.5, 0.5)
AvatarImage.Size = UDim2.fromScale(0.9, 0.9)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = CONFIG.LogoAsset
AvatarImage.ScaleType = Enum.ScaleType.Fit
AvatarImage.ZIndex = 8
AvatarImage.Parent = AvatarHolder

local StatusDot = Instance.new("Frame")
StatusDot.AnchorPoint = Vector2.new(1, 1)
StatusDot.Position = UDim2.new(1, -2, 1, -2)
StatusDot.Size = UDim2.fromOffset(10, 10)
StatusDot.BackgroundColor3 = CONFIG.Accent
StatusDot.BorderSizePixel = 0
StatusDot.ZIndex = 9
StatusDot.Parent = AvatarHolder
Stroke(StatusDot, Color3.fromRGB(0, 0, 0), 1.5, 0)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Position = UDim2.fromOffset(66, 10)
TitleLabel.Size = UDim2.new(1, -170, 0, 22)
TitleLabel.BackgroundTransparency = 1
TitleLabel.FontFace = FontExtraBold
TitleLabel.Text = CONFIG.WindowTitle
TitleLabel.TextColor3 = CONFIG.Text
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 8
TitleLabel.Parent = ProfileRow
StyleL2Text(TitleLabel, true)

local SubLabel = Instance.new("TextLabel")
SubLabel.Position = UDim2.fromOffset(66, 33)
SubLabel.Size = UDim2.new(1, -170, 0, 16)
SubLabel.BackgroundTransparency = 1
SubLabel.FontFace = FontBold
SubLabel.Text = CONFIG.WindowSubtitle
SubLabel.TextColor3 = Color3.fromRGB(130, 240, 130)
SubLabel.TextSize = 11
SubLabel.TextXAlignment = Enum.TextXAlignment.Left
SubLabel.ZIndex = 8
SubLabel.Parent = ProfileRow
StyleL2Text(SubLabel, false)

local AutoToggleHolder = Instance.new("Frame")
AutoToggleHolder.Name = "AutoToggleHolder"
AutoToggleHolder.AnchorPoint = Vector2.new(1, 0)
AutoToggleHolder.Position = UDim2.new(1, -10, 0, 10)
AutoToggleHolder.Size = UDim2.fromOffset(64, 26)
AutoToggleHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoToggleHolder.BorderSizePixel = 0
AutoToggleHolder.ZIndex = 8
AutoToggleHolder.Parent = ProfileRow
local AutoToggleStroke = Stroke(AutoToggleHolder, Color3.fromRGB(0, 0, 0), 1.6, 0)

local AutoOffGrad = Instance.new("UIGradient")
AutoOffGrad.Color = ColorSequence.new(Color3.fromRGB(18, 20, 22))
AutoOffGrad.Rotation = 90
AutoOffGrad.Parent = AutoToggleHolder

local AutoOnGrad = Instance.new("UIGradient")
AutoOnGrad.Color = NeonButtonGrad
AutoOnGrad.Rotation = 90
AutoOnGrad.Enabled = false
AutoOnGrad.Parent = AutoToggleHolder

local AutoToggleBtn = Instance.new("TextButton")
AutoToggleBtn.Size = UDim2.fromScale(1, 1)
AutoToggleBtn.BackgroundTransparency = 1
AutoToggleBtn.Text = ""
AutoToggleBtn.AutoButtonColor = false
AutoToggleBtn.ZIndex = 11
AutoToggleBtn.Parent = AutoToggleHolder

local AutoKnob = Instance.new("Frame")
AutoKnob.AnchorPoint = Vector2.new(0.5, 0.5)
AutoKnob.Position = UDim2.fromScale(0.26, 0.5)
AutoKnob.Size = UDim2.fromOffset(22, 18)
AutoKnob.BackgroundColor3 = Color3.fromRGB(90, 95, 92)
AutoKnob.BorderSizePixel = 0
AutoKnob.ZIndex = 9
AutoKnob.Parent = AutoToggleHolder
Stroke(AutoKnob, Color3.fromRGB(0, 0, 0), 1.4, 0)

local AutoKnobTop = Instance.new("Frame")
AutoKnobTop.AnchorPoint = Vector2.new(0.5, 0)
AutoKnobTop.Position = UDim2.fromScale(0.5, 0)
AutoKnobTop.Size = UDim2.fromScale(1, 0.88)
AutoKnobTop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
AutoKnobTop.BorderSizePixel = 0
AutoKnobTop.ZIndex = 10
AutoKnobTop.Parent = AutoKnob

local AutoLabel = Instance.new("TextLabel")
AutoLabel.AnchorPoint = Vector2.new(0.5, 0)
AutoLabel.Position = UDim2.new(0.5, 0, 1, 4)
AutoLabel.Size = UDim2.new(1, 16, 0, 12)
AutoLabel.BackgroundTransparency = 1
AutoLabel.FontFace = FontExtraBold
AutoLabel.Text = "AUTO EXEC"
AutoLabel.TextColor3 = CONFIG.Placeholder
AutoLabel.TextSize = 9
AutoLabel.ZIndex = 9
AutoLabel.Parent = AutoToggleHolder
StyleL2Text(AutoLabel, false)

local autoExecEnabled = LoadAutoExec()

local function UpdateAutoToggle(animate)
    local dur = animate and 0.16 or 0
    AutoOnGrad.Enabled = autoExecEnabled
    AutoOffGrad.Enabled = not autoExecEnabled

    local targetPos = autoExecEnabled and UDim2.fromScale(0.74, 0.5) or UDim2.fromScale(0.26, 0.5)
    if animate then
        Tween(AutoKnob, { Position = targetPos }, dur)
    else
        AutoKnob.Position = targetPos
    end

    AutoToggleStroke.Color = autoExecEnabled and CONFIG.Accent or Color3.fromRGB(0, 0, 0)
    AutoLabel.TextColor3 = autoExecEnabled and CONFIG.Accent or CONFIG.Placeholder
end

UpdateAutoToggle(false)

local ToastHolder = Instance.new("Frame")
ToastHolder.AnchorPoint = Vector2.new(0.5, 0)
ToastHolder.Position = UDim2.new(0.5, 0, 0, 44)
ToastHolder.Size = UDim2.new(1, -24, 0, 34)
ToastHolder.BackgroundColor3 = Color3.fromRGB(10, 14, 12)
ToastHolder.BackgroundTransparency = 1
ToastHolder.BorderSizePixel = 0
ToastHolder.ZIndex = 60
ToastHolder.Parent = Root
local ToastStroke = Stroke(ToastHolder, CONFIG.Accent, 1.6, 1)

local ToastAccentLeft = Instance.new("Frame")
ToastAccentLeft.Size = UDim2.new(0, 4, 1, 0)
ToastAccentLeft.BackgroundColor3 = CONFIG.Accent
ToastAccentLeft.BackgroundTransparency = 1
ToastAccentLeft.BorderSizePixel = 0
ToastAccentLeft.ZIndex = 61
ToastAccentLeft.Parent = ToastHolder

local ToastLabel = Instance.new("TextLabel")
ToastLabel.Size = UDim2.new(1, -20, 1, 0)
ToastLabel.Position = UDim2.fromOffset(12, 0)
ToastLabel.BackgroundTransparency = 1
ToastLabel.FontFace = FontExtraBold
ToastLabel.Text = ""
ToastLabel.TextColor3 = CONFIG.Text
ToastLabel.TextTransparency = 1
ToastLabel.TextSize = 12
ToastLabel.TextXAlignment = Enum.TextXAlignment.Center
ToastLabel.TextWrapped = true
ToastLabel.ZIndex = 62
ToastLabel.Parent = ToastHolder

local toastBusy = false
local function Toast(text, ok)
    if toastBusy then return end
    toastBusy = true

    local statusColor = (ok == false) and Color3.fromRGB(255, 85, 85) or CONFIG.Accent
    ToastLabel.Text = text
    ToastLabel.TextColor3 = (ok == false) and Color3.fromRGB(255, 130, 130) or CONFIG.Text
    ToastStroke.Color = statusColor
    ToastAccentLeft.BackgroundColor3 = statusColor

    Tween(ToastHolder, { BackgroundTransparency = 0.08 }, 0.18)
    Tween(ToastStroke, { Transparency = 0 }, 0.18)
    Tween(ToastAccentLeft, { BackgroundTransparency = 0 }, 0.18)
    Tween(ToastLabel, { TextTransparency = 0 }, 0.18)

    task.delay(2.3, function()
        Tween(ToastHolder, { BackgroundTransparency = 1 }, 0.22)
        Tween(ToastStroke, { Transparency = 1 }, 0.22)
        Tween(ToastAccentLeft, { BackgroundTransparency = 1 }, 0.22)
        Tween(ToastLabel, { TextTransparency = 1 }, 0.22)
        task.wait(0.25)
        toastBusy = false
    end)
end

AutoToggleBtn.MouseButton1Click:Connect(function()
    autoExecEnabled = not autoExecEnabled
    SaveAutoExec(autoExecEnabled)
    UpdateAutoToggle(true)
    Toast(autoExecEnabled and "Auto-Execute ON." or "Auto-Execute OFF.", true)
end)

CloseBtn.MouseButton1Click:Connect(function()
    FireVerified(false)
    Tween(UIScale, { Scale = 0 }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    task.wait(0.24)
    ScreenGui:Destroy()
end)

local ContentArea = Instance.new("Frame")
ContentArea.Position = UDim2.fromOffset(12, 168)
ContentArea.Size = UDim2.new(1, -24, 0, 160)
ContentArea.BackgroundTransparency = 1
ContentArea.ClipsDescendants = false
ContentArea.ZIndex = 5
ContentArea.Parent = Root

local KeyPage = Instance.new("Frame")
KeyPage.Name = "KeyPage"
KeyPage.Size = UDim2.new(1, 0, 0, 160)
KeyPage.BackgroundTransparency = 1
KeyPage.Parent = ContentArea

local GamePage = Instance.new("Frame")
GamePage.Name = "GamePage"
GamePage.Size = UDim2.new(1, 0, 0, 260)
GamePage.Position = UDim2.fromOffset(0, -30)
GamePage.BackgroundTransparency = 1
GamePage.Visible = false
GamePage.Parent = ContentArea

local SectionLabel = Instance.new("TextLabel")
SectionLabel.Position = UDim2.fromOffset(2, 4)
SectionLabel.Size = UDim2.new(1, -4, 0, 16)
SectionLabel.BackgroundTransparency = 1
SectionLabel.FontFace = FontExtraBold
SectionLabel.Text = "AUTHENTICATION  //  ENTER ACCESS KEY"
SectionLabel.TextColor3 = CONFIG.Accent
SectionLabel.TextSize = 11
SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
SectionLabel.Parent = KeyPage
StyleL2Text(SectionLabel, false)

local InputHolder = Instance.new("Frame")
InputHolder.Position = UDim2.fromOffset(2, 26)
InputHolder.Size = UDim2.new(1, -4, 0, 40)
InputHolder.BackgroundColor3 = Color3.fromRGB(10, 12, 11)
InputHolder.BackgroundTransparency = 0.25
InputHolder.BorderSizePixel = 0
InputHolder.Parent = KeyPage
local InputStroke = Stroke(InputHolder, Color3.fromRGB(0, 0, 0), 1.8, 0)

local InputUnderline = Instance.new("Frame")
InputUnderline.AnchorPoint = Vector2.new(0.5, 1)
InputUnderline.Position = UDim2.fromScale(0.5, 1)
InputUnderline.Size = UDim2.new(0, 0, 0, 2)
InputUnderline.BackgroundColor3 = CONFIG.Accent
InputUnderline.BorderSizePixel = 0
InputUnderline.ZIndex = 8
InputUnderline.Parent = InputHolder

local InputIcon = Instance.new("ImageLabel")
InputIcon.AnchorPoint = Vector2.new(0, 0.5)
InputIcon.Position = UDim2.new(0, 12, 0.5, 0)
InputIcon.Size = UDim2.fromOffset(18, 18)
InputIcon.BackgroundTransparency = 1
InputIcon.Image = "rbxassetid://" .. ICONS.Key
InputIcon.ImageColor3 = CONFIG.Accent
InputIcon.ScaleType = Enum.ScaleType.Fit
InputIcon.ZIndex = 7
InputIcon.Parent = InputHolder

local KeyInput = Instance.new("TextBox")
KeyInput.AnchorPoint = Vector2.new(0, 0.5)
KeyInput.Position = UDim2.new(0, 38, 0.5, 0)
KeyInput.Size = UDim2.new(1, -48, 1, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.FontFace = FontBold
KeyInput.PlaceholderText = "Paste your L2 Key here..."
KeyInput.PlaceholderColor3 = CONFIG.Placeholder
KeyInput.Text = ""
KeyInput.TextColor3 = CONFIG.Text
KeyInput.TextSize = 13
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 7
KeyInput.Parent = InputHolder
StyleL2Text(KeyInput, false)

KeyInput.Focused:Connect(function()
    Tween(InputHolder, { BackgroundTransparency = 0.1 }, 0.16)
    Tween(InputUnderline, { Size = UDim2.new(1, 0, 0, 2) }, 0.22, Enum.EasingStyle.Quint)
    Tween(InputStroke, { Color = CONFIG.Accent }, 0.16)
end)

KeyInput.FocusLost:Connect(function()
    Tween(InputHolder, { BackgroundTransparency = 0.25 }, 0.16)
    Tween(InputUnderline, { Size = UDim2.new(0, 0, 0, 2) }, 0.22, Enum.EasingStyle.Quint)
    Tween(InputStroke, { Color = Color3.fromRGB(0, 0, 0) }, 0.16)
end)

local BtnRow = Instance.new("Frame")
BtnRow.Position = UDim2.fromOffset(2, 78)
BtnRow.Size = UDim2.new(1, -4, 0, 42)
BtnRow.BackgroundTransparency = 1
BtnRow.Parent = KeyPage

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0.60, -4, 0, 40)
VerifyBtn.Position = UDim2.fromOffset(0, 1)
VerifyBtn.BackgroundTransparency = 1
VerifyBtn.BorderSizePixel = 0
VerifyBtn.Text = ""
VerifyBtn.AutoButtonColor = false
VerifyBtn.ZIndex = 7
VerifyBtn.Parent = BtnRow
AddScaleFeedback(VerifyBtn, 1.03, 0.96)

local VerifyBase = Instance.new("Frame")
VerifyBase.AnchorPoint = Vector2.new(0.5, 0.5)
VerifyBase.Position = UDim2.fromScale(0.5, 0.5)
VerifyBase.Size = UDim2.fromScale(1, 0.94)
VerifyBase.BackgroundColor3 = Color3.fromRGB(10, 75, 12)
VerifyBase.BorderSizePixel = 0
VerifyBase.ZIndex = 7
VerifyBase.Parent = VerifyBtn
Stroke(VerifyBase, Color3.fromRGB(0, 0, 0), 1.8, 0)

local VerifyColor = Instance.new("Frame")
VerifyColor.AnchorPoint = Vector2.new(0.5, 0)
VerifyColor.Position = UDim2.fromScale(0.5, 0)
VerifyColor.Size = UDim2.fromScale(1, 0.9)
VerifyColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
VerifyColor.BorderSizePixel = 0
VerifyColor.ZIndex = 8
VerifyColor.Parent = VerifyBase

local VerifyGrad = Instance.new("UIGradient")
VerifyGrad.Color = NeonButtonGrad
VerifyGrad.Rotation = 90
VerifyGrad.Parent = VerifyColor

local VerifyInner = Instance.new("Frame")
VerifyInner.AnchorPoint = Vector2.new(0.5, 0.5)
VerifyInner.Position = UDim2.fromScale(0.5, 0.5)
VerifyInner.Size = UDim2.fromScale(0.96, 0.84)
VerifyInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
VerifyInner.BackgroundTransparency = 0.86
VerifyInner.BorderSizePixel = 0
VerifyInner.ZIndex = 9
VerifyInner.Parent = VerifyColor

local VerifyIcon = Instance.new("ImageLabel")
VerifyIcon.AnchorPoint = Vector2.new(0, 0.5)
VerifyIcon.Position = UDim2.new(0, 14, 0.5, 0)
VerifyIcon.Size = UDim2.fromOffset(16, 16)
VerifyIcon.BackgroundTransparency = 1
VerifyIcon.Image = "rbxassetid://" .. ICONS.Verify
VerifyIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
VerifyIcon.ScaleType = Enum.ScaleType.Fit
VerifyIcon.ZIndex = 10
VerifyIcon.Parent = VerifyColor

local VerifyLabel = Instance.new("TextLabel")
VerifyLabel.AnchorPoint = Vector2.new(0.5, 0.5)
VerifyLabel.Position = UDim2.new(0.5, 10, 0.5, 0)
VerifyLabel.Size = UDim2.new(1, -44, 0.8, 0)
VerifyLabel.BackgroundTransparency = 1
VerifyLabel.FontFace = FontExtraBold
VerifyLabel.Text = "VERIFY KEY"
VerifyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyLabel.TextSize = 13
VerifyLabel.ZIndex = 10
VerifyLabel.Parent = VerifyColor
StyleL2Text(VerifyLabel, true)

local function CreateBevelIconButton(iconId, tint, offsetX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(42, 40)
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.Position = UDim2.new(1, offsetX, 0.5, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.ZIndex = 7
    btn.Parent = BtnRow
    AddScaleFeedback(btn, 1.06, 0.94)

    local base = Instance.new("Frame")
    base.AnchorPoint = Vector2.new(0.5, 0.5)
    base.Position = UDim2.fromScale(0.5, 0.5)
    base.Size = UDim2.fromScale(1, 0.94)
    base.BackgroundColor3 = Color3.fromRGB(16, 18, 20)
    base.BorderSizePixel = 0
    base.ZIndex = 7
    base.Parent = btn
    local st = Stroke(base, Color3.fromRGB(0, 0, 0), 1.6, 0)

    local col = Instance.new("Frame")
    col.AnchorPoint = Vector2.new(0.5, 0)
    col.Position = UDim2.fromScale(0.5, 0)
    col.Size = UDim2.fromScale(1, 0.9)
    col.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    col.BorderSizePixel = 0
    col.ZIndex = 8
    col.Parent = base

    local grad = Instance.new("UIGradient")
    grad.Color = DarkButtonGrad
    grad.Rotation = 90
    grad.Parent = col

    local inner = Instance.new("Frame")
    inner.AnchorPoint = Vector2.new(0.5, 0.5)
    inner.Position = UDim2.fromScale(0.5, 0.5)
    inner.Size = UDim2.fromScale(0.92, 0.84)
    inner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    inner.BackgroundTransparency = 0.82
    inner.BorderSizePixel = 0
    inner.ZIndex = 9
    inner.Parent = col

    local icon = Instance.new("ImageLabel")
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.Size = UDim2.fromScale(0.56, 0.56)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. iconId
    icon.ImageColor3 = tint
    icon.ScaleType = Enum.ScaleType.Fit
    icon.ZIndex = 10
    icon.Parent = col

    btn.MouseEnter:Connect(function()
        Tween(st, { Color = tint }, 0.12)
    end)
    btn.MouseLeave:Connect(function()
        Tween(st, { Color = Color3.fromRGB(0, 0, 0) }, 0.12)
    end)

    return btn
end

local IconDiscord = CreateBevelIconButton(ICONS.Discord, CONFIG.DiscordBlurple, 0)
local IconWebsite = CreateBevelIconButton(ICONS.Website, Color3.fromRGB(220, 235, 225), -48)
local IconGetKey  = CreateBevelIconButton(ICONS.GetKey,  CONFIG.Accent, -96)

local KeyFooter = Instance.new("Frame")
KeyFooter.AnchorPoint = Vector2.new(0.5, 1)
KeyFooter.Position = UDim2.new(0.5, 0, 1, -2)
KeyFooter.Size = UDim2.new(1, -4, 0, 22)
KeyFooter.BackgroundColor3 = Color3.fromRGB(12, 15, 14)
KeyFooter.BackgroundTransparency = 0.2
KeyFooter.BorderSizePixel = 0
KeyFooter.Parent = KeyPage
Stroke(KeyFooter, Color3.fromRGB(0, 0, 0), 1.4, 0)

local KeyFooterText = Instance.new("TextLabel")
KeyFooterText.Size = UDim2.fromScale(1, 1)
KeyFooterText.BackgroundTransparency = 1
KeyFooterText.FontFace = FontBold
KeyFooterText.Text = "Key Icon: Get Key  |  Globe: Website  |  Discord: Support"
KeyFooterText.TextColor3 = Color3.fromRGB(130, 240, 130)
KeyFooterText.TextSize = 10
KeyFooterText.Parent = KeyFooter
StyleL2Text(KeyFooterText, false)

local GameSectionLabel = Instance.new("TextLabel")
GameSectionLabel.Position = UDim2.fromOffset(2, 4)
GameSectionLabel.Size = UDim2.new(1, -4, 0, 16)
GameSectionLabel.BackgroundTransparency = 1
GameSectionLabel.FontFace = FontExtraBold
GameSectionLabel.Text = "SELECT MODULE  //  DETECTED GAMES"
GameSectionLabel.TextColor3 = CONFIG.Accent
GameSectionLabel.TextSize = 11
GameSectionLabel.TextXAlignment = Enum.TextXAlignment.Left
GameSectionLabel.Parent = GamePage
StyleL2Text(GameSectionLabel, false)

local GameScroll = Instance.new("ScrollingFrame")
GameScroll.Position = UDim2.fromOffset(2, 26)
GameScroll.Size = UDim2.new(1, -4, 1, -28)
GameScroll.BackgroundTransparency = 1
GameScroll.BorderSizePixel = 0
GameScroll.ScrollBarThickness = 3
GameScroll.ScrollBarImageColor3 = CONFIG.Accent
GameScroll.ScrollBarImageTransparency = 0.2
GameScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GameScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GameScroll.Parent = GamePage

local GameLayout = Instance.new("UIListLayout")
GameLayout.Padding = UDim.new(0, 8)
GameLayout.SortOrder = Enum.SortOrder.LayoutOrder
GameLayout.Parent = GameScroll

local GamePad = Instance.new("UIPadding")
GamePad.PaddingTop = UDim.new(0, 2)
GamePad.PaddingBottom = UDim.new(0, 4)
GamePad.PaddingLeft = UDim.new(0, 2)
GamePad.PaddingRight = UDim.new(0, 6)
GamePad.Parent = GameScroll

local function CreateGameCard(entry, index, isCurrent)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 60)
    card.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    card.BackgroundTransparency = isCurrent and 0.06 or 0.45
    card.BorderSizePixel = 0
    card.Text = ""
    card.AutoButtonColor = false
    card.LayoutOrder = index
    card.Parent = GameScroll

    local st = Stroke(card, isCurrent and CONFIG.Accent or Color3.fromRGB(0, 0, 0), 1.8, 0)

    local rowGrad = Instance.new("UIGradient")
    rowGrad.Color = isCurrent and RowActiveGrad or RowPlateGrad
    rowGrad.Rotation = 90
    rowGrad.Parent = card

    local innerBevel = Instance.new("Frame")
    innerBevel.AnchorPoint = Vector2.new(0.5, 0.5)
    innerBevel.Position = UDim2.fromScale(0.5, 0.5)
    innerBevel.Size = UDim2.new(1, -4, 1, -4)
    innerBevel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    innerBevel.BackgroundTransparency = 0.72
    innerBevel.BorderSizePixel = 0
    innerBevel.ZIndex = 2
    innerBevel.Parent = card

    local iconHolder = Instance.new("Frame")
    iconHolder.AnchorPoint = Vector2.new(0, 0.5)
    iconHolder.Position = UDim2.new(0, 8, 0.5, 0)
    iconHolder.Size = UDim2.fromOffset(44, 44)
    iconHolder.BackgroundColor3 = Color3.fromRGB(10, 14, 12)
    iconHolder.BorderSizePixel = 0
    iconHolder.ZIndex = 3
    iconHolder.Parent = card
    Stroke(iconHolder, isCurrent and CONFIG.Accent or Color3.fromRGB(45, 55, 48), 1.4, 0)

    local icon = Instance.new("ImageLabel")
    icon.AnchorPoint = Vector2.new(0.5, 0.5)
    icon.Position = UDim2.fromScale(0.5, 0.5)
    icon.Size = UDim2.fromScale(0.92, 0.92)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(entry.PlaceId) .. "&w=150&h=150"
    icon.ImageTransparency = isCurrent and 0 or 0.45
    icon.ScaleType = Enum.ScaleType.Crop
    icon.ZIndex = 4
    icon.Parent = iconHolder

    task.spawn(function()
        local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, entry.PlaceId)
        if ok and type(info) == "table" and info.IconImageAssetId and info.IconImageAssetId > 0 then
            icon.Image = "rbxassetid://" .. tostring(info.IconImageAssetId)
        end
    end)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Position = UDim2.fromOffset(60, 10)
    nameLabel.Size = UDim2.new(1, -148, 0, 20)
    nameLabel.BackgroundTransparency = 1
    nameLabel.FontFace = FontExtraBold
    nameLabel.Text = entry.Name or "Unknown"
    nameLabel.TextColor3 = isCurrent and CONFIG.Text or CONFIG.Placeholder
    nameLabel.TextSize = 14
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.ZIndex = 4
    nameLabel.Parent = card
    StyleL2Text(nameLabel, isCurrent)

    local subLabel = Instance.new("TextLabel")
    subLabel.Position = UDim2.fromOffset(60, 32)
    subLabel.Size = UDim2.new(1, -148, 0, 16)
    subLabel.BackgroundTransparency = 1
    subLabel.FontFace = FontBold
    subLabel.RichText = true
    subLabel.Text = isCurrent
        and ('<font color="#3AFF37">DETECTED</font> | ' .. tostring(entry.Subtitle or "Ready to launch"))
        or ('<font color="#9AA3B5">LOCKED</font> | ' .. tostring(entry.Subtitle or "Join game to unlock"))
    subLabel.TextColor3 = CONFIG.Placeholder
    subLabel.TextSize = 10
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subLabel.ZIndex = 4
    subLabel.Parent = card
    StyleL2Text(subLabel, false)

    local actionBadge = Instance.new("Frame")
    actionBadge.AnchorPoint = Vector2.new(1, 0.5)
    actionBadge.Position = UDim2.new(1, -8, 0.5, 0)
    actionBadge.Size = UDim2.fromOffset(74, 30)
    actionBadge.BackgroundColor3 = isCurrent and Color3.fromRGB(12, 85, 12) or Color3.fromRGB(18, 20, 22)
    actionBadge.BorderSizePixel = 0
    actionBadge.ZIndex = 4
    actionBadge.Parent = card
    Stroke(actionBadge, Color3.fromRGB(0, 0, 0), 1.6, 0)

    local actionColor = Instance.new("Frame")
    actionColor.AnchorPoint = Vector2.new(0.5, 0)
    actionColor.Position = UDim2.fromScale(0.5, 0)
    actionColor.Size = UDim2.fromScale(1, 0.9)
    actionColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    actionColor.BorderSizePixel = 0
    actionColor.ZIndex = 5
    actionColor.Parent = actionBadge

    local actionGrad = Instance.new("UIGradient")
    actionGrad.Color = isCurrent and NeonButtonGrad or DarkButtonGrad
    actionGrad.Rotation = 90
    actionGrad.Parent = actionColor

    local actionInner = Instance.new("Frame")
    actionInner.AnchorPoint = Vector2.new(0.5, 0.5)
    actionInner.Position = UDim2.fromScale(0.5, 0.5)
    actionInner.Size = UDim2.fromScale(0.95, 0.84)
    actionInner.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    actionInner.BackgroundTransparency = 0.86
    actionInner.BorderSizePixel = 0
    actionInner.ZIndex = 6
    actionInner.Parent = actionColor

    local actionText = Instance.new("TextLabel")
    actionText.AnchorPoint = Vector2.new(0.5, 0.5)
    actionText.Position = UDim2.fromScale(0.5, 0.5)
    actionText.Size = UDim2.fromScale(0.92, 0.8)
    actionText.BackgroundTransparency = 1
    actionText.FontFace = FontExtraBold
    actionText.Text = isCurrent and "LAUNCH" or "LOCKED"
    actionText.TextColor3 = isCurrent and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 155, 160)
    actionText.TextSize = 11
    actionText.ZIndex = 7
    actionText.Parent = actionColor
    StyleL2Text(actionText, isCurrent)

    if isCurrent then
        AddScaleFeedback(card, 1.015, 0.98)
    end

    return card
end

local function GetOrderedGames()
    local current = nil
    for _, e in ipairs(GAMES) do
        if IsCurrentPlace(e) then
            current = e
            break
        end
    end

    if not current then
        warn(("[L2-HUB] No match for current game — PlaceId=%s, GameId=%s")
            :format(tostring(game.PlaceId), tostring(game.GameId)))
    end

    local ordered = {}
    if current then
        table.insert(ordered, current)
    end
    for _, e in ipairs(GAMES) do
        if e ~= current then
            table.insert(ordered, e)
        end
    end
    return ordered, current
end

local function BuildGameList()
    for _, child in ipairs(GameScroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    if #GAMES == 0 then
        local empty = Instance.new("TextLabel")
        empty.Size = UDim2.new(1, 0, 0, 60)
        empty.BackgroundTransparency = 1
        empty.FontFace = FontBold
        empty.Text = "No games registered in L2HUB_GAMES."
        empty.TextColor3 = CONFIG.Placeholder
        empty.TextSize = 12
        empty.LayoutOrder = 1
        empty.Parent = GameScroll
        StyleL2Text(empty, false)
        return
    end

    local ordered, current = GetOrderedGames()
    for i, entry in ipairs(ordered) do
        local isCurrent = (entry == current)
        local card = CreateGameCard(entry, i, isCurrent)

        if isCurrent then
            card.MouseButton1Click:Connect(function()
                FireVerified(entry)
                Tween(UIScale, { Scale = 0 }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                task.wait(0.25)
                ScreenGui:Destroy()
            end)
        end
    end
end

BuildGameList()

local function ShowGamePage()
    KeyPage.Visible = false
    GamePage.Visible = true
    Tween(UIScaleHolder, {
        Size = UDim2.fromOffset(CONFIG.ExpandedSize.X, CONFIG.ExpandedSize.Y)
    }, 0.35, Enum.EasingStyle.Quint)
end

local function NormalizeKey(s)
    return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")):upper()
end

local verifying = false

local function PerformVerify(rawKey, isAuto)
    if verifying then return end

    local typed = NormalizeKey(rawKey)
    if typed == "" then
        if not isAuto then
            Toast("Please enter your key first.", false)
        end
        return
    end

    verifying = true
    VerifyLabel.Text = "VERIFYING..."

    task.spawn(function()
        task.wait(isAuto and 0.3 or 0.9)
        if typed == NormalizeKey(CONFIG.Key) then
            SaveKey(typed)
            Toast(isAuto and "Key restored. Access granted." or "Access granted.", true)
            VerifyLabel.Text = "VERIFIED"
            task.wait(0.5)

            if autoExecEnabled then
                local _, current = GetOrderedGames()
                if current then
                    Toast("Auto-Executing: " .. tostring(current.Name), true)
                    task.wait(0.35)
                    FireVerified(current)
                    Tween(UIScale, { Scale = 0 }, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                    task.wait(0.25)
                    ScreenGui:Destroy()
                else
                    ShowGamePage()
                end
            else
                ShowGamePage()
            end
        else
            Toast("Invalid key. Please try again.", false)
            VerifyLabel.Text = "VERIFY KEY"
            verifying = false
            if isAuto then ClearKey() end
        end
    end)
end

VerifyBtn.MouseButton1Click:Connect(function()
    PerformVerify(KeyInput.Text, false)
end)

IconGetKey.MouseButton1Click:Connect(function()
    local copied, url = CopyURL(CONFIG.GetKeyURL)
    Toast(copied and "Get Key link copied." or url, true)
end)

IconWebsite.MouseButton1Click:Connect(function()
    local copied, url = CopyURL(CONFIG.WebsiteURL)
    Toast(copied and "Website link copied." or url, true)
end)

IconDiscord.MouseButton1Click:Connect(function()
    local copied, url = CopyURL(CONFIG.DiscordInvite)
    Toast(copied and "Discord link copied." or url, true)
end)

do
    local dragging, dragStart, startPos = false, nil, nil
    local dragArea = Instance.new("TextButton")
    dragArea.Size = UDim2.new(1, -40, 0, 38)
    dragArea.BackgroundTransparency = 1
    dragArea.Text = ""
    dragArea.ZIndex = 15
    dragArea.Parent = TopBar

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = UIScaleHolder.Position
        end
    end)

    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            UIScaleHolder.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local targetScale = UIScale.Scale
UIScale.Scale = 0.85
Root.BackgroundTransparency = 1
Tween(UIScale, { Scale = targetScale }, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
Tween(Root, { BackgroundTransparency = 0.22 }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

task.delay(0.5, function()
    pcall(function() KeyInput:CaptureFocus() end)
end)

task.spawn(function()
    local saved = LoadKey()
    if saved and saved ~= "" then
        KeyInput.Text = saved
        PerformVerify(saved, true)
    end
end)