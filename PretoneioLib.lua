-- PretoneioLib com estilo 
local PretoneioLib = {}

-- Serviços 
local Players = game:GetService("Players") 
local TweenService = game:GetService("TweenService") 
local UIS = game:GetService("UserInputService")

-- Função principal 
function PretoneioLib:MakeWindow(data) 
local gui = Instance.new("ScreenGui") 
  gui.Name = "PretoneioUI" 
  gui.ResetOnSpawn = false 
  gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

-- Tela de introdução (opcional)
if data.Intro then
    local introFrame = Instance.new("Frame")
    introFrame.Size = UDim2.new(1, 0, 1, 0)
    introFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    introFrame.ZIndex = 10
    introFrame.Parent = gui

    local introText = Instance.new("TextLabel")
    introText.Text = tostring(data.IntroText)
    introText.TextColor3 = Color3.fromRGB(255, 255, 255)
    introText.Font = Enum.Font.GothamBold
    introText.TextScaled = true
    introText.Size = UDim2.new(0.5, 0, 0.2, 0)
    introText.Position = UDim2.new(0.25, 0, 0.4, 0)
    introText.BackgroundTransparency = 1
    introText.Parent = introFrame

    task.wait(data.IntroDuration or 3)
    introFrame:Destroy()
end

-- Janela principal
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 350)
main.Position = UDim2.new(0.5, -250, 0.5, -175)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 8)
uicorner.Parent = main

local title = Instance.new("TextLabel")
title.Text = tostring(data.Title or "Janela")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.TextColor3 = Color3.fromRGB(0, 170, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Text = tostring(data.SubTitle or "")
subtitle.Size = UDim2.new(1, 0, 0, 25)
subtitle.Position = UDim2.new(0, 0, 0, 40)
subtitle.BackgroundTransparency = 1
subtitle.TextColor3 = Color3.fromRGB(180, 180, 180)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 14
subtitle.Parent = main

local tabsHolder = Instance.new("Frame")
tabsHolder.Size = UDim2.new(1, 0, 0, 30)
tabsHolder.Position = UDim2.new(0, 0, 0, 65)
tabsHolder.BackgroundTransparency = 1
tabsHolder.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabsHolder

local contentHolder = Instance.new("Frame")
contentHolder.Size = UDim2.new(1, -10, 1, -105)
contentHolder.Position = UDim2.new(0, 5, 0, 100)
contentHolder.BackgroundTransparency = 1
contentHolder.Parent = main

local window = {
    Tabs = {}
}

function window:MakeTab(tabData)
    local tabButton = Instance.new("TextButton")
    tabButton.Text = tostring(tabData[1])
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.AutoButtonColor = true
    tabButton.Parent = tabsHolder

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 6)
    uicorner.Parent = tabButton

    local tabFrame = Instance.new("Frame")
    tabFrame.Visible = false
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = contentHolder

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = tabFrame

    tabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(contentHolder:GetChildren()) do
            if t:IsA("Frame") then t.Visible = false end
        end
        tabFrame.Visible = true
    end)

    local tab = {}

    function tab:AddButton(buttonData)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, 0, 0, 30)
        button.Text = tostring(buttonData[1])
        button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.Font = Enum.Font.GothamBold
        button.TextSize = 14
        button.Parent = tabFrame

        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0, 6)
        uicorner.Parent = button

        button.MouseButton1Click:Connect(function()
            if buttonData.Callback then
                buttonData.Callback()
            end
        end)
    end

    table.insert(window.Tabs, tab)
    return tab
end

return window

end

return PretoneioLib
