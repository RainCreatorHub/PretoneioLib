local PretoneioLib = {}

-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

function PretoneioLib:MakeWindow(data)
    local gui = Instance.new("ScreenGui")
    gui.Name = "PretoneioUI"
    gui.ResetOnSpawn = false
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Name = tostring(data.Name)
    main.Size = UDim2.new(0, 400, 0, 300)
    main.Position = UDim2.new(0.3, 0, 0.3, 0)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true
    main.Parent = gui

    local title = Instance.new("TextLabel")
    title.Text = tostring(data.Name)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.SourceSansBold
    title.TextSize = 20
    title.Parent = main

    -- Intro opcional
    if data.Intro then
        local introLabel = Instance.new("TextLabel")
        introLabel.Size = UDim2.new(1, 0, 1, 0)
        introLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        introLabel.BackgroundTransparency = 0.3
        introLabel.Text = tostring(data.IntroText or "Bem-vindo!")
        introLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        introLabel.TextSize = 28
        introLabel.Font = Enum.Font.SourceSansBold
        introLabel.ZIndex = 10
        introLabel.Parent = main

        task.delay(data.IntroDuration or 3, function()
            introLabel:Destroy()
        end)
    end

    local tabHolder = Instance.new("Frame")
    tabHolder.Size = UDim2.new(0, 100, 1, -30)
    tabHolder.Position = UDim2.new(0, 0, 0, 30)
    tabHolder.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabHolder.BorderSizePixel = 0
    tabHolder.Parent = main

    local contentHolder = Instance.new("Frame")
    contentHolder.Size = UDim2.new(1, -100, 1, -30)
    contentHolder.Position = UDim2.new(0, 100, 0, 30)
    contentHolder.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    contentHolder.BorderSizePixel = 0
    contentHolder.Parent = main

    local window = {
        Frame = main,
        Tabs = {},
        Name = tostring(data.Name)
    }

    function window:MakeTab(tabData)
        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Visible = false
        tabContent.BackgroundTransparency = 1
        tabContent.Parent = contentHolder

        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, 0, 0, 30)
        tabButton.Text = tostring(tabData.Name)
        tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabButton.Font = Enum.Font.SourceSans
        tabButton.TextSize = 18
        tabButton.Parent = tabHolder

        local yOffset = 10
        local tab = {
            Name = tostring(tabData.Name),
            Sections = {},
            Frame = tabContent
        }

        function tab:AddSection(sectionData)
            local sectionLabel = Instance.new("TextLabel")
            sectionLabel.Text = tostring(sectionData.Name)
            sectionLabel.Size = UDim2.new(1, -10, 0, 25)
            sectionLabel.Position = UDim2.new(0, 5, 0, yOffset)
            sectionLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            sectionLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            sectionLabel.Font = Enum.Font.SourceSansBold
            sectionLabel.TextSize = 16
            sectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            sectionLabel.Parent = tabContent

            yOffset = yOffset + 30

            local section = {
                Name = sectionData.Name,
                Elements = {}
            }

            function section:AddButton(buttonData)
                local button = Instance.new("TextButton")
                button.Text = tostring(buttonData.Name)
                button.Size = UDim2.new(1, -10, 0, 30)
                button.Position = UDim2.new(0, 5, 0, yOffset)
                button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                button.TextColor3 = Color3.fromRGB(255, 255, 255)
                button.Font = Enum.Font.SourceSans
                button.TextSize = 16
                button.Parent = tabContent

                button.MouseButton1Click:Connect(function()
                    if buttonData.Callback then
                        buttonData.Callback()
                    end
                end)

                table.insert(section.Elements, button)
                yOffset = yOffset + 35
                return button
            end

            table.insert(tab.Sections, section)
            return section
        end

        -- Alternar entre abas
        tabButton.MouseButton1Click:Connect(function()
            for _, otherTab in pairs(window.Tabs) do
                otherTab.Frame.Visible = false
            end
            tabContent.Visible = true
        end)

        -- Primeira aba visível por padrão
        if #window.Tabs == 0 then
            tabContent.Visible = true
        end

        table.insert(window.Tabs, tab)
        return tab
    end

    return window
end

return PretoneioLib
