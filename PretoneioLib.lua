-- PretoneioLib
local PretoneioLib = {}

-- Services 
local Players = game:GetService("Players") 
local LocalPlayer = Players.LocalPlayer 
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Tema predefinido 
local Themes = {
 Dark = {
   Background = Color3.fromRGB(25, 25, 25), 
   Tab = Color3.fromRGB(35, 35, 35), 
   TabSelected = Color3.fromRGB(0, 120, 215), 
   Element = Color3.fromRGB(45, 45, 45), 
   Text = Color3.fromRGB(255, 255, 255)
  }, 
  
 Light = {
    Background = Color3.fromRGB(245, 245, 245),
    Tab = Color3.fromRGB(220, 220, 220),
    TabSelected = Color3.fromRGB(0, 120, 215),
    Element = Color3.fromRGB(230, 230, 230),
    Text = Color3.fromRGB(10, 10, 10)
  },
  Blue = {
    Background = Color3.fromRGB(20, 20, 35),
    Tab = Color3.fromRGB(30, 30, 60),
    TabSelected = Color3.fromRGB(0, 180, 255),
    Element = Color3.fromRGB(40, 40, 80),
    Text = Color3.fromRGB(255, 255, 255)
  }
}

function PretoneioLib:MakeWindow(data) local theme = Themes[(data.Theme or "Dark"):gsub("^%l", string.upper)] or Themes.Dark

local gui = Instance.new("ScreenGui")
gui.Name = "PretoneioUI"
gui.ResetOnSpawn = false
gui.Parent = PlayerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 450, 0, 350)
main.Position = UDim2.new(0.5, -225, 0.5, -175)
main.BackgroundColor3 = theme.Background
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Parent = gui

local title = Instance.new("TextLabel")
title.Text = tostring(data.Title or "Interface")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = theme.Tab
title.TextColor3 = theme.Text
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.Parent = main

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = main

local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1, 0, 1, -70)
tabContent.Position = UDim2.new(0, 0, 0, 70)
tabContent.BackgroundTransparency = 1
tabContent.ClipsDescendants = true
tabContent.Parent = main

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Parent = tabContainer

local currentTab
local window = {}

function window:MakeTab(tabData)
    local tabButton = Instance.new("TextButton")
    tabButton.Text = tostring(tabData[1] or "Aba")
    tabButton.Size = UDim2.new(0, 100, 1, 0)
    tabButton.BackgroundColor3 = theme.Tab
    tabButton.TextColor3 = theme.Text
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    tabButton.AutoButtonColor = false
    tabButton.Parent = tabContainer

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(1, 0, 0, 2)
    indicator.Position = UDim2.new(0, 0, 1, -2)
    indicator.BackgroundColor3 = theme.TabSelected
    indicator.Visible = false
    indicator.BorderSizePixel = 0
    indicator.Parent = tabButton

    local tabFrame = Instance.new("Frame")
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.Parent = tabContent

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = tabFrame

    tabButton.MouseButton1Click:Connect(function()
        if currentTab then
            currentTab.Frame.Visible = false
            currentTab.Indicator.Visible = false
            currentTab.Button.BackgroundColor3 = theme.Tab
        end
        tabFrame.Visible = true
        indicator.Visible = true
        tabButton.BackgroundColor3 = theme.TabSelected
        currentTab = { Frame = tabFrame, Indicator = indicator, Button = tabButton }
    end)

    local tab = {}

    function tab:AddButton(buttonData)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -20, 0, 30)
        button.BackgroundColor3 = theme.Element
        button.TextColor3 = theme.Text
        button.Font = Enum.Font.Gotham
        button.TextSize = 14
        button.Text = tostring(buttonData[1] or "Botão")
        button.BorderSizePixel = 0
        button.Position = UDim2.new(0, 10, 0, 0)
        button.AutoButtonColor = true
        button.Parent = tabFrame

        button.MouseButton1Click:Connect(function()
            if buttonData.Callback then
                buttonData.Callback()
            end
        end)
    end

    return tab
end

return window

end

return PretoneioLib
