-- OnlyLegFish.lua
-- Fishing UI / controller for your own Roblox experience

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local enabled = false
local autoCast = true
local autoReel = true
local autoThrow = true
local fishingPosition = nil

local gui = Instance.new("ScreenGui")
gui.Name = "Only Leg Fish"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(560, 360)
window.Position = UDim2.new(0.5, -280, 0.5, -180)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
window.BorderSizePixel = 0
window.Parent = gui

Instance.new("UICorner", window).CornerRadius = UDim.new(0, 12)

local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, 48)
top.BackgroundColor3 = Color3.fromRGB(27, 27, 32)
top.BorderSizePixel = 0
top.Parent = window

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(16, 0)
title.BackgroundTransparency = 1
title.Text = "Only Leg Fish"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = top

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(40, 40)
minimize.Position = UDim2.new(1, -88, 0, 4)
minimize.BackgroundTransparency = 1
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 22
minimize.Font = Enum.Font.GothamBold
minimize.Parent = top

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40, 40)
close.Position = UDim2.new(1, -44, 0, 4)
close.BackgroundTransparency = 1
close.Text = "×"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 24
close.Font = Enum.Font.GothamBold
close.Parent = top

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.fromOffset(140, 312)
sidebar.Position = UDim2.fromOffset(0, 48)
sidebar.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
sidebar.BorderSizePixel = 0
sidebar.Parent = window

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -140, 1, -48)
content.Position = UDim2.fromOffset(140, 48)
content.BackgroundTransparency = 1
content.Parent = window

local pages = {}

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, -30, 1, -30)
    page.Position = UDim2.fromOffset(15, 15)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    pages[name] = page
    return page
end

local homePage = createPage("Home")
local mainPage = createPage("Main")
local settingsPage = createPage("Settings")
local configsPage = createPage("Configs")

local function pageTitle(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 35)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 22
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

pageTitle(homePage, "Welcome to Only Leg Fish")

local description = Instance.new("TextLabel")
description.Size = UDim2.new(1, -10, 0, 130)
description.Position = UDim2.fromOffset(0, 50)
description.BackgroundTransparency = 1
description.Text = "Only Leg Fish is a fishing automation system\nfor your Roblox Studio project.\n\nUse the tabs on the left to configure your fishing settings."
description.TextColor3 = Color3.fromRGB(190, 190, 195)
description.TextSize = 15
description.Font = Enum.Font.Gotham
description.TextWrapped = true
description.TextXAlignment = Enum.TextXAlignment.Left
description.TextYAlignment = Enum.TextYAlignment.Top
description.Parent = homePage

local function button(parent, text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -10, 0, 42)
    b.Position = UDim2.fromOffset(0, y)
    b.BackgroundColor3 = Color3.fromRGB(40, 40, 47)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextSize = 14
    b.Font = Enum.Font.GothamMedium
    b.Parent = parent

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    return b
end

pageTitle(mainPage, "Fishing")

local autoFishButton = button(mainPage, "Auto Fish: OFF", 50)
local castButton = button(mainPage, "Auto Cast: ON", 100)
local reelButton = button(mainPage, "Auto Reel: ON", 150)
local throwButton = button(mainPage, "Auto Throw: ON", 200)

autoFishButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    autoFishButton.Text = "Auto Fish: " .. (enabled and "ON" or "OFF")
end)

castButton.MouseButton1Click:Connect(function()
    autoCast = not autoCast
    castButton.Text = "Auto Cast: " .. (autoCast and "ON" or "OFF")
end)

reelButton.MouseButton1Click:Connect(function()
    autoReel = not autoReel
    reelButton.Text = "Auto Reel: " .. (autoReel and "ON" or "OFF")
end)

throwButton.MouseButton1Click:Connect(function()
    autoThrow = not autoThrow
    throwButton.Text = "Auto Throw: " .. (autoThrow and "ON" or "OFF")
end)

pageTitle(settingsPage, "Settings")

local positionButton = button(settingsPage, "Set Fishing Position", 55)

positionButton.MouseButton1Click:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    if root then
        fishingPosition = root.Position
        positionButton.Text = "Position Saved ✓"

        task.delay(1.5, function()
            if positionButton.Parent then
                positionButton.Text = "Set Fishing Position"
            end
        end)
    end
end)

pageTitle(configsPage, "Configs")

local configInfo = Instance.new("TextLabel")
configInfo.Size = UDim2.new(1, -10, 0, 100)
configInfo.Position = UDim2.fromOffset(0, 55)
configInfo.BackgroundTransparency = 1
configInfo.Text = "Configs\n\nSave and load your fishing settings here."
configInfo.TextColor3 = Color3.fromRGB(190, 190, 195)
configInfo.TextSize = 15
configInfo.Font = Enum.Font.Gotham
configInfo.TextXAlignment = Enum.TextXAlignment.Left
configInfo.Parent = configsPage

local function tab(name, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -16, 0, 42)
    b.Position = UDim2.fromOffset(8, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 35, 41)
    b.BorderSizePixel = 0
    b.Text = name
    b.TextColor3 = Color3.fromRGB(210, 210, 215)
    b.TextSize = 14
    b.Font = Enum.Font.GothamMedium
    b.Parent = sidebar

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)

    return b
end

local homeTab = tab("Home", 15)
local mainTab = tab("Main", 65)
local settingsTab = tab("Settings", 115)
local configsTab = tab("Configs", 165)

local function showPage(name)
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
end

homeTab.MouseButton1Click:Connect(function()
    showPage("Home")
end)

mainTab.MouseButton1Click:Connect(function()
    showPage("Main")
end)

settingsTab.MouseButton1Click:Connect(function()
    showPage("Settings")
end)

configsTab.MouseButton1Click:Connect(function()
    showPage("Configs")
end)

showPage("Home")

local dragging = false
local dragStart
local startPosition

top.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = window.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart

        window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

local minimized = false

minimize.MouseButton1Click:Connect(function()
    minimized = not minimized

    sidebar.Visible = not minimized
    content.Visible = not minimized

    window.Size = minimized
        and UDim2.fromOffset(560, 48)
        or UDim2.fromOffset(560, 360)
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end

    if input.KeyCode == Enum.KeyCode.F then
        enabled = not enabled
        autoFishButton.Text = "Auto Fish: " .. (enabled and "ON" or "OFF")
    end
end)

-- Put YOUR game's fishing functions here.
local function Cast()
    -- Your own game's cast logic
end

local function Reel()
    -- Your own game's reel logic
end

local function Throw()
    -- Your own game's throw logic
end

task.spawn(function()
    while gui.Parent do
        task.wait(0.2)

        if enabled then
            if autoCast then
                Cast()
            end

            task.wait(1)

            if autoReel then
                Reel()
            end

            task.wait(1)

            if autoThrow then
                Throw()
            end

            task.wait(2)
        end
    end
end)
