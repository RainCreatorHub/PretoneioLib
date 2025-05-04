local PretoneioLib = {}

-- Serviços
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Tema base
local Themes = {
    Dark = {
        Background = Color3.fromRGB(25, 25, 25),
        Tab = Color3.fromRGB(35, 35, 35),
        Button = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 120, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Tab = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(20, 20, 20),
        Accent = Color3.fromRGB(0, 120, 255)
    },
    Blue = {
        Background = Color3.fromRGB(15, 15, 35),
        Tab = Color3.fromRGB(25, 25, 60),
        Button = Color3.fromRGB(30, 30, 80),
        Text = Color3.fromRGB(255, 255, 255),
        Accent = Color3.fromRGB(0, 150, 255)
    }
}

function PretoneioLib:MakeWindow(config)
    local Theme = Themes[(config.Theme or "Dark"):gsub("^%l", string.upper)] or Themes.Dark

    local gui = Instance.new("ScreenGui")
    gui.Name = "PretoneioUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    -- Janela principal
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local cornerMain = Instance.new("UICorner", main)
    cornerMain.CornerRadius = UDim.new(0, 12)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundTransparency = 1
    title.Text = (config.Title or "Interface")
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.Parent = main

    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = (config.SubTitle or "")
    subtitle.TextColor3 = Theme.Text
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14
    subtitle.Parent = main

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(1, 0, 0, 30)
    tabHolder.Position = UDim2.new(0, 0, 0, 55)
    tabHolder.BackgroundTransparency = 1
    tabHolder.Parent = main

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, -10, 1, -95)
    contentHolder.Position = UDim2.new(0, 5, 0, 90)
    contentHolder.BackgroundTransparency = 1
    contentHolder.Parent = main

    local window = {}
    local tabs = {}

    function window:MakeTab(tabData)
        local tab = {}

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.Position = UDim2.new(0, #tabs * 105, 0, 0)
        tabButton.BackgroundColor3 = Theme.Tab
        tabButton.TextColor3 = Theme.Text
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 16
        tabButton.Text = tostring(tabData[1])
        tabButton.Parent = tabHolder

        local tabCorner = Instance.new("UICorner", tabButton)
        tabCorner.CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.Parent = contentHolder

        local layout = Instance.new("UIListLayout", tabContent)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        tabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Theme.Tab
            end
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
        end)

        function tab:AddButton(buttonData)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.Text = tostring(buttonData[1])
            btn.BackgroundColor3 = Theme.Button
            btn.TextColor3 = Theme.Text
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 16
            btn.Parent = tabContent

            local btnCorner = Instance.new("UICorner", btn)
            btnCorner.CornerRadius = UDim.new(0, 8)

            btn.MouseEnter:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Accent }):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Button }):Play()
            end)

            function btn:SetCallback(callback)
                btn.MouseButton1Click:Connect(callback)
            end

            return btn
        end

        table.insert(tabs, {
            Button = tabButton,
            Content = tabContent
        })

        if #tabs == 1 then
            tabContent.Visible = true
            tabButton.BackgroundColor3 = Theme.Accent
        end

        return tab
    end

    return window
end

return PretoneioLib
