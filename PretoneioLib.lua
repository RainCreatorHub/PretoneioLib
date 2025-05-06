local PretoneioLib = {}
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Temas
local Themes = {
    Dark = {
        Background = Color3.fromRGB(30, 30, 30),
        Tab = Color3.fromRGB(40, 40, 40),
        Button = Color3.fromRGB(50, 50, 50),
        Text = Color3.fromRGB(255, 255, 255)
    },
    Light = {
        Background = Color3.fromRGB(240, 240, 240),
        Tab = Color3.fromRGB(220, 220, 220),
        Button = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(0, 0, 0)
    },
    Blue = {
        Background = Color3.fromRGB(20, 20, 40),
        Tab = Color3.fromRGB(40, 60, 100),
        Button = Color3.fromRGB(60, 80, 140),
        Text = Color3.fromRGB(255, 255, 255)
    }
}

function PretoneioLib:MakeWindow(config)
    local theme = Themes[(config.Theme or "Dark"):lower():gsub("^%l", string.upper)] or Themes.Dark

    local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
    gui.Name = "PretoneioLib"
    gui.ResetOnSpawn = false

    -- Main Frame
    local main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, 420, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    -- Title
    local title = Instance.new("TextLabel", main)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = tostring(config.Title or "Janela")
    title.TextColor3 = theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18

    -- SubTitle
    local subtitle = Instance.new("TextLabel", main)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 0, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = tostring(config.SubTitle or "")
    subtitle.TextColor3 = theme.Text
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 14

    -- Tabs Container
    local tabsFrame = Instance.new("Frame", main)
    tabsFrame.Position = UDim2.new(0, 0, 0, 55)
    tabsFrame.Size = UDim2.new(1, 0, 0, 30)
    tabsFrame.BackgroundTransparency = 1
    tabsFrame.LayoutOrder = 1

    -- Content Frame
    local contentFrame = Instance.new("Frame", main)
    contentFrame.Position = UDim2.new(0, 0, 0, 90)
    contentFrame.Size = UDim2.new(1, 0, 1, -90)
    contentFrame.BackgroundTransparency = 1

    -- Minimize Button
    local minimize = Instance.new("TextButton", main)
    minimize.Size = UDim2.new(0, 30, 0, 30)
    minimize.Position = UDim2.new(1, -35, 0, 5)
    minimize.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    minimize.Text = "-"
    minimize.TextColor3 = Color3.fromRGB(0, 0, 0)
    minimize.Font = Enum.Font.GothamBold
    minimize.TextSize = 20
    Instance.new("UICorner", minimize).CornerRadius = UDim.new(1, 0)

    local minimized = false
    local originalSize = main.Size
    local minimizedSize = UDim2.new(0, 420, 0, 50)

    -- Function to Minimize/Maximize the GUI
    minimize.MouseButton1Click:Connect(function()
        if minimized then
            TweenService:Create(main, TweenInfo.new(0.3), {Size = originalSize}):Play()
            for _, v in pairs(main:GetChildren()) do
                if v ~= minimize then v.Visible = true end
            end
            minimize.Text = "-"
        else
            TweenService:Create(main, TweenInfo.new(0.3), {Size = minimizedSize}):Play()
            for _, v in pairs(main:GetChildren()) do
                if v ~= minimize and v ~= title and v ~= subtitle then
                    v.Visible = false
                end
            end
            minimize.Text = "+"
        end
        minimized = not minimized
    end)

    -- Delete Button
    local deleteButton = Instance.new("TextButton", main)
    deleteButton.Size = UDim2.new(0, 30, 0, 30)
    deleteButton.Position = UDim2.new(1, -70, 0, 5)
    deleteButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    deleteButton.Text = "X"
    deleteButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    deleteButton.Font = Enum.Font.GothamBold
    deleteButton.TextSize = 20
    Instance.new("UICorner", deleteButton).CornerRadius = UDim.new(1, 0)

    -- Function to Delete the GUI
    deleteButton.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- Tabs
    local currentTab
    local window = {}

    function window:MakeTab(tabInfo)
        local tabButton = Instance.new("TextButton", tabsFrame)
        tabButton.Size = UDim2.new(0, 100, 1, 0)
        tabButton.BackgroundColor3 = theme.Tab
        tabButton.Text = tabInfo[1] or "Aba"
        tabButton.TextColor3 = theme.Text
        tabButton.Font = Enum.Font.GothamBold
        tabButton.TextSize = 14
        Instance.new("UICorner", tabButton).CornerRadius = UDim.new(0, 8)

        local tabContent = Instance.new("Frame", contentFrame)
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false

        local layout = Instance.new("UIListLayout", tabContent)
        layout.Padding = UDim.new(0, 6)
        layout.SortOrder = Enum.SortOrder.LayoutOrder

        tabButton.MouseButton1Click:Connect(function()
            if currentTab then currentTab.Visible = false end
            tabContent.Visible = true
            currentTab = tabContent
        end)

        local tab = {}

        function tab:AddButton(btnInfo)
            local button = Instance.new("TextButton", tabContent)
            button.Size = UDim2.new(1, -12, 0, 30)
            button.BackgroundColor3 = theme.Button
            button.TextColor3 = theme.Text
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Text = btnInfo[1] or "Botão"
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

            button.MouseButton1Click:Connect(function()
                if btnInfo.Callback then
                    btnInfo.Callback()
                end
            end)
        end

        function tab:AddSection(sectionInfo)
            local sectionContainer = Instance.new("Frame", tabContent)
            sectionContainer.Size = UDim2.new(1, 0, 0, 30)
            sectionContainer.BackgroundTransparency = 1
            sectionContainer.LayoutOrder = 1

            local sectionTitle = Instance.new("TextLabel", sectionContainer)
            sectionTitle.Size = UDim2.new(1, 0, 0, 20)
            sectionTitle.BackgroundTransparency = 1
            sectionTitle.Text = sectionInfo[1] or "Seção"
            sectionTitle.TextColor3 = theme.Text
            sectionTitle.Font = Enum.Font.Gotham
            sectionTitle.TextSize = 14

            return sectionContainer
        end

        return tab
    end

    return window
end

return PretoneioLib
